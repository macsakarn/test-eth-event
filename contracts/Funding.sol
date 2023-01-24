/*
    สำหรับทดสอบสร้างโดย 
    Mac
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

struct Project{
    uint id;
    string name;
    uint _balance;
    address owner;
}

contract Funding{
    address public owner;
    mapping(address => Project) public project;
    uint public projectCounts  = 0;
    address[] public addressUser;

    event CreateFunding(address indexed _from, uint _id, string name);
    event DonateFunding(address indexed _from, address indexed _to, uint value);
    event WithdrawFunding(address indexed _from, uint value);

    constructor(){
        owner = msg.sender;
    }

    function createFunding(string memory name) public{
        require(project[msg.sender].id == 0, "Account has already been used");

        projectCounts++;
        project[msg.sender] = Project(projectCounts, name, 0, msg.sender);

        emit CreateFunding(msg.sender, projectCounts, name);

        addressUser.push(msg.sender);
    }

    function donate(address addressAccount) public payable {
        require(project[addressAccount].id != 0, "This project does not have");
        require(msg.value > 0, "Please Enter Money Greater then 0");

        project[msg.sender]._balance += msg.value;

        emit DonateFunding(msg.sender, addressAccount, msg.value);
    }

    function withdraw(uint amount) public {
        require(project[msg.sender].id != 0, "You not have project");
        require(amount > 0, "Please Enter Money Greater then 0");
        require(project[msg.sender]._balance >= amount, "Your project is not enough money");

        payable(owner).transfer(amount);
        project[msg.sender]._balance -= amount;

        emit WithdrawFunding(msg.sender, amount);
    }
}