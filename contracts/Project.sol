pragma solidity ^0.4.2;

contract Project{
    address owner;
    uint raisedAmt; // in wei
    uint targetAmt; // the target goal to be raised
    uint deadline; // the time until when the amt has to be raised
    bytes32 name;
    bytes32 descr;
    bool isClosed;
    
    uint[] contributions;
    address[] contributors;

    function Project(address _owner, uint _targetAmt, uint _deadline) {
        owner = _owner;
        targetAmt = _targetAmt;
        deadline = _deadline;
        raisedAmt = 0;
        isClosed = false;
    }
    
    /* This is the function called when the FundingHub receives a contribution. The function must 
    keep track of the 1) contributor and the 2) individual amount contributed. 
    If the contribution was sent after the deadline of the project passed, or the full amount has been reached, 
    the function must return the value to the originator of the transaction and call one of two functions. 
    If the full funding amount has been reached, the function must call payout. If the deadline has passed without the funding goal being reached, the function must call refund. */
    
    function fund(address contributor, uint amtContributed) payable {
        // if incorrect amt sent or project closed, abort
        if ((amtContributed != msg.value) || isClosed) throw;

        // otherwise add to amt
        // optionally: check if contributor has multiple contributions
        contributions.push(amtContributed);
        contributors.push(contributor);
        
        raisedAmt += amtContributed;

        var now = block.timestamp; 

        // if deadlinepassed call refund
        if (now > deadline)
           refund();
        else if (raisedAmt > targetAmt)
           payout();
    }
    
    // This is the function that sends all funds received in the contract to the owner of the project.
    function payout() {
        if (isClosed)
            throw;
        else
            if (!owner.send(raisedAmt)) throw;
        isClosed = true;
    }

    /* This function sends all individual contributions back to the respective contributor, or lets all contributors retrieve their contributions. */
    function refund() {
        if (isClosed)
            throw;
        else {
            address contribAddress;
            uint    contribAmt;

            for (uint i = 0; i < contributors.length; i++) {
                contribAddress = contributors[i];
                contribAmt     = contributions[i];
                if (!contribAddress.send(contribAmt)) throw;
            }
        }
        isClosed = true;
    }

    function projectString() returns (bytes32) {
        return raisedAmt + "/" + targetAmt + " " + deadline;
    }
}
