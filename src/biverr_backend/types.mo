import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Float "mo:base/Float";
import Time "mo:base/Time";
import Result "mo:base/Result";

module {
    public type Result<Ok, Err> = Result.Result<Ok, Err>;
    public type Role = {
        #Client;
        #Freelancer;
    };

    type userId = Principal;

    public type Profile = {
        id: userId;
        name: Text;
        role: Role;
        created_at: Time.Time;
        rating: Float;
    };
}
