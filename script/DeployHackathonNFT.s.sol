// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/KayabaHackathonNFT.sol";

contract DeployHackathonNFT is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        // REPLACE WITH YOUR 4 METADATA URIs FROM LIGHTHOUSE
        string memory winnerURI = "https://gateway.lighthouse.storage/ipfs/WINNER_METADATA_CID";
