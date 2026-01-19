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
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}