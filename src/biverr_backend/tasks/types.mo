import Time "mo:base/Time";
import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";

module {
    public type Result<Ok, Err> = Result.Result<Ok, Err>;
    public type Tasks = HashMap.HashMap<Principal, Task>;

    public type TaskId = Nat64;

    public type Task = {
        id: TaskId;
        title: Text;
        description: Text;
        budget: Nat64;
        created_at: ?Time.Time;
        deadline: ?Time.Time;
        status: TaskStatus;
        bid_amount_min: Nat64;
        // client: Principal;
        selectedFreelancer: ?Principal;
        // imageUrl: ?Blob;
    };

    public type TaskStatus = {
    #Open;           // Task is available and not yet assigned to a freelancer
    #Assigned;       // Task has been assigned to a freelancer but not yet started
    #InProgress;     // Freelancer has started working on the task
    #Completed;      // Task has been completed by the freelancer
    #Closed;         // Task is no longer available (either completed or canceled)
};

}