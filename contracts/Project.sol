pragma solidity ^0.4.2;

contract Project{
    address owner;
    uint amtRaised; // in wei
    uint targetAmt;
    uint deadline; // the time until when the amt has to be raised
    
    uint[] contributions;
    address[] contributors;

    function Project(address owner, uint targetAmt, uint deadline) {
        this.owner = owner;
        this.targetAmt = targetAmt;
        this.deadline = deadline;
        this.amtRaised = 0;
    }
    
    /* This is the function called when the FundingHub receives a contribution. The function must 
    keep track of the 1) contributor and the 2) individual amount contributed. 
    If the contribution was sent after the deadline of the project passed, or the full amount has been reached, 
    the function must return the value to the originator of the transaction and call one of two functions. 
    If the full funding amount has been reached, the function must call payout. If the deadline has passed without the funding goal being reached, the function must call refund. */
    
    function fund(address contributor, uint amtContributed) {
        // check if amt sent
        if (amtContributed != msg.value) throw;

        // otherwise add to amt
        // optionally: check if contributor has multiple contributions
        contributions.push(amtContributed);
        contributors.push(contributor);
        
        this.amtRaised += amtContributed;

        var amtRaised = this.amtRaised;
        var deadline = this.deadline;
        var now = block.timestamp; 

        // if deadlinepassed call refund
        if (now > deadline)
           refund();
        else if (amtRaised > targetAmt) {
           payout();
        }
    }
    
    // This is the function that sends all funds received in the contract to the owner of the project.
    function payout() {
        if (!this.owner.send(this.amtRaised)) throw;
    }

    /* This function sends all individual contributions back to the respective contributor, or lets all contributors retrieve their contributions. */
    function refund() {
        address contribAddress;
        uint    contribAmt;

        for (uint i = 0; i < this.contributors.length; i++) {
            contribAddress = this.contributors[i];
            contribAmt     = this.contributions[i];
            if (!contribAddress.send(contribAmt)) throw;
        }
        
    }

/*
		function convert(uint amount,uint conversionRate) returns (uint convertedAmount)
	{
	return amount * conversionRate;
}
*/
}
