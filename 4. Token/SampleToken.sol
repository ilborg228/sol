pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract SampleToken {

    struct Token {
        string name;
        uint8 quality;
        uint code;    
    }

    Token[] tokenArr;
    string[] tokenNames;
    mapping (uint=>uint) tokenToOwner;
    mapping (uint=>uint) tokenToSale;//token=>price

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    function createToken(string name,uint8 quality,uint code) public checkOwnerAndAccept{
        require(checkName(name), 102);
        tokenArr.push(Token(name,quality,code));
        tokenNames.push(name);
        uint keyAsLastNum=tokenArr.length - 1;
        tokenToOwner[keyAsLastNum]=msg.pubkey();
    }   

    function putForSale (uint tokenId,uint price) public checkOwnerAndAccept{
        require(msg.pubkey() == tokenToOwner[tokenId], 103);
        tvm.accept();
        tokenToSale.add(tokenId, price);
    }

    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 100);
		tvm.accept();
		_;
	}

    function checkName (string name) private returns(bool){
        for (uint i = 0; i < tokenNames.length; i++) {
            if(name==tokenNames[i])
                return false;
        }
        return true;
    }
}
