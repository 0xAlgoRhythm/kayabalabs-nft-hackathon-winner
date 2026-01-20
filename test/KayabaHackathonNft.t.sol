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
        
        // Mint third achievement
        vm.prank(participant3);
        (, string memory id3) = nft.mintAchievement{value: MINT_FEE}(
            participant3,
            "ETHGlobal Paris 2024",
            "Project 3",
            KayabaHackathonNFT.AchievementLevel.PARTICIPANT,
            "January 18, 2026"
        );
        
        assertEq(id1, "KL-HACK-0001");
        assertEq(id2, "KL-HACK-0002");
        assertEq(id3, "KL-HACK-0003");
        assertEq(nft.totalSupply(), 3);
    }
    
    // ===== METADATA URI TESTS =====
    
    function testWinnerGetsCorrectMetadata() public {
        vm.prank(participant1);
        (uint256 tokenId, ) = nft.mintAchievement{value: MINT_FEE}(
            participant1,
            "ETHGlobal Paris 2024",
            "Winner Project",
            KayabaHackathonNFT.AchievementLevel.WINNER,
            "January 18, 2026"
        );
        
        string memory uri = nft.tokenURI(tokenId);
        assertEq(uri, WINNER_URI);
    }
    
    function testRunnerUpGetsCorrectMetadata() public {
        vm.prank(participant1);
        (uint256 tokenId, ) = nft.mintAchievement{value: MINT_FEE}(
            participant1,
            "ETHGlobal Paris 2024",
            "Runner-up Project",
            KayabaHackathonNFT.AchievementLevel.RUNNER_UP,
            "January 18, 2026"
        );
        
        string memory uri = nft.tokenURI(tokenId);
        assertEq(uri, RUNNERUP_URI);
    }
    
    function testFinalistGetsCorrectMetadata() public {
        vm.prank(participant1);
        (uint256 tokenId, ) = nft.mintAchievement{value: MINT_FEE}(
            participant1,
            "ETHGlobal Paris 2024",
            "Finalist Project",
            KayabaHackathonNFT.AchievementLevel.FINALIST,
            "January 18, 2026"
        );
        
        string memory uri = nft.tokenURI(tokenId);
        assertEq(uri, FINALIST_URI);
    }
    
    function testParticipantGetsCorrectMetadata() public {
        vm.prank(participant1);
        (uint256 tokenId, ) = nft.mintAchievement{value: MINT_FEE}(
            participant1,
            "ETHGlobal Paris 2024",
            "Participant Project",
            KayabaHackathonNFT.AchievementLevel.PARTICIPANT,
            "January 18, 2026"
        );
        
        string memory uri = nft.tokenURI(tokenId);
        assertEq(uri, PARTICIPANT_URI);
    }
    
    // ===== BATCH MINTING TESTS =====
    
    function testBatchMintDifferentLevels() public {
        address[] memory recipients = new address[](4);
        recipients[0] = participant1;
        recipients[1] = participant2;
        recipients[2] = participant3;
        recipients[3] = address(0x4);
        
        string[] memory projects = new string[](4);
        projects[0] = "Winner Project";
        projects[1] = "Runner-up Project";
        projects[2] = "Finalist Project";
        projects[3] = "Participant Project";
        
        KayabaHackathonNFT.AchievementLevel[] memory levels = new KayabaHackathonNFT.AchievementLevel[](4);
        levels[0] = KayabaHackathonNFT.AchievementLevel.WINNER;
        levels[1] = KayabaHackathonNFT.AchievementLevel.RUNNER_UP;
        levels[2] = KayabaHackathonNFT.AchievementLevel.FINALIST;
        levels[3] = KayabaHackathonNFT.AchievementLevel.PARTICIPANT;
        
        string[] memory dates = new string[](4);
        dates[0] = "January 18, 2026";
        dates[1] = "January 18, 2026";
        dates[2] = "January 18, 2026";
        dates[3] = "January 18, 2026";
        
        string[] memory achievementIds = nft.batchMintAchievements(
            recipients,
            "ETHGlobal Paris 2024",
            projects,
            levels,
            dates
        );
        
        assertEq(nft.totalSupply(), 4);
        assertEq(achievementIds[0], "KL-HACK-0001");
        assertEq(achievementIds[1], "KL-HACK-0002");
        assertEq(achievementIds[2], "KL-HACK-0003");
        assertEq(achievementIds[3], "KL-HACK-0004");
        
        // Check each has correct metadata
        assertEq(nft.tokenURI(0), WINNER_URI);
        assertEq(nft.tokenURI(1), RUNNERUP_URI);
        assertEq(nft.tokenURI(2), FINALIST_URI);
        assertEq(nft.tokenURI(3), PARTICIPANT_URI);
    }
    
    function testBatchMintOnlyOwner() public {
        address[] memory recipients = new address[](1);
        recipients[0] = participant1;
        
