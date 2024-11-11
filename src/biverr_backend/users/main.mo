import Types "../types";
import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Result "mo:base/Result";
import Time "mo:base/Time";
import Iter "mo:base/Iter";

actor {
    type Profile = Types.Profile;
    type Result<Ok, Err> = Types.Result<Ok, Err>; 
    let users : HashMap.HashMap<Principal, Profile> = HashMap.HashMap<Principal, Profile>(0, Principal.equal, Principal.hash);

    public shared func register(name: Text, role: Types.Role, p: Principal) : async Result.Result<(), Text> {

        if(await _isAuthenticatedUser(p)) {
            return #err("Already registered");
        };

        // if(_isAnonymous(caller)) {
        //     return #err("Unauthorized");
        // };

        let profileToCreate : Profile = {
            id = p;
            name;
            role;
            created_at = Time.now();
            rating = 0.0;
        };

        users.put(p, profileToCreate);
        
        return #ok();
    };

    public func getAllUsers(): async [Profile] {
        return Iter.toArray(users.vals());
    };

    public shared func getProfile(p: Principal) : async Result.Result<Profile, Text> {
        switch(users.get(p)) {
            case(null) { return #err("Profile not found"); };
            case(?profile) { return #ok(profile); };
        };
    };

    public func _isAuthenticatedUser(p: Principal): async Bool {
        switch(users.get(p)) {
            case(null) { return false; };
            case(_) { return true; };
        };
    };

    public func _isAnonymous(p: Principal): async Bool {
        return Principal.isAnonymous(p);
    };


    public func _isClient (p: Principal): async Bool {
        switch(users.get(p)) {
            case(null) { return false; };
            case(?profile) {
                switch(profile.role) {
                    case(#Client) { return true; };
                    case(_) { return false; };
                };
            };
        };
    };

    public func _isFreelancer (p: Principal): async Bool {
        switch(users.get(p)) {
            case(null) { return false; };
            case(?profile) {
                switch(profile.role) {
                    case(#Freelancer) { return true; };
                    case(_) { return false; };
                };
            };
        };
    };
}
