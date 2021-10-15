pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract TaskManager {

    mapping(int8=>Task) public map;
    
    struct Task {
        string name;
        uint32 timestamp;
        bool isCompleted;
    }

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();

    }

    modifier checkOwnerAndAccept {
		// Check that message was signed with contracts key.
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}

    function addTask(int8 key,string nameTask) external checkOwnerAndAccept{
        optional(Task) info = map.fetch(key);
        if (!info.hasValue()) {
            map.add(key, Task(nameTask , now , false));
        }
    }

    function countUncompletedTasks() external checkOwnerAndAccept returns (int8){
        int8 k=0;
        optional(int8,Task) info = map.min();
        while (info.hasValue()) {
            (int8 key, Task task) = info.get();
            if (!task.isCompleted)
                k++;
            info = map.next(key);
        }
        return k;
    }

    function getTaskList() external checkOwnerAndAccept returns (Task[]){
        Task[] k;
        optional(int8,Task) info = map.min();
        while (info.hasValue()) {
            (int8 key, Task task) = info.get();
            k.push(task);
            info = map.next(key);
        }
        return k;
    }

    function getNameByKey(int8 key) external checkOwnerAndAccept returns (string){
        optional(Task) info = map.fetch(key);
        if(info.hasValue()){
            return map.at(key).name;
        }
        else{
            return "";
        }
    }

    function deleteTaskByKey(int8 key) external checkOwnerAndAccept returns (bool){
        optional(Task) info = map.fetch(key);
        if(info.hasValue()){
            delete map[key];
            return true;
        }
        else{
            return false;
        }
    }

    function setComplete(int8 key) external checkOwnerAndAccept returns (bool){
        optional(Task) info = map.fetch(key);
        if(info.hasValue() && !info.get().isCompleted){
            map[key].isCompleted=true;
            return true;
        }
        else{
            return false;
        }
    }
}