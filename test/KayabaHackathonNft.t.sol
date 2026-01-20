// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/KayabaHackathonNFT.sol";

contract KayabaHackathonNFTTest is Test {
    KayabaHackathonNFT public nft;
    address public owner;
    address public participant1;
    address public participant2;
    address public participant3;
    
    uint256 constant MINT_FEE = 0.0003 ether;
    
    string constant WINNER_URI = "https://gateway.lighthouse.storage/ipfs/winner";
    string constant RUNNERUP_URI = "https://gateway.lighthouse.storage/ipfs/runnerup";
    string constant FINALIST_URI = "https://gateway.lighthouse.storage/ipfs/finalist";
    string constant PARTICIPANT_URI = "https://gateway.lighthouse.storage/ipfs/participant";
    string constant ACHIEVEMENT_PREFIX = "KL-HACK";
    
    // Add receive function to accept ETH
    receive() external payable {}
    
    function setUp() public {
        owner = address(this);
        participant1 = address(0x1);
        participant2 = address(0x2);
        participant3 = address(0x3);
        
        nft = new KayabaHackathonNFT(
            WINNER_URI,
            RUNNERUP_URI,
            FINALIST_URI,
