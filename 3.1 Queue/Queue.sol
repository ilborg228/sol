pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Queue {

    string[] public names;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    function getInLine(string obj) external checkOwnerAndAccept{
        names.push(obj);
    }

    function getNext() external checkOwnerAndAccept{
        string temp = names[names.length-1];
        names[names.length-1] = names[0];
        names[0] = temp;
        names.pop();
    }

    modifier checkOwnerAndAccept {
		// Check that message was signed with contracts key.
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}
}
