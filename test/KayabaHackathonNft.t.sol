// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/KayabaHackathonNFT.sol";

contract KayabaHackathonNFTTest is Test {
    KayabaHackathonNFT public nft;
    
    address public owner = makeAddr("owner");
    address public participant1 = makeAddr("participant1");
    address public participant2 = makeAddr("participant2");
    address public participant3 = makeAddr("participant3");
    
    // Test metadata URIs
    string constant WINNER_URI = "ipfs://winner/metadata.json";
    string constant RUNNERUP_URI = "ipfs://runnerup/metadata.json";
    string constant FINALIST_URI = "ipfs://finalist/metadata.json";
    string constant PARTICIPANT_URI = "ipfs://participant/metadata.json";
    string constant ACHIEVEMENT_PREFIX = "KL-HACK";
    
    uint256 constant MINT_FEE = 0.0003 ether;

    function setUp() public {
        vm.deal(owner, 100 ether);
        vm.deal(participant1, 10 ether);
        vm.deal(participant2, 10 ether);
        vm.deal(participant3, 10 ether);
        
        vm.prank(owner);
        nft = new KayabaHackathonNFT(
            WINNER_URI,
            RUNNERUP_URI,
            FINALIST_URI,
            PARTICIPANT_URI,
            ACHIEVEMENT_PREFIX
        );
    }

    // Test 1: Constructor Initialization
    function testConstructor() public view {
        assertEq(nft.owner(), owner);
        assertEq(nft.achievementPrefix(), ACHIEVEMENT_PREFIX);
        assertEq(nft.MINT_FEE(), MINT_FEE);
    }

    // Test 2: Single Achievement Minting
    function testMintAchievement() public {
        vm.prank(participant1);
        (uint256 tokenId, string memory achievementId) = nft.mintAchievement{value: MINT_FEE}(
            participant1,
            "ETHGlobal Paris 2024",
            "DeFi Dashboard",
            KayabaHackathonNFT.AchievementLevel.WINNER,
            "January 18, 2026"
        );
        
        assertEq(nft.ownerOf(tokenId), participant1);
        assertEq(nft.totalSupply(), 1);
        assertEq(nft.getAchievementId(tokenId), achievementId);
        
        // Check achievement ID format
        assertEq(keccak256(bytes(achievementId)), keccak256(bytes("KL-HACK-0001")));
        
        // Check stored information
        (
            string memory storedId,
            string memory hackathonName,
            string memory projectName,
            KayabaHackathonNFT.AchievementLevel level,
            string memory date,
            address participant
        ) = nft.getAchievementInfo(tokenId);
        
        assertEq(storedId, achievementId);
        assertEq(hackathonName, "ETHGlobal Paris 2024");
        assertEq(projectName, "DeFi Dashboard");
        assertEq(uint256(level), uint256(KayabaHackathonNFT.AchievementLevel.WINNER));
        assertEq(date, "January 18, 2026");
        assertEq(participant, participant1);
    }

    // Test 3: Different Achievement Levels
    function testAllAchievementLevels() public {
        // Mint one of each level
        vm.prank(participant1);
        nft.mintAchievement{value: MINT_FEE}(
            participant1,
            "Hackathon 1",
            "Project A",
            KayabaHackathonNFT.AchievementLevel.WINNER,
            "2024-01-01"
        );
        
        vm.prank(participant2);
        nft.mintAchievement{value: MINT_FEE}(
            participant2,
            "Hackathon 2",
            "Project B",
            KayabaHackathonNFT.AchievementLevel.RUNNER_UP,
            "2024-01-02"
        );
        
        vm.prank(participant3);
        nft.mintAchievement{value: MINT_FEE}(
            participant3,
            "Hackathon 3",
            "Project C",
            KayabaHackathonNFT.AchievementLevel.FINALIST,
            "2024-01-03"
        );
        
        // Mint participant level from another address
        address participant4 = makeAddr("participant4");
        vm.deal(participant4, 10 ether);
        vm.prank(participant4);
        nft.mintAchievement{value: MINT_FEE}(
            participant4,
            "Hackathon 4",
            "Project D",
            KayabaHackathonNFT.AchievementLevel.PARTICIPANT,
            "2024-01-04"
        );
        
        assertEq(nft.totalSupply(), 4);
        assertEq(nft.getLevelString(0), "Winner");
        assertEq(nft.getLevelString(1), "Runner-up");
        assertEq(nft.getLevelString(2), "Finalist");
        assertEq(nft.getLevelString(3), "Participant");
    }

    // Test 4: Soulbound - Prevent Transfers
    function testSoulboundCannotTransfer() public {
        vm.prank(participant1);
        (uint256 tokenId, ) = nft.mintAchievement{value: MINT_FEE}(
            participant1,
            "Test Hackathon",
            "Test Project",
            KayabaHackathonNFT.AchievementLevel.WINNER,
            "2024-01-01"
        );
        
        // Try to transfer - should fail
        vm.prank(participant1);
        vm.expectRevert("Achievement is soulbound and cannot be transferred");
        nft.transferFrom(participant1, participant2, tokenId);
        
        // Verify ownership unchanged
        assertEq(nft.ownerOf(tokenId), participant1);
    }

    // Test 5: Batch Minting (Owner Only)
    function testBatchMintAchievements() public {
        address[] memory recipients = new address[](3);
        recipients[0] = participant1;
        recipients[1] = participant2;
        recipients[2] = participant3;
        
        string[] memory projectNames = new string[](3);
        projectNames[0] = "Project A";
        projectNames[1] = "Project B";
        projectNames[2] = "Project C";
        
        KayabaHackathonNFT.AchievementLevel[] memory levels = new KayabaHackathonNFT.AchievementLevel[](3);
        levels[0] = KayabaHackathonNFT.AchievementLevel.WINNER;
        levels[1] = KayabaHackathonNFT.AchievementLevel.RUNNER_UP;
        levels[2] = KayabaHackathonNFT.AchievementLevel.FINALIST;
        
        string[] memory dates = new string[](3);
        dates[0] = "2024-01-01";
        dates[1] = "2024-01-02";
        dates[2] = "2024-01-03";
        
        vm.prank(owner);
        string[] memory achievementIds = nft.batchMintAchievements(
            recipients,
            "ETHGlobal Paris 2024",
            projectNames,
            levels,
            dates
        );
        
        assertEq(nft.totalSupply(), 3);
        assertEq(nft.ownerOf(0), participant1);
        assertEq(nft.ownerOf(1), participant2);
        assertEq(nft.ownerOf(2), participant3);
        
        // Check achievement IDs
        assertEq(achievementIds[0], "KL-HACK-0001");
        assertEq(achievementIds[1], "KL-HACK-0002");
        assertEq(achievementIds[2], "KL-HACK-0003");
    }

    // Test 6: Batch Minting Validation
    function testBatchMintValidation() public {
        address[] memory recipients = new address[](2);
        recipients[0] = participant1;
        recipients[1] = participant2;
        
        string[] memory projectNames = new string[](3); // Wrong length
        projectNames[0] = "Project A";
        projectNames[1] = "Project B";
        projectNames[2] = "Project C";
        
        KayabaHackathonNFT.AchievementLevel[] memory levels = new KayabaHackathonNFT.AchievementLevel[](2);
        levels[0] = KayabaHackathonNFT.AchievementLevel.WINNER;
        levels[1] = KayabaHackathonNFT.AchievementLevel.RUNNER_UP;
        
        string[] memory dates = new string[](2);
        dates[0] = "2024-01-01";
        dates[1] = "2024-01-02";
        
        vm.prank(owner);
        vm.expectRevert("Recipients and projects length mismatch");
        nft.batchMintAchievements(
            recipients,
            "Hackathon",
            projectNames,
            levels,
            dates
        );
    }

    // Test 7: Non-Owner Cannot Batch Mint
    function testNonOwnerCannotBatchMint() public {
        address[] memory recipients = new address[](1);
        recipients[0] = participant1;
        
        string[] memory projectNames = new string[](1);
        projectNames[0] = "Project A";
        
        KayabaHackathonNFT.AchievementLevel[] memory levels = new KayabaHackathonNFT.AchievementLevel[](1);
        levels[0] = KayabaHackathonNFT.AchievementLevel.WINNER;
        
        string[] memory dates = new string[](1);
        dates[0] = "2024-01-01";
        
        vm.prank(participant1);
        vm.expectRevert("Ownable: caller is not the owner");
        nft.batchMintAchievements(
            recipients,
            "Hackathon",
            projectNames,
            levels,
            dates
        );
    }

    // Test 8: Minting Fee Required
    function testMintingFeeRequired() public {
        vm.prank(participant1);
        vm.expectRevert("Insufficient minting fee");
        nft.mintAchievement(
            participant1,
            "Hackathon",
            "Project",
            KayabaHackathonNFT.AchievementLevel.WINNER,
            "2024-01-01"
        );
        
        // Should work with exact fee
        vm.prank(participant1);
        nft.mintAchievement{value: MINT_FEE}(
            participant1,
            "Hackathon",
            "Project",
            KayabaHackathonNFT.AchievementLevel.WINNER,
            "2024-01-01"
        );
    }

    // Test 9: Excess Fee Refund
    function testExcessFeeRefund() public {
        uint256 initialBalance = participant1.balance;
        uint256 excessAmount = 0.001 ether;
        
        vm.prank(participant1);
        nft.mintAchievement{value: MINT_FEE + excessAmount}(
            participant1,
            "Hackathon",
            "Project",
            KayabaHackathonNFT.AchievementLevel.WINNER,
            "2024-01-01"
        );
        
        // Should be refunded excess amount
        assertEq(participant1.balance, initialBalance - MINT_FEE);
    }

    // Test 10: Required Fields Validation
    function testRequiredFields() public {
        // Empty hackathon name
        vm.prank(participant1);
        vm.expectRevert("Hackathon name required");
        nft.mintAchievement{value: MINT_FEE}(
            participant1,
            "",
            "Project",
            KayabaHackathonNFT.AchievementLevel.WINNER,
            "2024-01-01"
        );
        
        // Empty project name
        vm.prank(participant1);
        vm.expectRevert("Project name required");
        nft.mintAchievement{value: MINT_FEE}(
            participant1,
            "Hackathon",
            "",
            KayabaHackathonNFT.AchievementLevel.WINNER,
            "2024-01-01"
        );
    }

    // Test 11: Achievement ID Generation
    function testAchievementIdGeneration() public {
        // Mint multiple achievements and check IDs
        for (uint256 i = 0; i < 5; i++) {
            address user = makeAddr(string(abi.encodePacked("user", Strings.toString(i))));
            vm.deal(user, 10 ether);
            
            vm.prank(user);
            (uint256 tokenId, string memory achievementId) = nft.mintAchievement{value: MINT_FEE}(
                user,
                string(abi.encodePacked("Hackathon ", Strings.toString(i))),
                string(abi.encodePacked("Project ", Strings.toString(i))),
                KayabaHackathonNFT.AchievementLevel.PARTICIPANT,
                "2024-01-01"
            );
            
            // Check ID format
            string memory expectedId = string(abi.encodePacked("KL-HACK-", _padNumber(i + 1, 4)));
            assertEq(achievementId, expectedId);
            assertEq(tokenId, i);
        }
        
        assertEq(nft.totalSupply(), 5);
    }

    // Test 12: Metadata URI Based on Level
    function testTokenURIByLevel() public {
        vm.prank(participant1);
        nft.mintAchievement{value: MINT_FEE}(
            participant1,
            "Hackathon",
            "Project",
            KayabaHackathonNFT.AchievementLevel.WINNER,
            "2024-01-01"
        );
        
        assertEq(nft.tokenURI(0), WINNER_URI);
        
        vm.prank(participant2);
        nft.mintAchievement{value: MINT_FEE}(
            participant2,
            "Hackathon",
            "Project",
            KayabaHackathonNFT.AchievementLevel.RUNNER_UP,
            "2024-01-01"
        );
        
        assertEq(nft.tokenURI(1), RUNNERUP_URI);
    }

    // Test 13: Get Participant Achievements
    function testGetParticipantAchievements() public {
        // Mint multiple achievements for participant1
        for (uint256 i = 0; i < 3; i++) {
            vm.prank(participant1);
            nft.mintAchievement{value: MINT_FEE}(
                participant1,
                string(abi.encodePacked("Hackathon ", Strings.toString(i))),
                string(abi.encodePacked("Project ", Strings.toString(i))),
                KayabaHackathonNFT.AchievementLevel.PARTICIPANT,
                "2024-01-01"
            );
        }
        
        // Mint one for participant2
        vm.prank(participant2);
        nft.mintAchievement{value: MINT_FEE}(
            participant2,
            "Hackathon",
            "Project",
            KayabaHackathonNFT.AchievementLevel.WINNER,
            "2024-01-01"
        );
        
        uint256[] memory p1Achievements = nft.getParticipantAchievements(participant1);
        uint256[] memory p2Achievements = nft.getParticipantAchievements(participant2);
        uint256[] memory p3Achievements = nft.getParticipantAchievements(participant3);
        
        assertEq(p1Achievements.length, 3);
        assertEq(p2Achievements.length, 1);
        assertEq(p3Achievements.length, 0);
        
        // Check token IDs
        assertEq(p1Achievements[0], 0);
        assertEq(p1Achievements[1], 1);
        assertEq(p1Achievements[2], 2);
        assertEq(p2Achievements[0], 3);
    }

    // Test 14: Withdraw Fees
    function testWithdrawFees() public {
        uint256 initialOwnerBalance = owner.balance;
        
        // Mint 3 achievements
        vm.prank(participant1);
        nft.mintAchievement{value: MINT_FEE}(participant1, "H1", "P1", KayabaHackathonNFT.AchievementLevel.WINNER, "2024-01-01");
        
        vm.prank(participant2);
        nft.mintAchievement{value: MINT_FEE}(participant2, "H2", "P2", KayabaHackathonNFT.AchievementLevel.WINNER, "2024-01-01");
        
        vm.prank(participant3);
        nft.mintAchievement{value: MINT_FEE}(participant3, "H3", "P3", KayabaHackathonNFT.AchievementLevel.WINNER, "2024-01-01");
        
        uint256 contractBalance = address(nft).balance;
        assertEq(contractBalance, MINT_FEE * 3);
        
        // Withdraw as owner
        vm.prank(owner);
        nft.withdrawFees();
        
        assertEq(owner.balance, initialOwnerBalance + (MINT_FEE * 3));
        assertEq(address(nft).balance, 0);
    }

    // Test 15: Non-Owner Cannot Withdraw
    function testNonOwnerCannotWithdraw() public {
        vm.prank(participant1);
        nft.mintAchievement{value: MINT_FEE}(participant1, "H", "P", KayabaHackathonNFT.AchievementLevel.WINNER, "2024-01-01");
        
        vm.prank(participant1);
        vm.expectRevert("Ownable: caller is not the owner");
        nft.withdrawFees();
    }

    // Test 16: Update Metadata URIs
    function testUpdateMetadataURIs() public {
        string memory newWinnerURI = "ipfs://new-winner/metadata.json";
        string memory newRunnerupURI = "ipfs://new-runnerup/metadata.json";
        
        vm.prank(owner);
        nft.setMetadataURIs(newWinnerURI, newRunnerupURI, FINALIST_URI, PARTICIPANT_URI);
        
        // Mint and check new URI
        vm.prank(participant1);
        nft.mintAchievement{value: MINT_FEE}(
            participant1,
            "Hackathon",
            "Project",
            KayabaHackathonNFT.AchievementLevel.WINNER,
            "2024-01-01"
        );
        
        assertEq(nft.tokenURI(0), newWinnerURI);
    }

    // Test 17: Update Achievement Prefix
    function testUpdateAchievementPrefix() public {
        string memory newPrefix = "KAYABA-HACKATHON";
        
        vm.prank(owner);
        nft.setAchievementPrefix(newPrefix);
        
        vm.prank(participant1);
        (uint256 tokenId, string memory achievementId) = nft.mintAchievement{value: MINT_FEE}(
            participant1,
            "Hackathon",
            "Project",
            KayabaHackathonNFT.AchievementLevel.WINNER,
            "2024-01-01"
        );
        
        assertEq(achievementId, string(abi.encodePacked(newPrefix, "-0001")));
        assertEq(nft.getAchievementId(tokenId), achievementId);
    }

    // Test 18: Event Emissions
    function testEventEmissions() public {
        // Test mint event
        vm.expectEmit(true, true, false, true);
        emit KayabaHackathonNFT.HackathonAchievementMinted(
            participant1,
            0,
            "KL-HACK-0001",
            "ETHGlobal Paris 2024",
            KayabaHackathonNFT.AchievementLevel.WINNER
        );
        
        vm.prank(participant1);
        nft.mintAchievement{value: MINT_FEE}(
            participant1,
            "ETHGlobal Paris 2024",
            "DeFi Dashboard",
            KayabaHackathonNFT.AchievementLevel.WINNER,
            "January 18, 2026"
        );
        
        // Test batch mint events
        address[] memory recipients = new address[](1);
        recipients[0] = participant2;
        string[] memory projectNames = new string[](1);
        projectNames[0] = "Project";
        KayabaHackathonNFT.AchievementLevel[] memory levels = new KayabaHackathonNFT.AchievementLevel[](1);
        levels[0] = KayabaHackathonNFT.AchievementLevel.RUNNER_UP;
        string[] memory dates = new string[](1);
        dates[0] = "2024-01-01";
        
        vm.expectEmit(true, true, false, true);
        emit KayabaHackathonNFT.HackathonAchievementMinted(
            participant2,
            1,
            "KL-HACK-0002",
            "ETHGlobal Paris 2024",
            KayabaHackathonNFT.AchievementLevel.RUNNER_UP
        );
        
        vm.prank(owner);
        nft.batchMintAchievements(recipients, "ETHGlobal Paris 2024", projectNames, levels, dates);
        
        // Test withdraw event
        vm.expectEmit(true, false, false, false);
        emit KayabaHackathonNFT.FundsWithdrawn(owner, MINT_FEE);
        
        vm.prank(owner);
        nft.withdrawFees();
    }

    // Test 19: Non-Existent Token Reverts
    function testNonExistentToken() public {
        vm.expectRevert("Token does not exist");
        nft.getAchievementId(999);
        
        vm.expectRevert("Token does not exist");
        nft.getLevelString(999);
        
        vm.expectRevert("Token does not exist");
        nft.tokenURI(999);
        
        vm.expectRevert("Token does not exist");
        nft.getAchievementInfo(999);
    }

    // Helper function for padding numbers
    function _padNumber(uint256 num, uint256 length) internal pure returns (string memory) {
        bytes memory numStr = bytes(Strings.toString(num));
        if (numStr.length >= length) {
            return string(numStr);
        }
        
        bytes memory padded = new bytes(length);
        uint256 paddingLength = length - numStr.length;
        
        for (uint256 i = 0; i < paddingLength; i++) {
            padded[i] = "0";
        }
        
        for (uint256 i = 0; i < numStr.length; i++) {
            padded[paddingLength + i] = numStr[i];
        }
        
        return string(padded);
    }
}
