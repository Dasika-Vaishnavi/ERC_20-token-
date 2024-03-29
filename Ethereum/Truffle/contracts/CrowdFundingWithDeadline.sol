// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.9 <=0.9.0;
pragma abicoder v2;
import "./Utils.sol";

contract CrowdFundingWithDeadline {
    using Utils for *;
    event CampaignFinished(
        address addr,
        uint256 totalCollected,
        bool succeeded
    );
    enum State {
        Ongoing,
        Failed,
        Succeeded,
        Paidout
    }
    string public name;
    uint256 public targetAmount;
    uint256 public fundingDeadline;
    address payable public beneficiary;
    State public state;
    mapping(address => uint256) public amounts;
    bool public collected;
    uint256 public totalCollected;

    constructor(
        string memory contractName,
        uint256 targetAmountEth,
        uint256 durationInMin,
        address payable beneficiaryAddress
    ) {
        name = contractName;
        targetAmount = Utils.etherToWei(targetAmountEth);
        fundingDeadline = currentTime() + Utils.minToSec(durationInMin);
        beneficiary = beneficiaryAddress;
        state = State.Ongoing;
    }

    modifier inState(State expectedSate) {
        require(state == expectedSate, "Invalid Sate");
        _;
    }

    function contribute() public payable inState(State.Ongoing) {
        require(beforeDeadline(), "DeadLine");
        amounts[msg.sender] += msg.value;
        totalCollected += msg.value;
        if (totalCollected >= targetAmount) {
            collected = true;
        }
    }

    function collect() public inState(State.Succeeded) {
        if (beneficiary.send(totalCollected)) {
            state = State.Paidout;
        } else {
            state = State.Failed;
        }
    }

    function withdraw() public inState(State.Failed) {
        require(amounts[msg.sender] > 0, "Nothing was contributed");
        uint256 contributed = amounts[msg.sender];
        amounts[msg.sender] = 0;
        if (!payable(msg.sender).send(contributed)) {
            amounts[msg.sender] = contributed;
        }
    }

    function finishCrowdFunding() public inState(State.Ongoing) {
        require(!beforeDeadline(), "Cannot finish campaign before a deadline");
        if (!collected) {
            state = State.Failed;
        } else {
            state = State.Succeeded;
        }
        emit CampaignFinished(msg.sender, totalCollected, collected);
    }

    function currentTime() internal view virtual returns (uint256) {
        return block.timestamp;
    }

    function getBlockTime() public view returns (uint256) {
        return block.timestamp;
    }

    function beforeDeadline() public view returns (bool) {
        return currentTime() < fundingDeadline;
    }
}
