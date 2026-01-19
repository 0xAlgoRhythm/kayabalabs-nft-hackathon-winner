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
        console.log("====================================");
        console.log("Contract Address:", address(nft));
        console.log("Achievement Prefix:", achievementPrefix);
        console.log("====================================");
        console.log("");
        console.log("Metadata URIs:");
        console.log("  Winner:      ", winnerURI);
        console.log("  Runner-up:   ", runnerupURI);
        console.log("  Finalist:    ", finalistURI);
        console.log("  Participant: ", participantURI);
        console.log("====================================");
        console.log("");
        console.log("Achievement IDs (auto-generated):");
        console.log("  Token #0 = KL-HACK-0001");
        console.log("  Token #1 = KL-HACK-0002");
        console.log("  Token #2 = KL-HACK-0003");
        console.log("  ... and so on");
        console.log("====================================");
        console.log("");
        console.log("Achievement Levels:");
        console.log("  0 = Winner     -> Shows GOLD trophy");
        console.log("  1 = Runner-up  -> Shows SILVER trophy");
        console.log("  2 = Finalist   -> Shows BRONZE trophy");
        console.log("  3 = Participant -> Shows STANDARD badge");
        console.log("====================================");
        
        vm.stopBroadcast();
    }
}