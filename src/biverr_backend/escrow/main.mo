import HashMap "mo:base/HashMap";
import Nat64 "mo:base/Nat64";
import Result "mo:base/Result";
import Option "mo:base/Option";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Principal "mo:base/Principal";
import TaskTypes "../tasks/types";
import BidTypes "../bids/types";
import LedgerCanister "canister:ledger_canister";
import UserCanister "canister:user_canister";

actor {
    public type TaskId = TaskTypes.TaskId;
    public type Bid = BidTypes.Bid;
    type CompositeKey = (Nat64, Nat64);

    var taskEscrow: HashMap.HashMap<TaskId, Nat64> = HashMap.HashMap<TaskId, Nat64>(0, Nat64.equal, Nat64.toNat32);
    var bidEscrow: HashMap.HashMap<TaskId, HashMap.HashMap<Principal, Bid>> = HashMap.HashMap<TaskId, HashMap.HashMap<Principal, Bid>>(0, Nat64.equal, Nat64.toNat32);

    public func getTaskEscrow(): async [(TaskId, Nat64)] {
        return Iter.toArray(taskEscrow.entries());
    };

    public func getTaskbids(taskId: TaskId): async [(Principal, Bid)] {
        switch (bidEscrow.get(taskId)) {
            case (?bidsMap) return Iter.toArray(bidsMap.entries());
            case null return [];
        }
    };

    public func fundTask(taskId: Nat64, amount: Nat64, p: Principal): async Result.Result<(), Text> {
        let balance = await LedgerCanister.getBalance(p);
        let isClient = await UserCanister._isClient(p);

        if(not isClient) {
            return #err("Only client are allowed");
        };

        if(balance < amount) {
            return #err("Insufficient balance");
        };

        switch(await LedgerCanister._burn(amount, p)) {
            case (#err(errMsg)) {
                return #err(errMsg);
            };
            case (#ok) {
                taskEscrow.put(taskId, amount);
                return #ok();
            };
        }
    };

    public func fundBid(taskId: Nat64, bid: Bid, p: Principal): async Result.Result<(), Text> {
        let balance = await LedgerCanister.getBalance(p);
        let isFreelancer = await UserCanister._isFreelancer(p);

        if(not isFreelancer) {
            return #err("Only client are allowed");
        };

        if(balance < bid.amount) {
            return #err("Insufficient balance");
        };


        switch(await LedgerCanister._burn(bid.amount, p)) {
            case (#err(errMsg)) {
                return #err(errMsg);
            };
            case (#ok) {
                let tasksBid = switch (bidEscrow.get(taskId)) {
                    case (?bidsMap) bidsMap;
                    case (null) {
                        let newBidsMap = HashMap.HashMap<Principal, Bid>(0, Principal.equal, Principal.hash);
                        bidEscrow.put(taskId, newBidsMap);
                        newBidsMap;
                    }
                };

                if(_bidPlaced(p, Iter.toArray(tasksBid.vals()))) {
                    return #err("Bid already placed");
                };
                
                tasksBid.put(p, bid);

                return #ok();
            };
        }
    };

    public func cancelBid(taskId: Nat64, p: Principal): async Result.Result<(), Text> {
        switch(bidEscrow.get(taskId)) {
            case (null) {
                return #err("Task does not exist");
            };

            case (?bids) {
                switch(bids.get(p)) {
                    case (null) {
                        return #err("Bid does not exist");
                    };

                    case (?bid) {
                            switch(await _refundFreelancer(p, bid.amount)) {
                                case (#err(errMsg)) {
                                    return #err(errMsg);
                                };
                                case (#ok) {
                                    bids.delete(p);
                                    return #ok();
                                };
                            };
                        };
                    };
                };
            };
        };

    public func acceptBid(taskId: Nat64, freelancer: Principal): async Result.Result<(), Text> {
        switch(bidEscrow.get(taskId)) {
            case (null) {
                return #err("Task does not exist");
            };

            case (?bids) {
                switch(bids.get(freelancer)) {
                    case (null) { return #err("Bid does not exist"); };
                    case (?bid) {
                        let newBid = {
                            id = bid.id;
                            taskId = bid.taskId;
                            freelancer;
                            amount = bid.amount;
                            created_at = bid.created_at;
                            status = #Accepted;
                        };

                        bids.put(freelancer, newBid);
                        switch (await _deleteRejectedBids(taskId, freelancer)) {
                            case (#ok) {
                                return #ok();
                            };
                            case (#err(errMsg)) {
                                return #err(errMsg);
                            };
                        };
                    }
                };
            };
        }
    };

    public func getTaskEscrowAmount(taskId: Nat64): async Nat64 { // unnecessary
        return Option.get<Nat64>(taskEscrow.get(taskId), 0);
    };

    public func closeTask(taskId: Nat64): async Result.Result<(), Text> {
        taskEscrow.delete(taskId);

        switch(bidEscrow.get(taskId)) {
            case (null) {
                return #err("No bids found");
            };

            case (?bids) {
                for((key, bid) in bids.entries()) {
                    switch(await _refundFreelancer(bid.freelancer, bid.amount)) {
                        case (#err(errMsg)) {
                            return #err(errMsg);
                        };
                        case (#ok) {
                            bids.delete(key);
                        };
                    };
                };

                return #ok();
            }
        };
    };

    public func fundFreelancer(taskId: Nat64, p: Principal): async Result.Result<(), Text> {
        switch(taskEscrow.get(taskId)) {
            case (null) {
                return #err("Task does not exist");
            };

            case (?amount) {
                switch(await LedgerCanister._mint(amount, p)) {
                    case (#err(errMsg)) {
                        return #err(errMsg);
                    };
                    case (#ok) {
                        taskEscrow.delete(taskId);
                        return #ok();
                    };
                };
            };
        };
    };

    func _deleteRejectedBids(taskId: Nat64, p: Principal): async Result.Result<(), Text> {
        switch(bidEscrow.get(taskId)) {
            case (null) {
                return #err("Task does not exist");
            };

            case (?bids) {
                for((key, bid) in bids.entries()) {
                    if(key != p) {
                        bids.delete(key);
                    };
                };

                return #ok();
            };
        }
    };

    func _refundFreelancer(freelancer: Principal, amount: Nat64): async Result.Result<(), Text> {
                switch(await LedgerCanister._mint(amount, freelancer)) {
                    case (#err(errMsg)) {
                        return #err(errMsg);
                    };
                    case (#ok) {
                        return #ok();
                    };
                };
    };

    func _bidPlaced(p: Principal, bids: [Bid]): Bool {
        for(bid in Iter.fromArray(bids)) {
            if(bid.freelancer == p) {
                return true;
            }
        };

        return false;
    };
}