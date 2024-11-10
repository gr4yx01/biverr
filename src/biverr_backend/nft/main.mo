import Time "mo:base/Time";
import HashMap "mo:base/HashMap";
import Result "mo:base/Result";
import Nat64 "mo:base/Nat64";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Types "types";

actor InvoiceNFTCanister {
    type InvoiceNFT = Types.InvoiceNFT;
    var nftCounter: Nat64 = 0;
    let nftLedger = HashMap.HashMap<Nat64, InvoiceNFT>(0, Nat64.equal, Nat64.toNat32);

    public func mintInvoiceNFT(taskId: Nat64, freelancer: Principal, client: Principal, amountDue: Nat64): async Result.Result<InvoiceNFT, Text> {
        let newNFT: InvoiceNFT = {
            id = nftCounter;
            taskId;
            freelancer;
            client;
            completionDate = Time.now();
            amountDue;
            status = #Paid;
        };

        nftLedger.put(nftCounter, newNFT);
        nftCounter := nftCounter + 1;
        return #ok(newNFT);
    };

    public shared ({ caller }) func getFreelancerNFTs(): async [InvoiceNFT] {
        return Array.filter<InvoiceNFT>(Iter.toArray(nftLedger.vals()), func (nft) {
            nft.freelancer == caller;
        });
    };
}
