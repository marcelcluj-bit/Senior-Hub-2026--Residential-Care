// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SeniorHubEscrow
 * @dev Manages municipal/grant funds and voluntary resident maintenance contributions for senior residential care.
 */
contract SeniorHubEscrow {
    address public municipalityAdmin;
    address public geminiAIOracle;
    uint256 public constant TOTAL_CAPACITY = 18;

    struct ResidentAccount {
        bool isActive;
        uint256 monthlyContributionUsd;
        uint256 lastPaymentTimestamp;
    }

    mapping(address => ResidentAccount) public residentAccounts;

    event ResidentRegistered(address indexed resident, uint256 contribution);
    event OperationalFundsDisbursed(address indexed recipient, uint256 amount);

    modifier onlyAdminOrOracle() {
        require(msg.sender == municipalityAdmin || msg.sender == geminiAIOracle, "Unauthorized access");
        _;
    }

    constructor(address _geminiAIOracle) {
        municipalityAdmin = msg.sender;
        geminiAIOracle = _geminiAIOracle;
    }

    function registerResident(address _resident, uint256 _contribution) external onlyAdminOrOracle {
        residentAccounts[_resident] = ResidentAccount({
            isActive: true,
            monthlyContributionUsd: _contribution,
            lastPaymentTimestamp: block.timestamp
        });
        emit ResidentRegistered(_resident, _contribution);
    }

    receive() external payable {}
}
