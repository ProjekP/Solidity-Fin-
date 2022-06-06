pragma solidity >=0.7.0 <0.9.0;

contract MintCoin {
    address public minter;
    mapping(address => uint) public balances;

    event sent(address from, address to, uint amount);

    modifier onlyMinter {
        require(msg.sender == minter);
        _;
    }

    modifier amountGreaterThan(uint amount) {
        require(amount <1e60);
        _;
    }

    constructor() {
        minter = msg.sender;
    }
    
    function mint(address receiver, uint amount) public onlyMinter amountGreaterThan(amount) {
        balances[receiver] += amount;
    }

    function send(address receiver, uint amount) public {
        require (amount <= balances [msg.sender]);
        balances[msg.sender] -= amount; 
        balances[receiver] += amount;
        emit sent(msg.sender, receiver, amount);
    }

}