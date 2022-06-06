pragma solidity 0.7.5;


import "./Ownable.sol";

//External contract wants to pull transaction data form this(bankOwnable) contract//

interface FinancialInterface {
    function addTransaction (address _from, address _to, uint _amount) external payable; 
    
}

contract bank is Ownable {
    
    
    FinancialInterface financialInstance = FinancialInterface(0xf8e81D47203A594245E36C48e151709F0C19fBe8);
    
    
    
    mapping (address => uint) balance;
    
    
    event depositDone(uint amount, address indexed depositedTo);
    
    
    
    function deposit() public payable returns (uint) { //payable!! only when receiving//
        balance[msg.sender] += msg.value;  //tracks the deposited addresses in mapping//
        emit depositDone (msg.value, msg.sender);   //records event to the blockchain//  
        return balance[msg.sender];
    }
    
    //withdraw funds from the contract to myself or another address//
    
    function withdraw(uint amount) public onlyOwner returns (uint) {
        require(balance[msg.sender]>= amount);  
        balance[msg.sender] -= amount;
        msg.sender.transfer(amount);  //Or!! address payable toSend = 0x77rytnhv8765..;//toSend.transfer (amount);
        return balance[msg.sender];
    }
    
    function getBalance()public view returns(uint){
        return balance[msg.sender];
    }
    
    function transfer(address recipient, uint amount) public {
        require(balance[msg.sender] >= amount, "Insufficient balance");
        require(msg.sender != recipient, "Can not send funds to yourself");
        
        uint previousSenderBalance = balance[msg.sender];
        
        _transfer(msg.sender, recipient, amount);
        
        financialInstance.addTransaction{value: 1 ether}(msg.sender, recipient, amount);
        
        
        assert(balance[msg.sender] == previousSenderBalance - amount);
    }    
        
        function _transfer(address from, address to, uint amount) private {
            balance[from] -= amount;
            balance[to] += amount;
        }
    }







