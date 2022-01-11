// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    // Replace global wave count with msg.sender data
    mapping(address => uint256) public totalWaves;

    /*
     * This is an address => uint mapping, meaning I can associate an address with a number!
     * In this case, I'll be storing the address with the last time the user waved at us.
     */
    mapping(address => uint256) public lastWavedAt;

    /*
     * We will be using this below to help generate a random number
     */
    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }
    
    Wave[] waves;

    constructor() payable {
        console.log("Wave portal initiating many future Hellos");
        /*
         * Set the initial seed
         */
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {
        /*
         * We need to make sure the current timestamp is at least 20-seconds bigger than the last timestamp we stored
         */
        require(lastWavedAt[msg.sender] + 20 seconds < block.timestamp, "Wait 20s");

        /*
         * Update the current timestamp we have for the user
         */
        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves[msg.sender] += 1;
        console.log("%s has waved!", msg.sender);
        waves.push(Wave(msg.sender, _message, block.timestamp));

        /*
         * Generate a new seed for the next user that sends a wave
         */
        seed = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %d", seed);

        /*
         * Give a 50% chance that the user wins the prize.
         */
        if (seed <= 50) {
            console.log("%s won!", msg.sender);

            /*
             * The same code we had before to send the prize.
             */
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

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