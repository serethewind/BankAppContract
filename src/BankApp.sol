// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract BankApp {
    struct AccountDetails {
        bool isUserExisting;
        uint256 accountBalance;
    }

    mapping(address => AccountDetails) private accountInstance;

    modifier accountExists(address accountAddress) {
        require(
            accountInstance[accountAddress].isUserExisting,
            "Account does not exist"
        );
        _;
    }

    modifier hasSufficientBalance(address accountAddress, uint256 amount) {
        require(
            accountInstance[accountAddress].accountBalance >= amount,
            "Insufficient balance"
        );
        _;
    }

    function createAccount() external {
        require(
            !accountInstance[msg.sender].isUserExisting,
            "Account already exist"
        );
        accountInstance[msg.sender] = AccountDetails(true, 0);
    }

    function deposit() external payable accountExists(msg.sender) {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        accountInstance[msg.sender].accountBalance += msg.value;
    }

    function withdraw(
        uint256 amountToWithdraw
    )
        external
        accountExists(msg.sender)
        hasSufficientBalance(msg.sender, amountToWithdraw)
    {
        accountInstance[msg.sender].accountBalance -= amountToWithdraw;
        payable(msg.sender).transfer(amountToWithdraw);
    }

    function transfer(
        address recipientAccount,
        uint amountToTransfer
    )
        external
        accountExists(msg.sender)
        hasSufficientBalance(msg.sender, amountToTransfer)
        accountExists(recipientAccount)
    {
        accountInstance[msg.sender].accountBalance -= amountToTransfer;
        accountInstance[recipientAccount].accountBalance += amountToTransfer;
    }

    function getBalance()
        external
        view
        accountExists(msg.sender)
        returns (uint256)
    {
        return accountInstance[msg.sender].accountBalance;
    }
}
