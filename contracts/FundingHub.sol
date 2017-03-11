pragma solidity ^0.4.2;

import "Project.sol";

// This is a crowdfunding app 

contract FundingHub {
    address[] projects;
    event NewProjectEvent(address indexed projectAddress, uint targetAmt, uint deadline); 
    event getProjectInfoEvent(bytes32 projectsString);

    function FundingHub() {
        
    }
    
    /* This function should allow a user to add a new project to the FundingHub. 
       The function should 
        2. deploy a new Project contract and 
        3. keep track of its address. 
        4. The createProject() function should accept all constructor values that 
           the Project contract requires. */

    function createProject(address projOwnerAddr, uint targetAmt, uint deadline) returns (address) {
    
        // deploy new project 
        address newProjectAddr = new Project(projOwnerAddr, targetAmt, deadline);
        projects.push(newProjectAddr); // keep track of address 
        
        NewProjectEvent(newProjectAddr, targetAmt, deadline); // Browser return
        return newProjectAddr; // Smart contract return
    }

    function getProjectInfo() returns (address[]) {
        var projectsString = "";
        for (uint ii = 0; ii < projects.length; ii++) {
            var p = projects[ii];
            projectsString += p.owner + " " + p.raisedAmt + "/" + p.targetAmt + " " + p.deadline + "\n";
        }
        getProjectInfoEvent(projectsString);
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
