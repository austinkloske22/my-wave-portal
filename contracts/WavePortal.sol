// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    // Replace global wave count with msg.sender data
    mapping(address => uint256) public totalWaves;

    constructor() {
        console.log("Wave portal initiating many future Hellos");
    }

    function wave() public {
        totalWaves[msg.sender] += 1;
        console.log("%s has waved!", msg.sender);
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("%s has %d total waves!", msg.sender, totalWaves[msg.sender]);
        return totalWaves[msg.sender];
    }

}