pragma solidity ^0.4.2;

import "Project.sol";

// This is a crowdfunding app 

contract FundingHub {
   
    struct project {
        address owner;
        uint raisedAmt;
        uint targetAmt;
        uint deadline;
    } 
    mapping (address => project) projectInfo;
    address[] public projects;
    

    event NewProjectEvent(address newProjectAddr, address owner, uint raisedAmt, uint targetAmt, uint deadline); 
    event getProjectInfoEvent(bytes32 projectsString);

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
        address newProjectAddr = new Project(owner, targetAmt, deadline);
        projects.push(newProjectAddr); // keep track of address 
        var raisedAmt = 0;
        projectInfo[newProjectAddr] = project(owner, raisedAmt, targetAmt, deadline);        
        NewProjectEvent(newProjectAddr, owner, raisedAmt, targetAmt, deadline); // Browser return
        return newProjectAddr; // Smart contract return
    }

    function getProject(uint index) constant returns (address) {
        return projects[index];
    }

    function getProjectInfo() constant {
        for (uint ii = 0; ii < projects.length; ii++) {
            var p = projectInfo[projects[ii]];
            NewProjectEvent(projects[ii], p.owner, p.raisedAmt, p.targetAmt, p.deadline);
        }
    } 
    
    /* This function allows users to contribute to a Project identified by its address. 
    contribute calls the fund() function in the individual Project contract and 
    passes on all value attached to the function call.*/
    
    function contribute(address projectAddress, address contributor) payable {
        Project project = Project(projectAddress);
        var contribution = msg.value;
        var raisedAmt = project.fund.value(contribution)(contributor, contribution);
        projectInfo[project].raisedAmt = raisedAmt;
    }
}
