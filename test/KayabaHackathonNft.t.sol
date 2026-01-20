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
            PARTICIPANT_URI,
            ACHIEVEMENT_PREFIX
        );
        
        // Fund test addresses
        vm.deal(participant1, 10 ether);
        vm.deal(participant2, 10 ether);
        vm.deal(participant3, 10 ether);
    }
    
    // ===== BASIC MINTING TESTS =====
    
    function testMintWinnerWithFee() public {
        vm.prank(participant1);
        (uint256 tokenId, string memory achievementId) = nft.mintAchievement{value: MINT_FEE}(
            participant1,
            "ETHGlobal Paris 2024",
            "DeFi Dashboard",
            KayabaHackathonNFT.AchievementLevel.WINNER,
            "January 18, 2026"
        );
        
        assertEq(nft.ownerOf(tokenId), participant1);
        assertEq(tokenId, 0);
        assertEq(achievementId, "KL-HACK-0001");
        assertEq(address(nft).balance, MINT_FEE);
    }
    
    function testMintRunnerUpWithFee() public {
        vm.prank(participant1);
        (uint256 tokenId, string memory achievementId) = nft.mintAchievement{value: MINT_FEE}(
            participant1,
            "ETHGlobal Paris 2024",
            "NFT Marketplace",
            KayabaHackathonNFT.AchievementLevel.RUNNER_UP,
            "January 18, 2026"
        );
        
        assertEq(nft.ownerOf(tokenId), participant1);
        assertEq(achievementId, "KL-HACK-0001");
    }
    
    function testMintFinalistWithFee() public {
        vm.prank(participant1);
        (uint256 tokenId, ) = nft.mintAchievement{value: MINT_FEE}(
            participant1,
            "ETHGlobal Paris 2024",
            "DAO Tooling",
            KayabaHackathonNFT.AchievementLevel.FINALIST,
            "January 18, 2026"
        );
        
        assertEq(nft.ownerOf(tokenId), participant1);
    }
    
    function testMintParticipantWithFee() public {
        vm.prank(participant1);
        (uint256 tokenId, ) = nft.mintAchievement{value: MINT_FEE}(
            participant1,
            "ETHGlobal Paris 2024",
            "Web3 Game",
            KayabaHackathonNFT.AchievementLevel.PARTICIPANT,
            "January 18, 2026"
        );
        
        assertEq(nft.ownerOf(tokenId), participant1);
    }
    
    function testMintFailsWithInsufficientFee() public {
        vm.prank(participant1);
        vm.expectRevert("Insufficient minting fee");
        nft.mintAchievement{value: 0.0001 ether}(
            participant1,
            "ETHGlobal Paris 2024",
            "DeFi Dashboard",
            KayabaHackathonNFT.AchievementLevel.WINNER,
            "January 18, 2026"
        );
    }
    
    function testMintFailsWithEmptyHackathonName() public {
        vm.prank(participant1);
        vm.expectRevert("Hackathon name required");
        nft.mintAchievement{value: MINT_FEE}(
            participant1,
            "",
            "DeFi Dashboard",
            KayabaHackathonNFT.AchievementLevel.WINNER,
            "January 18, 2026"
        );
    }
    
    function testMintFailsWithEmptyProjectName() public {
        vm.prank(participant1);
        vm.expectRevert("Project name required");
        nft.mintAchievement{value: MINT_FEE}(
            participant1,
            "ETHGlobal Paris 2024",
            "",
            KayabaHackathonNFT.AchievementLevel.WINNER,
            "January 18, 2026"
        );
    }
    
    function testExcessPaymentRefunded() public {
        vm.prank(participant1);
        uint256 balanceBefore = participant1.balance;
        
        nft.mintAchievement{value: 0.001 ether}(
            participant1,
            "ETHGlobal Paris 2024",
            "DeFi Dashboard",
            KayabaHackathonNFT.AchievementLevel.WINNER,
            "January 18, 2026"
        );
        
        uint256 balanceAfter = participant1.balance;
        uint256 spent = balanceBefore - balanceAfter;
        
        // Should only spend MINT_FEE + gas
        assertGt(spent, MINT_FEE); // More than fee due to gas
        assertLt(spent, 0.001 ether); // Less than what was sent (excess refunded)
    }
    
    // ===== AUTO ID GENERATION TESTS =====
    
    function testAutoIncrementingAchievementIds() public {
        // Mint first achievement
        vm.prank(participant1);
        (, string memory id1) = nft.mintAchievement{value: MINT_FEE}(
            participant1,
            "ETHGlobal Paris 2024",
            "Project 1",
            KayabaHackathonNFT.AchievementLevel.WINNER,
            "January 18, 2026"
        );
        
        // Mint second achievement
        vm.prank(participant2);
        (, string memory id2) = nft.mintAchievement{value: MINT_FEE}(
            participant2,
            "ETHGlobal Paris 2024",
            "Project 2",
            KayabaHackathonNFT.AchievementLevel.RUNNER_UP,
            "January 18, 2026"
        );
