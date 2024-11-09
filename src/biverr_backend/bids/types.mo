import Time "mo:base/Time";

module {
    public type BidStatus = {
        #Pending;
        #Rejected;
        #Accepted;
    };

    public type Bid = {
        id: Nat64;
        taskId: Nat64;
        freelancer: Principal;
        amount: Nat64;
        created_at: ?Time.Time;
        status: BidStatus;
    };
}