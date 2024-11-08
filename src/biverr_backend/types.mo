import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Float "mo:base/Float";
import Time "mo:base/Time";

type Role = {
    #Client;
    #Freelancer;
};

type userId = Principal;

type Profile = {
    id: Text;
    name: Text;
    role: Role;
    created_at: Time.Time;
    rating: Float;
};

type Task = {
    id: Nat;
    title: Text;
    description: Text;
    budget: Float;
    created_at: ?Time.Time;
    deadline: ?Time.Time;
    status: taskStatus;
    client: userId;
    bids: [Bid];
    imageUrl: ?Blob;
};

type taskStatus = {
    #In_Progress;
    #Completed;
    #Cancelled;
};

type BidStatus = {
    #Pending;
    #Rejected;
    #Accepted;
};

type Bid = {
    id: Nat;
    taskId: Nat;
    freelancer: userId;
    amount: Nat;
    created_at: ?Time.Time;
    status: BidStatus;
};