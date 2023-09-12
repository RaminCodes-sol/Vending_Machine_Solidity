// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;



contract Vending_Mechine {
    address public owner;
    
    //the vending machine can store only 255 donuts - uint8=255
    mapping(address => uint8) public donutBalances;


    constructor () {
        owner = msg.sender;
        donutBalances[address(this)] = 100;
    }


    /*-------Events-------*/
    event DonutPurchased(address indexed _buyerAddress, uint8 _amountOfDonuts);
    event VendingMachineRestocked(uint8 _amountOfDonutAdded);


    /*-------Get-Donut-Price-------*/
    function getDonutPrice () public pure returns(uint256) {
        return 0.1 ether;
    }


    /*-------Purchase-Donut-------*/
    function purchaseDonut (uint8 _amount) public payable {
        require(msg.value >= _amount * 0.1 ether, "You must pay at least 0.1 ether per donut.");
        require(donutBalances[address(this)] >= _amount,"There are not enough donuts to purchase.");

        donutBalances[address(this)] -= _amount;
        donutBalances[msg.sender] += _amount;

        (bool success, ) = payable(address(owner)).call{value: msg.value}("");
        require(success, "Transfer failed.");
        
        emit DonutPurchased(msg.sender, _amount);
    }


   /*-------Get-Balance-------*/
    function getBalance () public view returns (uint256) {
        require(msg.sender == owner, "Only the owner can get balance.");
        return owner.balance;
    }


    /*-------Get-Vending-Machine-Donut-Balance-------*/
    function getVendingMachineDonatBalance () public view returns (uint8) {
        return donutBalances[address(this)];
    }


    /*-------Restock-------*/
    function restock (uint8 _amount) public {
        require(msg.sender == owner, "Only the owner can restock this machine.");
        require(donutBalances[address(this)] + _amount <= 255, "The vending machine can store only 255 donuts.");

        donutBalances[address(this)] += _amount;

        emit VendingMachineRestocked(_amount);
    }  
}