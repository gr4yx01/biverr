import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Option "mo:base/Option";
import Iter "mo:base/Iter";

actor Ledger {
    var accounts: HashMap.HashMap<Principal, Nat64> = HashMap.HashMap<Principal, Nat64>(0, Principal.equal, Principal.hash);

    public shared ({ caller }) func deposit(amount: Nat64) : async Result.Result<(), Text> {
        let currentBalance: Nat64 = Option.get<Nat64>(accounts.get(caller), 0);
        
        accounts.put(caller, currentBalance + amount);
        return #ok();
    };

    public shared ({ caller }) func withdraw(amount: Nat64) : async Result.Result<(), Text> {
        let currentBalance: Nat64 = Option.get<Nat64>(accounts.get(caller), 0);
        
        if (currentBalance < amount) {
            return #err("Insufficient balance");
        };

        accounts.put(caller, currentBalance - amount);
        return #ok();
    };

    public func _burn(amount: Nat64, p: Principal) : async Result.Result<(), Text> {
        let currentBalance: Nat64 = Option.get<Nat64>(accounts.get(p), 0);
        
        if (currentBalance < amount) {
            return #err("Insufficient balance");
        };

        accounts.put(p, currentBalance - amount);
        return #ok();
    };

    public func _mint(amount: Nat64, p: Principal) : async Result.Result<(), Text> {
        let currentBalance: Nat64 = Option.get<Nat64>(accounts.get(p), 0);
        
        accounts.put(p, currentBalance + amount);
        return #ok();
    };

    public func getAllAccount(): async [(Principal, Nat64)] {
        return Iter.toArray(accounts.entries());
    };

    public shared func getBalance(p: Principal) : async Nat64 {
        return Option.get<Nat64>(accounts.get(p), 0);
    };

    public shared func transfer(from: Principal, to: Principal, amount: Nat64): async Result.Result<(), Text> {
        switch(await _burn(amount, from)) {
            case (#err(errMsg)) {
                return #err(errMsg);
            };
            case (#ok) {
                switch(await _mint(amount, to)) {
                    case (#err(errMsg)) {
                        return #err(errMsg);
                    };
                    case (#ok) {
                        return #ok();
                    };
            };
        };
        };
    };

    public shared ({ caller }) func whoami() : async Principal {
        return caller;
    };
}