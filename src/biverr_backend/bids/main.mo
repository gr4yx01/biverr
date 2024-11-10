import UserCanister "canister:user_canister";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Time "mo:base/Time";
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";
import TaskCanister "canister:task_canister";
import EscrowCanister "canister:escrow_canister";
import BidType "./types";

actor {
    type BidStatus = BidType.BidStatus;
    type Bid = BidType.Bid;
    public shared ({ caller }) func cancelBid(taskId: Nat64) : async Result.Result<(), Text> {
        let isFreelancer = await UserCanister._isFreelancer(caller);
        if(not isFreelancer) {
            return #err("You are not a freelancer");
        };

        let taskResult = await TaskCanister.getTaskById(taskId, caller);

        switch (taskResult) {
            case (#err(errMsg)) {
                return #err(errMsg);
            };
            case (#ok(task)) {
                    switch (await EscrowCanister.cancelBid(task.id, caller)) {
                        case (#ok) {
                            return #ok();
                        };
                        case (#err(error)) { return #err(error) };
                    };
            };
        };
    };

    public shared ({ caller }) func bid(taskId: Nat64, amount: Nat64) : async Result.Result<(), Text> {
        let isFreelancer = await UserCanister._isFreelancer(caller);
        var bidCounter: Nat64 = 1;

        if(not isFreelancer) {
            return #err("You are not a freelancer");
        };

        let taskResult = await TaskCanister.getTaskById(taskId, caller);

        switch (taskResult) {
            case (#err(errMsg)) {
                return #err(errMsg);
            };
            case (#ok(task)) {
                // let allBids : Buffer.Buffer<BidType.Bid> = Buffer.fromArray<BidType.Bid>(task.bids);
                
                if (task.status != #Open) {
                    return #err("Task is not open");
                };

                if(amount < task.bid_amount_min) {
                    return #err("Bid amount is less than minimum bid amount");
                };

                let newBid: Bid = {
                    id = bidCounter;
                    taskId;
                    freelancer = caller;
                    amount;
                    status = #Pending;
                    created_at = ?Time.now();
                };
                
                bidCounter := bidCounter + 1;

                switch (await EscrowCanister.fundBid(taskId, newBid, caller)) { //  fix
                    case (#ok) {
                        return #ok();
                    };
                    case (#err(error)) { return #err(error) };
                };
            };
        };
    }
}