import Time "mo:base/Time";
import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
import Buffer "mo:base/Buffer";
import Nat64 "mo:base/Nat64";
import UserCanister "canister:user_canister";
import EscrowCanister "canister:escrow_canister";
import NFTCanister "canister:nft_canister";
import Types "./types";

actor {
    type Task = Types.Task;
    type TaskStatus = Types.TaskStatus;
    type TaskId = Types.TaskId;
    let tasks = HashMap.HashMap<Nat64, Task>(10, Nat64.equal, Nat64.toNat32);
    var taskCounter: TaskId = 1 ;

    public shared ({ caller }) func createTask(title: Text, description: Text, budget: Nat64, deadline: Time.Time, bid_amount_min: Nat64) : async Result.Result<(), Text> {
        let isAuthenticated = await UserCanister._isAuthenticatedUser(caller);
        let isClient = await UserCanister._isClient(caller);

        if(not isAuthenticated) {
            return #err("Unauthorized");
        };

        if(not isClient) {
            return #err("You are not a client");
        };
        
        let newTask: Task = {
            id = taskCounter;
            title;
            bid_amount_min;
            description;
            client = caller;
            budget;
            created_at = ?Time.now();
            deadline = ?deadline;
            status = #Open;
            selectedFreelancer = null;
        };

        tasks.put(taskCounter, newTask);

        switch (await EscrowCanister.fundTask(taskCounter, budget, caller)) {
            case (#ok) {};
            case (#err(error)) { return #err(error) };
        };

        taskCounter := taskCounter + 1;

        return #ok();
    };

    public shared ({ caller }) func updateTaskStatus(taskId: Nat64, status: TaskStatus): async Result.Result<(), Text> {
        let isAuthenticated = await UserCanister._isAuthenticatedUser(caller);
        let isClient = await UserCanister._isClient(caller);

        if(not isAuthenticated) {
            return #err("Unauthorized");
        };

        if(not isClient) {
            return #err("You are not a client");
        };

        switch(tasks.get(taskId)) {
            case (null) { return #err("Task does not exist")};
            case (?task) {
                let updatedTask = {
                    id = task.id;
                    title = task.title;
                    description = task.description;
                    budget = task.budget;
                    created_at = task.created_at;
                    deadline = task.deadline;
                    client = task.client;
                    status;
                    bid_amount_min = task.bid_amount_min;
                    selectedFreelancer = task.selectedFreelancer;
                };

                tasks.put(taskId, updatedTask);

                return #ok();
            }
        }
    };

    public shared ({ caller }) func getMyTasks(): async Result.Result<[Task], Text> {
        let clientTasks = Buffer.Buffer<Task>(0);

        let isAuthenticated = await UserCanister._isAuthenticatedUser(caller);
        let isClient = await UserCanister._isClient(caller);

        if(not isAuthenticated) {
            return #err("Unauthorized");
        };

        if(not isClient) {
            return #err("You are not a client");
        };
        

        for((key, task) in tasks.entries()) {
            if(task.client == caller) {
                clientTasks.add(task);
            }
        };

        return #ok(Buffer.toArray(clientTasks));
    };

    public func getTaskById(id: TaskId, p: Principal) : async Result.Result<Task, Text> {
        let isAuthenticated = await UserCanister._isAuthenticatedUser(p);

        if(not isAuthenticated) {
            return #err("Unauthorized");
        };

        switch(tasks.get(id)) {
            case (null) { return #err("Task not found") };
            case (?task) { return #ok(task) };
        }
    };

    public func getAllTask(): async Result.Result<[Task], Text> {
        let allTasks = Buffer.Buffer<Task>(0);

        for (task in tasks.vals()) {
            if(task.status == #Open) {
                allTasks.add(task);
            }
        };

        return #ok(Buffer.toArray(allTasks));
    };

    public shared ({ caller }) func submitTask(id: TaskId): async Result.Result<(), Text> {
        switch(await UserCanister._isFreelancer(caller)) {
            case (false) { return #err("You are not a freelancer") };
            case (true) {};
        };

        switch(tasks.get(id)) {
            case (null) { return #err("Task not found") };
            case (?task) {
                let updatedTask = {
                    id = task.id;
                    title = task.title;
                    description = task.description;
                    budget = task.budget;
                    created_at = task.created_at;
                    deadline = task.deadline;
                    client = task.client;
                    status = #Submitted;
                    bid_amount_min = task.bid_amount_min;
                    selectedFreelancer = task.selectedFreelancer;
                };

                tasks.put(id, updatedTask);

                return #ok();
            };
        };
    };

    public shared ({ caller }) func rejectTask(id: TaskId): async Result.Result<(), Text> {
        switch(await UserCanister._isClient(caller)) {
            case (false) { return #err("You are not a client") };
            case (true) {};
        };

        switch(tasks.get(id)) {
            case (null) { return #err("Task not found") };
            case (?task) {
                let updatedTask = {
                    id = task.id;
                    title = task.title;
                    description = task.description;
                    budget = task.budget;
                    created_at = task.created_at;
                    deadline = task.deadline;
                    client = task.client;
                    status = #Rejected;
                    bid_amount_min = task.bid_amount_min;
                    selectedFreelancer = task.selectedFreelancer;
                };

                tasks.put(id, updatedTask);

                return #ok();
            };
        };
    };

    public shared ({ caller }) func approveTask(id: TaskId): async Result.Result<(), Text> {
        switch(await UserCanister._isClient(caller)) {
            case (false) { return #err("You are not a client") };
            case (true) {};
        };
        
        switch(tasks.get(id)) {
            case (null) { return #err("Task not found") };
            case (?task) {
                let updatedTask = {
                    id = task.id;
                    title = task.title;
                    description = task.description;
                    budget = task.budget;
                    created_at = task.created_at;
                    deadline = task.deadline;
                    client = task.client;
                    status = #Approved;
                    bid_amount_min = task.bid_amount_min;
                    selectedFreelancer = task.selectedFreelancer;
                };

                switch(task.selectedFreelancer) {
                    case (null) { return #err("No freelancer selected") };
                    case (?freelancer) {
                        switch(await EscrowCanister.fundFreelancer(id, freelancer)) {
                            case (#ok) {
                                switch(await NFTCanister.mintInvoiceNFT(id, freelancer, caller, task.budget)) {
                                    case (#ok(invoice)) {
                                        return #ok();
                                        tasks.put(id, updatedTask);
                                    };
                                    case (#err(error)) { return #err(error) };
                                };
                            };
                            case (#err(error)) { return #err(error) };
                        }
                    }
                };

                return #ok();
            };
        };
    };

    public shared ({ caller }) func selectFreelancer(id: TaskId, p: Principal): async Result.Result<(), Text> {
        switch(await UserCanister._isClient(caller)) {
            case (false) { return #err("You are not a client") };
            case (true) {};
        };

        switch(tasks.get(id)) {
            case (null) { return #err("Task not found") };
            case (?task) {
                let updatedTask = {
                    id = task.id;
                    title = task.title;
                    description = task.description;
                    budget = task.budget;
                    created_at = task.created_at;
                    deadline = task.deadline;
                    client = task.client;
                    status = #Assigned;
                    bid_amount_min = task.bid_amount_min;
                    selectedFreelancer = ?p;
                };

                tasks.put(id, updatedTask);

                switch(await EscrowCanister.acceptBid(id, p)) {
                    case (#ok) {
                        return #ok()
                    };
                    case (#err(error)) {
                        return #err(error)
                    };
                }
            };
        };
    };

    // public func updateTask(taskId: Nat64, task: Task): async Result.Result<(), Text> {
    //     switch(tasks.get(taskId)) {
    //         case (null) { return #err("Task not found")};
    //         case (_) { tasks.put(taskId, task); return #ok(); };
    //     }
    // }
}   