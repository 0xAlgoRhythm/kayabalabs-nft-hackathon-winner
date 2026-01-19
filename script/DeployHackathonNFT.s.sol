// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/KayabaHackathonNFT.sol";

contract DeployHackathonNFT is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        // REPLACE WITH YOUR 4 METADATA URIs FROM LIGHTHOUSE
        string memory winnerURI = "https://gateway.lighthouse.storage/ipfs/WINNER_METADATA_CID";
        string memory runnerupURI = "https://gateway.lighthouse.storage/ipfs/RUNNERUP_METADATA_CID";
        string memory finalistURI = "https://gateway.lighthouse.storage/ipfs/FINALIST_METADATA_CID";
        string memory participantURI = "https://gateway.lighthouse.storage/ipfs/PARTICIPANT_METADATA_CID";
        
        // Achievement prefix for IDs
        string memory achievementPrefix = "KL-HACK";
        
        vm.startBroadcast(deployerPrivateKey);
        
        KayabaHackathonNFT nft = new KayabaHackathonNFT(
            winnerURI,
            runnerupURI,
            finalistURI,
            participantURI,
            achievementPrefix
        );
        
        console.log("====================================");
        console.log("Kayaba Hackathon Achievement NFT Deployed!");
