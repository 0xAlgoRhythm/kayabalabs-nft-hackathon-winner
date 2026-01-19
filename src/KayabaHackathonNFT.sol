// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title KayabaHackathonNFT
 * @dev NFT for Kayaba Labs Hackathon Achievements
 * - 4 Achievement Levels with DIFFERENT metadata/images each
 * - Soulbound (non-transferable)
 * - $0.50 minting fee for self-mint
 * - Free batch minting for admin
 * - Auto-generated Achievement IDs
 */
contract KayabaHackathonNFT is ERC721, ERC721URIStorage, Ownable {
    using Strings for uint256;

    // Achievement levels
    enum AchievementLevel {
        WINNER,          // 0 = 1st Place (Gold)
        RUNNER_UP,       // 1 = 2nd/3rd Place (Silver)
        FINALIST,        // 2 = Top 10 (Bronze)
        PARTICIPANT      // 3 = Participated (Standard)
    }

    // Hackathon achievement info
    struct HackathonInfo {
        string achievementId;     // Auto-generated: KL-HACK-0001
        string hackathonName;     // "ETHGlobal Paris 2024"
        string projectName;       // "DeFi Dashboard"
        AchievementLevel level;   // Winner, Runner-up, etc.
        string completionDate;    // "January 18, 2026"
    }

    uint256 private _nextTokenId;
    uint256 public constant MINT_FEE = 0.0003 ether; // ~$0.50 on L2s
    
    // Mapping from token ID to hackathon information
    mapping(uint256 => HackathonInfo) public hackathonInfo;
    
    // 4 Different metadata URIs (one for each level)
    string private _winnerMetadataURI;
    string private _runnerupMetadataURI;
    string private _finalistMetadataURI;
    string private _participantMetadataURI;
    
    // Achievement prefix for IDs (e.g., "KL-HACK")
    string public achievementPrefix;
    
    // Events
    event HackathonAchievementMinted(
        address indexed participant,
        uint256 indexed tokenId,
        string achievementId,
        string hackathonName,
        AchievementLevel level
    );
    event FundsWithdrawn(address indexed owner, uint256 amount);
    
    constructor(
        string memory winnerURI,
        string memory runnerupURI,
        string memory finalistURI,
        string memory participantURI,
        string memory _achievementPrefix
    ) ERC721("Kayaba Labs Hackathon Achievement", "KAYABA-HACK") Ownable(msg.sender) {
        _winnerMetadataURI = winnerURI;
        _runnerupMetadataURI = runnerupURI;
        _finalistMetadataURI = finalistURI;
        _participantMetadataURI = participantURI;
        achievementPrefix = _achievementPrefix; // e.g., "KL-HACK"
    }

    /**
     * @dev Mint hackathon achievement (auto-generates achievement ID)
     * @param to Participant's wallet address
     * @param hackathonName Name of the hackathon (e.g., "ETHGlobal Paris 2024")
     * @param projectName Name of the project submitted
     * @param level Achievement level (0=Winner, 1=Runner-up, 2=Finalist, 3=Participant)
     * @param date Completion date
     */
    function mintAchievement(
        address to,
        string memory hackathonName,
        string memory projectName,
        AchievementLevel level,
        string memory date
    ) public payable returns (uint256, string memory) {
        require(msg.value >= MINT_FEE, "Insufficient minting fee");
        require(bytes(hackathonName).length > 0, "Hackathon name required");
        require(bytes(projectName).length > 0, "Project name required");

        uint256 tokenId = _nextTokenId++;
        
        // Auto-generate achievement ID: KL-HACK-0001, KL-HACK-0002, etc.
        string memory achievementId = string(
            abi.encodePacked(
                achievementPrefix,
                "-",
                _padNumber(tokenId + 1, 4)
            )
        );
        
        _safeMint(to, tokenId);
        // Don't set URI here - it will be determined by tokenURI() based on level
        
        // Store hackathon information
        hackathonInfo[tokenId] = HackathonInfo({
            achievementId: achievementId,
            hackathonName: hackathonName,
            projectName: projectName,
            level: level,
            completionDate: date
        });
        
        emit HackathonAchievementMinted(to, tokenId, achievementId, hackathonName, level);
         
        // Refund excess payment
        if (msg.value > MINT_FEE) {
            payable(msg.sender).transfer(msg.value - MINT_FEE);
        }
        
    ) internal virtual override returns (address) {
        address from = _ownerOf(tokenId);
        
        if (from != address(0) && to != address(0)) {
            revert("Achievement is soulbound and cannot be transferred");
        }
        
        return super._update(to, tokenId, auth);
    }

    /**
     * @dev Batch mint achievements (only owner, no fees)
     * @param recipients Array of participant wallet addresses
     * @param hackathonName Name of the hackathon (same for all)
     * @param projectNames Array of project names (one per recipient)
     * @param levels Array of achievement levels (one per recipient)
     * @param dates Array of completion dates
     */
    function batchMintAchievements(
        address[] memory recipients,
        string memory hackathonName,
        string[] memory projectNames,
        AchievementLevel[] memory levels,
        string[] memory dates
    ) public onlyOwner returns (string[] memory) {
        require(recipients.length == projectNames.length, "Recipients and projects length mismatch");
        require(recipients.length == levels.length, "Recipients and levels length mismatch");
        require(recipients.length == dates.length, "Recipients and dates length mismatch");
        
        string[] memory achievementIds = new string[](recipients.length);
        
        for (uint256 i = 0; i < recipients.length; i++) {
            uint256 tokenId = _nextTokenId++;
            
            // Auto-generate achievement ID
            string memory achievementId = string(
                abi.encodePacked(
                    achievementPrefix,
                    "-",
                    _padNumber(tokenId + 1, 4)
                )
            );
            
            _safeMint(recipients[i], tokenId);
            // Don't set URI here - it will be determined by tokenURI() based on level
            
            // Store hackathon information
            hackathonInfo[tokenId] = HackathonInfo({
                achievementId: achievementId,
                hackathonName: hackathonName,
                projectName: projectNames[i],
                level: levels[i],
                completionDate: dates[i]
            });
            
            achievementIds[i] = achievementId;
            
            emit HackathonAchievementMinted(recipients[i], tokenId, achievementId, hackathonName, levels[i]);
        }
        
        return achievementIds;
    }

    /**
     * @dev Withdraw collected fees (only owner)
     */
    function withdrawFees() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        
        payable(owner()).transfer(balance);
        emit FundsWithdrawn(owner(), balance);
    }
    
    /**
     * @dev Update metadata URIs (only owner)
     */
    function setMetadataURIs(
        string memory winnerURI,
        string memory runnerupURI,
        string memory finalistURI,
        string memory participantURI
    ) public onlyOwner {
        _winnerMetadataURI = winnerURI;
        _runnerupMetadataURI = runnerupURI;
        _finalistMetadataURI = finalistURI;
        _participantMetadataURI = participantURI;
    }
    
    /**
     * @dev Update achievement prefix (only owner)
     */
    function setAchievementPrefix(string memory newPrefix) public onlyOwner {
        achievementPrefix = newPrefix;
    }
    
    /**
     * @dev Get complete achievement information for a token
     */
    function getAchievementInfo(uint256 tokenId) 
        public 
        view 
        returns (
            string memory achievementId,
            string memory hackathonName,
            string memory projectName,
            AchievementLevel level,
            string memory date,
            address participant
        ) 
    {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");
        HackathonInfo memory info = hackathonInfo[tokenId];
        return (
            info.achievementId,
            info.hackathonName,
            info.projectName,
            info.level,
            info.completionDate,
            ownerOf(tokenId)
        );
    }

    /**
     * @dev Get achievement ID for a specific token
     */
    function getAchievementId(uint256 tokenId) public view returns (string memory) {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");
        return hackathonInfo[tokenId].achievementId;
    }

    /**
     * @dev Get achievement level as string
     */
    function getLevelString(uint256 tokenId) public view returns (string memory) {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");
        AchievementLevel level = hackathonInfo[tokenId].level;
        
        if (level == AchievementLevel.WINNER) return "Winner";
        if (level == AchievementLevel.RUNNER_UP) return "Runner-up";
        if (level == AchievementLevel.FINALIST) return "Finalist";
        return "Participant";
    }

    /**
     * @dev Get all achievements for a specific wallet address
     */
    function getParticipantAchievements(address participant) 
        public 
        view 
        returns (uint256[] memory) 
    {
        uint256 total = totalSupply();
        uint256 count = 0;
        
        // First pass: count achievements
        for (uint256 i = 0; i < total; i++) {
            if (_ownerOf(i) == participant) {
                count++;
            }
        }
        
        // Second pass: collect token IDs
        uint256[] memory achievements = new uint256[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < total; i++) {
            if (_ownerOf(i) == participant) {
                achievements[index] = i;
                index++;
            }
        }
        
        return achievements;
    }

    /**
     * @dev Get total minted achievements
     */
    function totalSupply() public view returns (uint256) {
        return _nextTokenId;
    }

    /**
     * @dev Helper function to pad numbers with leading zeros
     */
    function _padNumber(uint256 num, uint256 length) internal pure returns (string memory) {
        bytes memory numStr = bytes(num.toString());
        if (numStr.length >= length) {
            return string(numStr);
        }
        
        bytes memory padded = new bytes(length);
        uint256 paddingLength = length - numStr.length;
        
        // Add leading zeros
        for (uint256 i = 0; i < paddingLength; i++) {
            padded[i] = "0";
        }
        
        // Add the number
        for (uint256 i = 0; i < numStr.length; i++) {
            padded[paddingLength + i] = numStr[i];
        }
        
        return string(padded);
    }

    /**
     * @dev Returns metadata URI based on achievement level
     * WINNERS get gold trophy, RUNNER_UPs get silver, etc.
     */
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");
        
        // Return different metadata based on achievement level
        AchievementLevel level = hackathonInfo[tokenId].level;
        
        if (level == AchievementLevel.WINNER) return _winnerMetadataURI;
        if (level == AchievementLevel.RUNNER_UP) return _runnerupMetadataURI;
        if (level == AchievementLevel.FINALIST) return _finalistMetadataURI;
        return _participantMetadataURI;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}