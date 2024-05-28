// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Test} from "forge-std/Test.sol";
import {Helper} from "../src/Helper.sol";
import {Malicious} from "../src/Malicious.sol";
import {Good} from "../src/Good.sol";
import {console} from "forge-std/console.sol";

contract AttackTester is Test {

    //declare variables for holding instances of our contracts
    Good public goodContract;
    Malicious public maliciousContract;

    function setUp() public {
        // Deploy the malicious contract
        maliciousContract = new Malicious();

    }

    function test_attack() public {

        //deploy the good contract with the address of the malicious contract as its constructor argument and deposit 3 ether
        goodContract = new Good{value: 3 ether}(address(maliciousContract));

        // Get an address using its private key
        address address1= vm.addr(1);
        
        //impersonate address1 for sending a transaction to the good Contract
        vm.prank(address1);
        //this transaction will add adddress1 to the eligibility list
        goodContract.addUserToList();

        //again impersonate address1, this time for checking if it eligible 
        vm.prank(address1);
        bool eligible = goodContract.isUserEligible();



        // the value of eligible should be false
        assertEq(eligible, false);
    }
}
