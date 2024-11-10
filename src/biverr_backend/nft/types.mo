import Time "mo:base/Time";

module {
    public type InvoiceNFT = {
        id: Nat64;
        taskId: Nat64;
        freelancer: Principal;
        client: Principal;
        completionDate: Time.Time;
        amountDue: Nat64;
        status: { #Paid };
    };
}