import HashMap "mo:base/HashMap";
import Nat64 "mo:base/Nat64";
import Result "mo:base/Result";
import Option "mo:base/Option";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";
import TaskTypes "../tasks/types";
import BidTypes "../bids/types";
import LedgerCanister "canister:ledger_canister";
import UserCanister "canister:user_canister";

actor {
    public type TaskId = TaskTypes.TaskId;
    public type Bid = BidTypes.Bid;
    type CompositeKey = (Nat64, Nat64);

    var taskEscrow: HashMap.HashMap<TaskId, Nat64> = HashMap.HashMap<TaskId, Nat64>(0, Nat64.equal, Nat64.toNat32);
    var bidEscrow: HashMap.HashMap<TaskId, HashMap.HashMap<Nat64, Bid>> = HashMap.HashMap<TaskId, HashMap.HashMap<Nat64, Bid>>(0, Nat64.equal, Nat64.toNat32);

    public func getTaskEscrow(): async [(TaskId, Nat64)] {
        return Iter.toArray(taskEscrow.entries());
    };

    // public func getBidEscrow(): async [(TaskId, [Bid])] {
    //     return Iter.toArray(bidEscrow.entries());
    // };

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
                    case null {
                        let newBidsMap = HashMap.HashMap<Nat64, Bid>(0, Nat64.equal, Nat64.toNat32);
                        bidEscrow.put(taskId, newBidsMap);
                        newBidsMap
                    }
                };

                tasksBid.put(bid.id, bid);

                return #ok();
            };
        }
    };

    public func acceptBid(taskId: Nat64, bidId: Nat64, freelancer: Principal): async Result.Result<(), Text> {

        switch(bidEscrow.get(taskId)) {
            case (null) {
                return #err("Task does not exist");
            };

            case (?bids) {
                switch(bids.get())
                let newBid = {
                    id = bid.id;
                    taskId = bid.taskId;
                    freelancer;
                    amount = bid.amount;
                    created_at = bid.created_at;
                    status = #Accepted;
                };

                bidEscrow.put(taskId, newBid);
                switch (await _deleteBids(taskId)) {
                    case (#ok) {
                        return #ok();
                    };
                    case (#err(errMsg)) {
                        return #err(errMsg);
                    };
                };
            };
        }
    };

    public func getTaskEscrowAmount(taskId: Nat64): async Nat64 { // unnecessary
        return Option.get<Nat64>(taskEscrow.get(taskId), 0);
    };

    public func closeTask(taskId: Nat64, freelancer: Principal): async Result.Result<(), Text> {
        switch(taskEscrow.get(taskId)) {
            case (null) {
                return #err("Task not found");
            };

            case (?amount) {
                switch(await LedgerCanister._mint(amount, freelancer)) {
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

    func _deleteBids(taskId: Nat64): async Result.Result<(), Text> {
        for((key, bid) in bidEscrow.entries()) {
            if(key != taskId and bid.status != #Accepted) {
                bidEscrow.delete(taskId);
            };
        };
        return #ok();
    };

    func _refundFreelancer(taskId: Nat64, freelancer: Principal): async Result.Result<(), Text> {
        for((key, bid) in bidEscrow.entries()) {
            if(key == taskId) {
                switch(await LedgerCanister._mint(bid.amount, freelancer)) {
                    case (#err(errMsg)) {
                        return #err(errMsg);
                    };
                    case (#ok) {
                        bidEscrow.delete(key);
                        return #ok();
                    };
                };
            }
        };
        return #ok();
    };
}