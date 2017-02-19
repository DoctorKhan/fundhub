pragma solidity ^0.4.2;


contract Project{
    address owner;
    uint amtRaised; // in wei
    uint amtToBeRaised;
    string deadline; // the time until when the amt has to be raised
    
    uint[] contributions;
    address[] contributors;

    function Project(address owner, uint amtRaised, string deadline) {
        this.owner = owner;
        this.amtToBeRaised = amtToBeRaised;
        this.deadline = deadline;
    }
    
/* This is the function called when the FundingHub receives a contribution. The function must 
    - keep track of the contributor and the individual amount contributed. 
    If the contribution was sent after the deadline of the project passed, or the full amount has been reached, the function must return the value to the originator of the transaction and call one of two functions. 
    If the full funding amount has been reached, the function must call payout. If the deadline has passed without the funding goal being reached, the function must call refund. */
    function fund(address contributor, uint amtContributed) {
        // check if amt sent
        if (amtContributed != msg.value) throw;

        // otherwise add to amt
        // optionally: check if contributor has multiple contributions
        contributions.push(amtContributed);
        contributors.push(contributor);
        amtRaised += amtContributed;

        if (now > deadline || amtRaised > amtToBeRaised)
        {
            // return amoutn contributed to contributor
            returnAmt();
            // if full funding call payout
            if (amtRaised > amtToBeRaised) payout();
            // if deadlinepassed call refund
            if (now > deadline) refund();
        }
    }
    
    /* This is the function that sends all funds received in the contract to the owner of the project.
    */
    function payout(address owner) {
        if (!owner.send(this.amtRaised)) throw;
    }

    /* This function sends all individual contributions back to the respective contributor, or lets all contributors retrieve their contributions. */
    function refund() {
        address contribAddress;
        uint    contribAmt;

        for (uint i = 0; i < this.contributors.length; i++) {
            contribAddress = contributors[i];
            contribAmt     = contributions[i];
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
