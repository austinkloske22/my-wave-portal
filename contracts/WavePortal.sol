// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    // Replace global wave count with msg.sender data
    mapping(address => uint256) public totalWaves;

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }
    
    Wave[] waves;

    constructor() {
        console.log("Wave portal initiating many future Hellos");
    }

    function wave(string memory _message) public {
        totalWaves[msg.sender] += 1;
        console.log("%s has waved!", msg.sender);
        waves.push(Wave(msg.sender, _message, block.timestamp));
        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getTotalWaves() external view returns (uint256) {
        console.log("%s has %d total waves!", msg.sender, totalWaves[msg.sender]);
        return totalWaves[msg.sender];
    }

    /*
    function getAllWaves0() external view returns(address[] memory, string[] memory, uint256[] memory ) {

        address[] memory waveAddresses = new address[](waves.length);
        string[] memory waveMessages = new string[](waves.length);
        uint256[] memory waveTimestamps = new uint256[](waves.length);
        
        for(uint i = 0; i < waves.length; i++ ) {
            waveAddresses[i] = waves[i].waver;
            waveMessages[i] = waves[i].message;
            waveTimestamps[i] = waves[i].timestamp;
        }
        return (waveAddresses, waveMessages, waveTimestamps);
    }
    */

    function getAllWaves() external view returns(Wave[] memory ) {
        return waves;
    }

}