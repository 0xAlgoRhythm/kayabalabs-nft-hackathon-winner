#!/bin/bash

# hackathon-manager.sh
# Complete management script for Kayaba Labs Hackathon NFT
# All features included - no frontend needed!

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Load environment
if [ ! -f .env ]; then
    echo -e "${RED}Error: .env file not found${NC}"
    exit 1
fi
source .env

# Contract address
CONTRACT_ADDRESS=0x1bdf9a36D08ad5847AD00ed374bA44e9B838544F

# Helper function to pause
pause() {
    read -p "Press Enter to continue..."
}

# Show header
show_header() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║     Kayaba Labs Hackathon NFT Management System       ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Main menu
main_menu() {
    while true; do
        show_header
        echo -e "${YELLOW}═══ MAIN MENU ═══${NC}"
        echo ""
        echo -e "${GREEN}MINTING:${NC}"
        echo "  1) 🏆 Mint Single Achievement (Winner/Runner-up/Finalist/Participant)"
        echo "  2) 📊 Batch Mint Multiple Achievements"
        echo "  3) 📁 Batch Mint from CSV File"
        echo ""
        echo -e "${GREEN}VIEWING:${NC}"
        echo "  4) 📈 View Contract Stats"
        echo "  5) 🔍 View Achievement Details"
        echo "  6) 👤 View Participant's Achievements"
        echo "  7) 📋 List All Achievements"
        echo ""
        echo -e "${GREEN}MANAGEMENT:${NC}"
        echo "  8) 💰 Withdraw Collected Fees"
        echo "  9) 🔧 Update Metadata URIs"
        echo "  10) 🏷️ Change Achievement Prefix"
        echo "  11) ⚙️ View Contract Configuration"
        echo ""
        echo -e "${GREEN}UTILITIES:${NC}"
        echo "  12) 📝 Generate Sample CSV"
        echo "  13) 🔗 View Important Links"
        echo "  14) 🧪 Run Quick Tests"
        echo ""
        echo -e "${RED}  0) Exit${NC}"
        echo ""
        read -p "Enter choice [0-14]: " choice
        
        case $choice in
            1) mint_single ;;
            2) batch_mint_interactive ;;
            3) batch_mint_csv ;;
            4) view_stats ;;
            5) view_achievement ;;
            6) view_participant_achievements ;;
            7) list_all_achievements ;;
            8) withdraw_fees ;;
            9) update_metadata ;;
            10) change_prefix ;;
            11) view_config ;;
            12) generate_csv ;;
            13) view_links ;;
            14) run_tests ;;
            0) echo -e "${GREEN}Goodbye!${NC}"; exit 0 ;;
            *) echo -e "${RED}Invalid choice${NC}"; pause ;;
        esac
    done
}

# 1. Mint Single Achievement
mint_single() {
    show_header
    echo -e "${CYAN}═══ MINT SINGLE ACHIEVEMENT ═══${NC}"
    echo ""
    
    # Select level
    echo -e "${YELLOW}Select Achievement Level:${NC}"
    echo "  1) 🏆 Winner (1st Place - Gold Trophy)"
    echo "  2) 🥈 Runner-up (2nd/3rd Place - Silver Trophy)"
    echo "  3) 🥉 Finalist (Top 10 - Bronze Trophy)"
    echo "  4) 🎖️  Participant (Standard Badge)"
    echo ""
    read -p "Enter choice [1-4]: " level_choice
    
    case $level_choice in
        1) LEVEL=0; LEVEL_NAME="Winner 🏆" ;;
        2) LEVEL=1; LEVEL_NAME="Runner-up 🥈" ;;
        3) LEVEL=2; LEVEL_NAME="Finalist 🥉" ;;
        4) LEVEL=3; LEVEL_NAME="Participant 🎖️" ;;
        *) echo -e "${RED}Invalid choice${NC}"; pause; return ;;
    esac
    
    echo ""
    read -p "Wallet Address: " WALLET
    read -p "Hackathon Name: " HACKATHON_NAME
    read -p "Project Name: " PROJECT_NAME
    read -p "Completion Date: " COMPLETION_DATE
    
    # Confirm
    echo ""
    echo -e "${YELLOW}═══ REVIEW ═══${NC}"
    echo "Level: $LEVEL_NAME"
    echo "Wallet: $WALLET"
    echo "Hackathon: $HACKATHON_NAME"
    echo "Project: $PROJECT_NAME"
    echo "Date: $COMPLETION_DATE"
    echo "Fee: 0.0003 ETH"
    echo ""
    read -p "Proceed? (y/n): " confirm
    
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        echo -e "${RED}Cancelled${NC}"
        pause
        return
    fi
    
    echo ""
    echo -e "${BLUE}Minting...${NC}"
    
    cast send $CONTRACT_ADDRESS \
        "mintAchievement(address,string,string,uint8,string)" \
        "$WALLET" \
        "$HACKATHON_NAME" \
        "$PROJECT_NAME" \
        $LEVEL \
        "$COMPLETION_DATE" \
        --value 0.0003ether \
        --rpc-url $BASE_SEPOLIA_RPC_URL \
        --private-key $PRIVATE_KEY
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}✅ Achievement minted successfully!${NC}"
    else
        echo -e "${RED}❌ Minting failed${NC}"
    fi
    
    pause
}

# 2. Batch Mint Interactive
batch_mint_interactive() {
    show_header
    echo -e "${CYAN}═══ BATCH MINT INTERACTIVE ═══${NC}"
    echo ""
    
    read -p "Hackathon Name: " HACKATHON_NAME
    
    echo ""
    echo -e "${YELLOW}Enter participant details (empty wallet to finish):${NC}"
    echo ""
    
    WALLETS=()
    PROJECTS=()
    LEVELS=()
    DATES=()
    
    while true; do
        echo -e "${CYAN}Participant #$((${#WALLETS[@]} + 1))${NC}"
        read -p "  Wallet (or Enter to finish): " WALLET
        
        if [ -z "$WALLET" ]; then
            break
        fi
        
        read -p "  Project Name: " PROJECT
        
        echo "  Achievement Level:"
        echo "    1) Winner 🏆"
        echo "    2) Runner-up 🥈"
        echo "    3) Finalist 🥉"
        echo "    4) Participant 🎖️"
        read -p "  Select [1-4]: " LEVEL_CHOICE
        
        case $LEVEL_CHOICE in
            1) LEVEL_NUM=0 ;;
            2) LEVEL_NUM=1 ;;
            3) LEVEL_NUM=2 ;;
            4) LEVEL_NUM=3 ;;
            *) echo "Invalid! Using Participant"; LEVEL_NUM=3 ;;
        esac
        
        read -p "  Date: " DATE
        
        WALLETS+=("$WALLET")
        PROJECTS+=("$PROJECT")
        LEVELS+=("$LEVEL_NUM")
        DATES+=("$DATE")
        
        echo -e "${GREEN}  ✓ Added${NC}"
        echo ""
    done
    
    if [ ${#WALLETS[@]} -eq 0 ]; then
        echo -e "${RED}No participants added${NC}"
        pause
        return
    fi
    
    # Format arrays
    WALLETS_STR=$(printf ',"%s"' "${WALLETS[@]}")
    WALLETS_STR="[${WALLETS_STR:1}]"
    
    PROJECTS_STR=$(printf ',"%s"' "${PROJECTS[@]}")
    PROJECTS_STR="[${PROJECTS_STR:1}]"
    
    LEVELS_STR=$(printf ',%s' "${LEVELS[@]}")
    LEVELS_STR="[${LEVELS_STR:1}]"
    
    DATES_STR=$(printf ',"%s"' "${DATES[@]}")
    DATES_STR="[${DATES_STR:1}]"
    
    # Review
    echo -e "${YELLOW}═══ REVIEW ═══${NC}"
    echo "Hackathon: $HACKATHON_NAME"
    echo "Total Participants: ${#WALLETS[@]}"
    echo ""
    for i in "${!WALLETS[@]}"; do
        LEVEL_TEXT="Participant"
        case ${LEVELS[$i]} in
            0) LEVEL_TEXT="Winner 🏆" ;;
            1) LEVEL_TEXT="Runner-up 🥈" ;;
            2) LEVEL_TEXT="Finalist 🥉" ;;
            3) LEVEL_TEXT="Participant 🎖️" ;;
        esac
        echo "  $((i+1)). ${WALLETS[$i]:0:10}... - ${PROJECTS[$i]} - $LEVEL_TEXT"
    done
    echo ""
    read -p "Proceed with batch mint? (y/n): " confirm
    
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        echo -e "${RED}Cancelled${NC}"
        pause
        return
    fi
    
    echo ""
    echo -e "${BLUE}Minting ${#WALLETS[@]} achievements...${NC}"
    
    cast send $CONTRACT_ADDRESS \
        "batchMintAchievements(address[],string,string[],uint8[],string[])" \
        "$WALLETS_STR" \
        "$HACKATHON_NAME" \
        "$PROJECTS_STR" \
        "$LEVELS_STR" \
        "$DATES_STR" \
        --rpc-url $BASE_SEPOLIA_RPC_URL \
        --private-key $PRIVATE_KEY
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}✅ Batch mint complete!${NC}"
    else
        echo -e "${RED}❌ Batch mint failed${NC}"
    fi
    
    pause
}

# 3. Batch Mint from CSV
batch_mint_csv() {
    show_header
    echo -e "${CYAN}═══ BATCH MINT FROM CSV ═══${NC}"
    echo ""
    
    read -p "CSV File Path: " CSV_FILE
    
    if [ ! -f "$CSV_FILE" ]; then
        echo -e "${RED}File not found: $CSV_FILE${NC}"
        pause
        return
    fi
    
    echo ""
    echo -e "${BLUE}Reading CSV file...${NC}"
    
    WALLETS=()
    PROJECTS=()
    LEVELS=()
    DATES=()
    HACKATHON_NAME=""
    
    # Read CSV (skip header)
    LINE_NUM=0
    while IFS=',' read -r wallet project level date hackathon || [ -n "$wallet" ]; do
        LINE_NUM=$((LINE_NUM + 1))
        
        # Skip header
        if [ $LINE_NUM -eq 1 ]; then
            continue
        fi
        
        # Skip empty lines
        if [ -z "$wallet" ]; then
            continue
        fi
        
        # Set hackathon name from first row
        if [ -z "$HACKATHON_NAME" ]; then
            HACKATHON_NAME="$hackathon"
        fi
        
        WALLETS+=("$wallet")
        PROJECTS+=("$project")
        LEVELS+=("$level")
        DATES+=("$date")
    done < "$CSV_FILE"
    
    if [ ${#WALLETS[@]} -eq 0 ]; then
        echo -e "${RED}No data found in CSV${NC}"
        pause
        return
    fi
    
    echo -e "${GREEN}Found ${#WALLETS[@]} participants${NC}"
    echo ""
    
    # Format arrays
    WALLETS_STR=$(printf ',"%s"' "${WALLETS[@]}")
    WALLETS_STR="[${WALLETS_STR:1}]"
    
    PROJECTS_STR=$(printf ',"%s"' "${PROJECTS[@]}")
    PROJECTS_STR="[${PROJECTS_STR:1}]"
    
    LEVELS_STR=$(printf ',%s' "${LEVELS[@]}")
    LEVELS_STR="[${LEVELS_STR:1}]"
    
    DATES_STR=$(printf ',"%s"' "${DATES[@]}")
    DATES_STR="[${DATES_STR:1}]"
    
    # Preview
    echo -e "${YELLOW}Preview (first 5):${NC}"
    for i in {0..4}; do
        if [ $i -lt ${#WALLETS[@]} ]; then
            echo "  $((i+1)). ${WALLETS[$i]:0:10}... - ${PROJECTS[$i]}"
        fi
    done
    echo ""
    
    read -p "Proceed with batch mint? (y/n): " confirm
    
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        echo -e "${RED}Cancelled${NC}"
        pause
        return
    fi
    
    echo ""
    echo -e "${BLUE}Minting ${#WALLETS[@]} achievements...${NC}"
    
    cast send $CONTRACT_ADDRESS \
        "batchMintAchievements(address[],string,string[],uint8[],string[])" \
        "$WALLETS_STR" \
        "$HACKATHON_NAME" \
        "$PROJECTS_STR" \
        "$LEVELS_STR" \
        "$DATES_STR" \
        --rpc-url $BASE_SEPOLIA_RPC_URL \
        --private-key $PRIVATE_KEY
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}✅ Batch mint from CSV complete!${NC}"
    else
        echo -e "${RED}❌ Batch mint failed${NC}"
    fi
    
    pause
}

# 4. View Contract Stats
view_stats() {
    show_header
    echo -e "${CYAN}═══ CONTRACT STATISTICS ═══${NC}"
    echo ""
    
    echo -e "${BLUE}Fetching data...${NC}"
    echo ""
    
    # Get total supply
    TOTAL_SUPPLY=$(cast call $CONTRACT_ADDRESS "totalSupply()" --rpc-url $BASE_SEPOLIA_RPC_URL 2>/dev/null)
    TOTAL_SUPPLY=$((TOTAL_SUPPLY))
    
    # Get contract balance
    BALANCE=$(cast balance $CONTRACT_ADDRESS --rpc-url $BASE_SEPOLIA_RPC_URL 2>/dev/null)
    BALANCE_ETH=$(echo "scale=4; $BALANCE / 1000000000000000000" | bc)
    
    # Get achievement prefix
    PREFIX=$(cast call $CONTRACT_ADDRESS "achievementPrefix()" --rpc-url $BASE_SEPOLIA_RPC_URL 2>/dev/null | xxd -r -p)
    
    echo -e "${YELLOW}Contract Address:${NC} $CONTRACT_ADDRESS"
    echo -e "${YELLOW}Network:${NC} Ethereum Sepolia"
    echo -e "${YELLOW}Achievement Prefix:${NC} $PREFIX"
    echo ""
    echo -e "${GREEN}Total Achievements Minted:${NC} $TOTAL_SUPPLY"
    echo -e "${GREEN}Contract Balance:${NC} $BALANCE_ETH ETH"
    echo -e "${GREEN}Estimated Revenue:${NC} \$$(echo "scale=2; $TOTAL_SUPPLY * 0.50" | bc)"
    echo ""
    echo -e "${CYAN}Achievement ID Range:${NC} $PREFIX-0001 to $PREFIX-$(printf "%04d" $TOTAL_SUPPLY)"
    echo ""
    
    pause
}

# 5. View Achievement Details
view_achievement() {
    show_header
    echo -e "${CYAN}═══ VIEW ACHIEVEMENT DETAILS ═══${NC}"
    echo ""
    
    read -p "Token ID: " TOKEN_ID
    
    echo ""
    echo -e "${BLUE}Fetching achievement #$TOKEN_ID...${NC}"
    echo ""
    
    # Get achievement info
    INFO=$(cast call $CONTRACT_ADDRESS "getAchievementInfo(uint256)" $TOKEN_ID --rpc-url $BASE_SEPOLIA_RPC_URL 2>/dev/null)
    
    if [ -z "$INFO" ]; then
        echo -e "${RED}Token not found or error occurred${NC}"
        pause
        return
    fi
    
    # Get level string
    LEVEL=$(cast call $CONTRACT_ADDRESS "getLevelString(uint256)" $TOKEN_ID --rpc-url $BASE_SEPOLIA_RPC_URL 2>/dev/null | xxd -r -p)
    
    # Get metadata URI
    URI=$(cast call $CONTRACT_ADDRESS "tokenURI(uint256)" $TOKEN_ID --rpc-url $BASE_SEPOLIA_RPC_URL 2>/dev/null | xxd -r -p)
    
    echo -e "${YELLOW}═══ Achievement #$TOKEN_ID ═══${NC}"
    echo -e "${GREEN}Level:${NC} $LEVEL"
    echo -e "${GREEN}Metadata URI:${NC} $URI"
    echo ""
    echo -e "${CYAN}View on OpenSea:${NC}"
    echo "https://testnets.opensea.io/assets/sepolia/$CONTRACT_ADDRESS/$TOKEN_ID"
    echo ""
    
    pause
}

# 6. View Participant's Achievements
view_participant_achievements() {
    show_header
    echo -e "${CYAN}═══ VIEW PARTICIPANT ACHIEVEMENTS ═══${NC}"
    echo ""
    
    read -p "Wallet Address: " WALLET
    
    echo ""
    echo -e "${BLUE}Fetching achievements for $WALLET...${NC}"
    echo ""
    
    # Get total supply first to loop through
    TOTAL_SUPPLY=$(cast call $CONTRACT_ADDRESS "totalSupply()" --rpc-url $BASE_SEPOLIA_RPC_URL 2>/dev/null)
    TOTAL_SUPPLY=$((TOTAL_SUPPLY))
    
    FOUND=0
    
    for ((i=0; i<$TOTAL_SUPPLY; i++)); do
        OWNER=$(cast call $CONTRACT_ADDRESS "ownerOf(uint256)" $i --rpc-url $BASE_SEPOLIA_RPC_URL 2>/dev/null)
        OWNER=$(echo $OWNER | tr '[:upper:]' '[:lower:]')
        WALLET_LOWER=$(echo $WALLET | tr '[:upper:]' '[:lower:]')
        
        if [[ "$OWNER" == *"$WALLET_LOWER"* ]]; then
            LEVEL=$(cast call $CONTRACT_ADDRESS "getLevelString(uint256)" $i --rpc-url $BASE_SEPOLIA_RPC_URL 2>/dev/null | xxd -r -p)
            ACHIEVEMENT_ID=$(cast call $CONTRACT_ADDRESS "getAchievementId(uint256)" $i --rpc-url $BASE_SEPOLIA_RPC_URL 2>/dev/null | xxd -r -p)
            
            echo -e "${GREEN}Token #$i:${NC} $ACHIEVEMENT_ID - $LEVEL"
            FOUND=$((FOUND + 1))
        fi
    done
    
    echo ""
    if [ $FOUND -eq 0 ]; then
        echo -e "${YELLOW}No achievements found for this wallet${NC}"
    else
        echo -e "${GREEN}Total: $FOUND achievements${NC}"
    fi
    echo ""
    
    pause
}

# 7. List All Achievements
list_all_achievements() {
    show_header
    echo -e "${CYAN}═══ ALL ACHIEVEMENTS ═══${NC}"
    echo ""
    
    TOTAL_SUPPLY=$(cast call $CONTRACT_ADDRESS "totalSupply()" --rpc-url $BASE_SEPOLIA_RPC_URL 2>/dev/null)
    TOTAL_SUPPLY=$((TOTAL_SUPPLY))
    
    if [ $TOTAL_SUPPLY -eq 0 ]; then
        echo -e "${YELLOW}No achievements minted yet${NC}"
        pause
        return
    fi
    
    echo -e "${BLUE}Loading $TOTAL_SUPPLY achievements...${NC}"
    echo ""
    
    for ((i=0; i<$TOTAL_SUPPLY; i++)); do
        ACHIEVEMENT_ID=$(cast call $CONTRACT_ADDRESS "getAchievementId(uint256)" $i --rpc-url $BASE_SEPOLIA_RPC_URL 2>/dev/null | xxd -r -p)
        LEVEL=$(cast call $CONTRACT_ADDRESS "getLevelString(uint256)" $i --rpc-url $BASE_SEPOLIA_RPC_URL 2>/dev/null | xxd -r -p)
        
        echo -e "${GREEN}#$i:${NC} $ACHIEVEMENT_ID - $LEVEL"
        
        # Pause every 20 items
        if [ $((($i + 1) % 20)) -eq 0 ]; then
            echo ""
            read -p "Press Enter for more (or Ctrl+C to exit)..."
            echo ""
        fi
    done
    
    echo ""
    echo -e "${CYAN}Total: $TOTAL_SUPPLY achievements${NC}"
    echo ""
    
    pause
}

# 8. Withdraw Fees
withdraw_fees() {
    show_header
    echo -e "${CYAN}═══ WITHDRAW COLLECTED FEES ═══${NC}"
    echo ""
    
    # Check balance
    BALANCE=$(cast balance $CONTRACT_ADDRESS --rpc-url $BASE_SEPOLIA_RPC_URL 2>/dev/null)
    BALANCE_ETH=$(echo "scale=4; $BALANCE / 1000000000000000000" | bc)
    
    echo -e "${YELLOW}Contract Balance:${NC} $BALANCE_ETH ETH"
    echo ""
    
    if (( $(echo "$BALANCE_ETH == 0" | bc -l) )); then
        echo -e "${RED}No funds to withdraw${NC}"
        pause
        return
    fi
    
    read -p "Withdraw all fees? (y/n): " confirm
    
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        echo -e "${RED}Cancelled${NC}"
        pause
        return
    fi
    
    echo ""
    echo -e "${BLUE}Withdrawing fees...${NC}"
    
    cast send $CONTRACT_ADDRESS \
        "withdrawFees()" \
        --rpc-url $BASE_SEPOLIA_RPC_URL \
        --private-key $PRIVATE_KEY
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}✅ Withdrawal successful!${NC}"
        echo -e "${GREEN}$BALANCE_ETH ETH sent to your wallet${NC}"
    else
        echo -e "${RED}❌ Withdrawal failed${NC}"
    fi
    
    pause
}

# 9. Update Metadata URIs
update_metadata() {
    show_header
    echo -e "${CYAN}═══ UPDATE METADATA URIs ═══${NC}"
    echo ""
    
    echo -e "${YELLOW}Current URIs:${NC}"
    echo ""
    echo "Winner:      [Current URI]"
    echo "Runner-up:   [Current URI]"
    echo "Finalist:    [Current URI]"
    echo "Participant: [Current URI]"
    echo ""
    
    read -p "New Winner URI: " WINNER_URI
    read -p "New Runner-up URI: " RUNNERUP_URI
    read -p "New Finalist URI: " FINALIST_URI
    read -p "New Participant URI: " PARTICIPANT_URI
    
    echo ""
    read -p "Update all metadata URIs? (y/n): " confirm
    
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        echo -e "${RED}Cancelled${NC}"
        pause
        return
    fi
    
    echo ""
    echo -e "${BLUE}Updating metadata URIs...${NC}"
    
    cast send $CONTRACT_ADDRESS \
        "setMetadataURIs(string,string,string,string)" \
        "$WINNER_URI" \
        "$RUNNERUP_URI" \
        "$FINALIST_URI" \
        "$PARTICIPANT_URI" \
        --rpc-url $BASE_SEPOLIA_RPC_URL \
        --private-key $PRIVATE_KEY
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}✅ Metadata URIs updated!${NC}"
    else
        echo -e "${RED}❌ Update failed${NC}"
    fi
    
    pause
}

# 10. Change Achievement Prefix
change_prefix() {
    show_header
    echo -e "${CYAN}═══ CHANGE ACHIEVEMENT PREFIX ═══${NC}"
    echo ""
    
    CURRENT_PREFIX=$(cast call $CONTRACT_ADDRESS "achievementPrefix()" --rpc-url $BASE_SEPOLIA_RPC_URL 2>/dev/null | xxd -r -p)
    
    echo -e "${YELLOW}Current Prefix:${NC} $CURRENT_PREFIX"
    echo ""
    read -p "New Prefix (e.g., KL-HACK): " NEW_PREFIX
    
    echo ""
    echo -e "${YELLOW}This will change future achievement IDs from:${NC}"
    echo "  $CURRENT_PREFIX-0001 → $NEW_PREFIX-0001"
    echo ""
    read -p "Proceed? (y/n): " confirm
    
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        echo -e "${RED}Cancelled${NC}"
        pause
        return
    fi
    
    echo ""
    echo -e "${BLUE}Updating prefix...${NC}"
    
    cast send $CONTRACT_ADDRESS \
        "setAchievementPrefix(string)" \
        "$NEW_PREFIX" \
        --rpc-url $BASE_SEPOLIA_RPC_URL \
        --private-key $PRIVATE_KEY
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}✅ Prefix updated to: $NEW_PREFIX${NC}"
    else
        echo -e "${RED}❌ Update failed${NC}"
    fi
    
    pause
}

# 11. View Contract Configuration
view_config() {
    show_header
    echo -e "${CYAN}═══ CONTRACT CONFIGURATION ═══${NC}"
    echo ""
    
    echo -e "${YELLOW}Contract Details:${NC}"
    echo "  Address: $CONTRACT_ADDRESS"
    echo "  Network: Ethereum Sepolia"
    echo "  RPC: $BASE_SEPOLIA_RPC_URL"
    echo ""
    
    PREFIX=$(cast call $CONTRACT_ADDRESS "achievementPrefix()" --rpc-url $BASE_SEPOLIA_RPC_URL 2>/dev/null | xxd -r -p)
    
    echo -e "${YELLOW}Settings:${NC}"
    echo "  Achievement Prefix: $PREFIX"
    echo "  Mint Fee: 0.0003 ETH (~\$0.50)"
    echo "  Soulbound: Yes (non-transferable)"
    echo ""
    
    echo -e "${YELLOW}Achievement Levels:${NC}"
    echo "  0 = Winner (Gold Trophy)"
    echo "  1 = Runner-up (Silver Trophy)"
    echo "  2 = Finalist (Bronze Trophy)"
    echo "  3 = Participant (Standard Badge)"
    echo ""
    
    echo -e "${YELLOW}Metadata URIs:${NC}"
    echo "  Winner:      https://coral-genuine-koi-966.mypinata.cloud/ipfs/bafkreiax7rg..."
    echo "  Runner-up:   https://coral-genuine-koi-966.mypinata.cloud/ipfs/bafkreih7pn3..."
    echo "  Finalist:    https://coral-genuine-koi-966.mypinata.cloud/ipfs/bafkreih5bnj..."
    echo "  Participant: https://coral-genuine-koi-966.mypinata.cloud/ipfs/bafkreiahc72..."
    echo ""
    
    pause
}

# 12. Generate Sample CSV
generate_csv() {
    show_header
    echo -e "${CYAN}═══ GENERATE SAMPLE CSV ═══${NC}"
    echo ""
    
    CSV_FILE="sample_participants.csv"
    
    cat > $CSV_FILE << 'EOF'
wallet,project,level,date,hackathon
0xBe1382237f760d8A26c9d6559DBf4239f97BF2eF,DeFi Dashboard,0,January 18 2026,ETHGlobal Paris 2024
0x76764f8DE65f6D2Cd00987d9791B8C6af00c1911,NFT Marketplace,1,January 18 2026,ETHGlobal Paris 2024
0x1234567890123456789012345678901234567890,DAO Tooling,2,January 18 2026,ETHGlobal Paris 2024
0xabcdefabcdefabcdefabcdefabcdefabcdefabcd,Web3 Game,3,January 18 2026,ETHGlobal Paris 2024
EOF
    
    echo -e "${GREEN}✅ Sample CSV generated: $CSV_FILE${NC}"
    echo ""
    echo -e "${YELLOW}CSV Format:${NC}"
    echo "  wallet,project,level,date,hackathon"
    echo ""
    echo -e "${YELLOW}Level Values:${NC}"
    echo "  0 = Winner"
    echo "  1 = Runner-up"
    echo "  2 = Finalist"
    echo "  3 = Participant"
    echo ""
    echo -e "${CYAN}Edit this file and use option 3 to batch mint!${NC}"
    echo ""
    
    pause
}

# 13. View Important Links
view_links() {
    show_header
    echo -e "${CYAN}═══ IMPORTANT LINKS ═══${NC}"
    echo ""
    
    echo -e "${YELLOW}Contract:${NC}"
    echo "  Address: $CONTRACT_ADDRESS"
    echo "  Explorer: https://sepolia.etherscan.io/address/$CONTRACT_ADDRESS"
    echo ""
    
    echo -e "${YELLOW}OpenSea:${NC}"
    echo "  Collection: https://testnets.opensea.io/assets/sepolia/$CONTRACT_ADDRESS"
    echo ""
    
    echo -e "${YELLOW}Documentation:${NC}"
    echo "  Foundry: https://book.getfoundry.sh/"
    echo "  Cast: https://book.getfoundry.sh/cast/"
    echo ""
    
    echo -e "${YELLOW}Networks:${NC}"
    echo "  Sepolia RPC: $BASE_SEPOLIA_RPC_URL"
    echo "  Chain ID: 11155111"
    echo ""
    
    echo -e "${YELLOW}Support:${NC}"
    echo "  GitHub: https://github.com/kayabalabs"
    echo "  Discord: discord.gg/kayabalabs"
    echo ""
    
    pause
}

# 14. Run Quick Tests
run_tests() {
    show_header
    echo -e "${CYAN}═══ QUICK TESTS ═══${NC}"
    echo ""
    
    echo -e "${BLUE}Running contract tests...${NC}"
    echo ""
    
    # Test 1: Check contract exists
    echo -n "1. Contract exists... "
    CODE=$(cast code $CONTRACT_ADDRESS --rpc-url $BASE_SEPOLIA_RPC_URL 2>/dev/null)
    if [ -n "$CODE" ]; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗${NC}"
    fi
    
    # Test 2: Check total supply
    echo -n "2. Can read total supply... "
    SUPPLY=$(cast call $CONTRACT_ADDRESS "totalSupply()" --rpc-url $BASE_SEPOLIA_RPC_URL 2>/dev/null)
    if [ -n "$SUPPLY" ]; then
        echo -e "${GREEN}✓${NC} (Total: $((SUPPLY)))"
    else
        echo -e "${RED}✗${NC}"
    fi
    
    # Test 3: Check achievement prefix
    echo -n "3. Can read achievement prefix... "
    PREFIX=$(cast call $CONTRACT_ADDRESS "achievementPrefix()" --rpc-url $BASE_SEPOLIA_RPC_URL 2>/dev/null | xxd -r -p)
    if [ -n "$PREFIX" ]; then
        echo -e "${GREEN}✓${NC} (Prefix: $PREFIX)"
    else
        echo -e "${RED}✗${NC}"
    fi
    
    # Test 4: Check contract balance
    echo -n "4. Can read contract balance... "
    BALANCE=$(cast balance $CONTRACT_ADDRESS --rpc-url $BASE_SEPOLIA_RPC_URL 2>/dev/null)
    if [ -n "$BALANCE" ]; then
        BALANCE_ETH=$(echo "scale=4; $BALANCE / 1000000000000000000" | bc)
        echo -e "${GREEN}✓${NC} (Balance: $BALANCE_ETH ETH)"
    else
        echo -e "${RED}✗${NC}"
    fi
    
    # Test 5: Check wallet balance
    echo -n "5. Wallet has sufficient balance... "
    WALLET_ADDRESS=$(cast wallet address --private-key $PRIVATE_KEY 2>/dev/null)
    WALLET_BALANCE=$(cast balance $WALLET_ADDRESS --rpc-url $BASE_SEPOLIA_RPC_URL 2>/dev/null)
    WALLET_ETH=$(echo "scale=4; $WALLET_BALANCE / 1000000000000000000" | bc)
    if (( $(echo "$WALLET_ETH > 0.001" | bc -l) )); then
        echo -e "${GREEN}✓${NC} (Balance: $WALLET_ETH ETH)"
    else
        echo -e "${YELLOW}⚠${NC} (Balance: $WALLET_ETH ETH - Low balance!)"
    fi
    
    echo ""
    echo -e "${GREEN}Tests complete!${NC}"
    echo ""
    
    pause
}

# Start the script
main_menu