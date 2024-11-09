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
    public shared ({ caller }) func bid(taskId: Nat64, amount: Nat64) : async Result.Result<(), Text> {
        let isFreelancer = await UserCanister._isFreelancer(caller);
        var bidCounter: Nat = 1;

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

                let newBid = {
                    id = bidCounter;
                    taskId = task.id;
                    freelancer = caller;
                    amount;
                    created_at = ?Time.now();
                    status = #Pending;
                };

                let bidKey = Nat64.toText(taskId) # Nat.toText(bidCounter);

                switch (await EscrowCanister.fundBid(bidKey, newBid, caller)) { //  fix
                    case (#ok) {
                        return #ok();
                    };
                    case (#err(error)) { return #err(error) };
                };
            };
        };

        bidCounter := bidCounter + 1;
        return #ok();
    }
}