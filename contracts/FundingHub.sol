pragma solidity ^0.4.2;

import "Project.sol";

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract FundingHub {
    bytes32[] Names;
    address[] newContracts;
    
    function FundingHub() {
        
    }
    
    /* This function should allow a user to add a new project to the FundingHub. The function should 
        2. deploy a new Project contract and 
        3. keep track of its address. 
        4. The createProject() function should accept all constructor values that the Project contract requires. */
    function createProject(address owner, uint amtRaised, string deadline) {
        /* deploy new project */
        
        address newContract = new Project(owner, amtRaised, deadline);
        /* keep track of address */
        newContracts.push(newContract);
        
        eventAdress(newContract); // Browser return
        return newContract; // Smart contract return
    }
    
    /* This function allows users to contribute to a Project identified by its address. contribute calls the fund() function in the individual Project contract and passes on all value attached to the function call.*/
    
    function contribute(address projectAddress) {
        fund() 
    }
    
    
/*
	mapping (address => uint) balances;

	event Transfer(address indexed _from, address indexed _to, uint256 _value);

	function FundingHub() {
		balances[tx.origin] = 10000;
	}

	function sendCoin(address receiver, uint amount) returns(bool sufficient) {
		if (balances[msg.sender] < amount) return false;
		balances[msg.sender] -= amount;
		balances[receiver] += amount;
		Transfer(msg.sender, receiver, amount);
		return true;
	}

	function getBalanceInEth(address addr) returns(uint){
		return Project.convert(getBalance(addr),2);
	}

	function getBalance(address addr) returns(uint) {
		return balances[addr];
	}
*/
}
