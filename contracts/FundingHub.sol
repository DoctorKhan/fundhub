pragma solidity ^0.4.2;

import "Project.sol";

// This is a crowdfunding app 

contract FundingHub {
    address[] allContracts;
    event NewProjectEvent(address indexed projectAddress, uint targetAmt, uint deadline); 

    function FundingHub() {
        
    }
    
    /* This function should allow a user to add a new project to the FundingHub. 
       The function should 
        2. deploy a new Project contract and 
        3. keep track of its address. 
        4. The createProject() function should accept all constructor values that 
           the Project contract requires. */

    function createProject(address owner, uint targetAmt, uint deadline) returns (address) {
    
        // deploy new project 
        address newContract = new Project(owner, targetAmt, deadline);
        allContracts.push(newContract); // keep track of address 
        
        NewProjectEvent(newContract, targetAmt, deadline); // Browser return
        return newContract; // Smart contract return
    }
    
    /* This function allows users to contribute to a Project identified by its address. 
    contribute calls the fund() function in the individual Project contract and 
    passes on all value attached to the function call.*/
    
    function contribute(address projectAddress, address contributor) payable {
        Project project = Project(projectAddress);
        var contribution = msg.value;
        project.fund.value(contribution)(contributor, contribution);
    }
}
