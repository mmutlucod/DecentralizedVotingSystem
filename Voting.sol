// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint vote;
    }

    struct Proposal {
        string name;
        uint voteCount;
    }

    address public admin;
    mapping(address => Voter) public voters;
    Proposal[] public proposals;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function.");
        _;
    }

    modifier onlyRegisteredVoter() {
        require(voters[msg.sender].isRegistered, "Only registered voters can call this function.");
        _;
    }

    constructor(string[] memory proposalNames) {
        admin = msg.sender;
        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    function registerVoter(address voter) public onlyAdmin {
        require(!voters[voter].isRegistered, "Voter is already registered.");
        voters[voter].isRegistered = true;
    }

    function vote(uint proposal) public onlyRegisteredVoter {
        Voter storage sender = voters[msg.sender];
        require(!sender.hasVoted, "Already voted.");
        sender.hasVoted = true;
        sender.vote = proposal;

        proposals[proposal].voteCount += 1;
    }

    function getWinningProposal() public view returns (uint winningProposal) {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal = p;
            }
        }
    }

    function getWinnerName() public view returns (string memory winnerName) {
        winnerName = proposals[getWinningProposal()].name;
    }
}
