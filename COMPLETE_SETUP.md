# Kayaba Labs Hackathon NFT - Complete Setup Guide (4 Different Images)

## 🎯 What You're Building

A hackathon achievement system with **4 DIFFERENT badges**:
- 🥇 **Winner** - Gold trophy (1st place)
- 🥈 **Runner-up** - Silver trophy (2nd/3rd place)
- 🥉 **Finalist** - Bronze trophy (Top 10)
- 🎖️ **Participant** - Standard badge (Participated)

Contract **automatically** picks the right image based on achievement level!

---

## 📋 Step-by-Step Setup (30 minutes)

### Step 1: Prepare Your 4 Badge Images (10 minutes)

Create or design 4 different badge images:

**Recommended sizes:** 500x500px or 1000x1000px

**File names:**
- `winner-badge.png` - Gold trophy 🏆
- `runnerup-badge.png` - Silver trophy 🥈
- `finalist-badge.png` - Bronze trophy 🥉
- `participant-badge.png` - Standard badge 🎖️

**Design tips:**
- Use gold/yellow for winner
- Use silver/gray for runner-up
- Use bronze/brown for finalist
- Use blue/standard for participant
- Keep consistent branding across all

---

### Step 2: Upload Images to Lighthouse (5 minutes)

```bash
# Go to https://files.lighthouse.storage/
# Upload each image ONE BY ONE
```

**After each upload, SAVE the CID:**

```
WINNER_IMAGE_CID=bafkrei...
RUNNERUP_IMAGE_CID=bafkrei...
FINALIST_IMAGE_CID=bafkrei...
PARTICIPANT_IMAGE_CID=bafkrei...
```

**Test URLs (should show your images):**
```
https://gateway.lighthouse.storage/ipfs/WINNER_IMAGE_CID
https://gateway.lighthouse.storage/ipfs/RUNNERUP_IMAGE_CID
https://gateway.lighthouse.storage/ipfs/FINALIST_IMAGE_CID
https://gateway.lighthouse.storage/ipfs/PARTICIPANT_IMAGE_CID
```

---

### Step 3: Create 4 Metadata JSON Files (5 minutes)

Create a folder:
```bash
mkdir hackathon-metadata
cd hackathon-metadata
```

**Create `winner.json`:**
```json
{
  "name": "Kayaba Labs - Hackathon Winner 🏆",
  "description": "This NFT certifies FIRST PLACE achievement in a Kayaba Labs hackathon. This is a soulbound credential representing excellence in blockchain innovation and development.",
  "image": "ipfs://YOUR_WINNER_IMAGE_CID",
  "external_url": "https://kayabalabs.com/hackathons",
  "attributes": [
    {
      "trait_type": "Achievement Type",
      "value": "Hackathon Winner"
    },
    {
      "trait_type": "Level",
      "value": "Winner"
    },
    {
      "trait_type": "Rank",
      "value": "1st Place"
    },
    {
      "trait_type": "Institution",
      "value": "Kayaba Labs"
    },
    {
      "trait_type": "Certificate Type",
      "value": "Soulbound NFT"
    },
    {
      "trait_type": "Rarity",
      "value": "Legendary"
    }
  ]
}
```

**Create `runnerup.json`:**
```json
{
  "name": "Kayaba Labs - Hackathon Runner-up 🥈",
  "description": "This NFT certifies RUNNER-UP achievement (2nd/3rd Place) in a Kayaba Labs hackathon. This is a soulbound credential representing outstanding performance in blockchain innovation.",
  "image": "ipfs://YOUR_RUNNERUP_IMAGE_CID",
  "external_url": "https://kayabalabs.com/hackathons",
  "attributes": [
    {
      "trait_type": "Achievement Type",
      "value": "Hackathon Runner-up"
    },
    {
      "trait_type": "Level",
      "value": "Runner-up"
    },
    {
      "trait_type": "Rank",
      "value": "2nd/3rd Place"
    },
    {
      "trait_type": "Institution",
      "value": "Kayaba Labs"
    },
    {
      "trait_type": "Certificate Type",
      "value": "Soulbound NFT"
    },
    {
      "trait_type": "Rarity",
      "value": "Epic"
    }
  ]
}
```

**Create `finalist.json`:**
```json
{
  "name": "Kayaba Labs - Hackathon Finalist 🥉",
  "description": "This NFT certifies FINALIST achievement (Top 10) in a Kayaba Labs hackathon. This is a soulbound credential representing exceptional skill in blockchain development.",
  "image": "ipfs://YOUR_FINALIST_IMAGE_CID",
  "external_url": "https://kayabalabs.com/hackathons",
  "attributes": [
    {
      "trait_type": "Achievement Type",
      "value": "Hackathon Finalist"
    },
    {
      "trait_type": "Level",
      "value": "Finalist"
    },
    {
      "trait_type": "Rank",
      "value": "Top 10"
    },
    {
      "trait_type": "Institution",
      "value": "Kayaba Labs"
    },
    {
      "trait_type": "Certificate Type",
      "value": "Soulbound NFT"
    },
    {
      "trait_type": "Rarity",
      "value": "Rare"
    }
  ]
}
```

**Create `participant.json`:**
```json
{
  "name": "Kayaba Labs - Hackathon Participant 🎖️",
  "description": "This NFT certifies participation in a Kayaba Labs hackathon. This is a soulbound credential representing engagement in blockchain innovation and learning.",
  "image": "ipfs://YOUR_PARTICIPANT_IMAGE_CID",
  "external_url": "https://kayabalabs.com/hackathons",
  "attributes": [
    {
      "trait_type": "Achievement Type",
      "value": "Hackathon Participant"
    },
    {
      "trait_type": "Level",
      "value": "Participant"
    },
    {
      "trait_type": "Rank",
      "value": "Participated"
    },
    {
      "trait_type": "Institution",
      "value": "Kayaba Labs"
    },
    {
      "trait_type": "Certificate Type",
      "value": "Soulbound NFT"
    },
    {
      "trait_type": "Rarity",
      "value": "Common"
    }
  ]
}
```

**IMPORTANT:** Replace `YOUR_*_IMAGE_CID` with actual CIDs from Step 2!

---

### Step 4: Upload 4 JSON Files to Lighthouse (3 minutes)

```bash
# Go to https://files.lighthouse.storage/
# Upload each JSON file ONE BY ONE
```

**Save each CID:**
```
WINNER_METADATA_CID=bafkrei...
RUNNERUP_METADATA_CID=bafkrei...
FINALIST_METADATA_CID=bafkrei...
PARTICIPANT_METADATA_CID=bafkrei...
```

**Test URLs (should show your JSON):**
```
https://gateway.lighthouse.storage/ipfs/WINNER_METADATA_CID
https://gateway.lighthouse.storage/ipfs/RUNNERUP_METADATA_CID
https://gateway.lighthouse.storage/ipfs/FINALIST_METADATA_CID
https://gateway.lighthouse.storage/ipfs/PARTICIPANT_METADATA_CID
```

---

### Step 5: Setup Forge Project (3 minutes)

```bash
cd /path/to/your/hackathon-nft-repo

# Initialize if not done
forge init

# Remove default files
rm src/Counter.sol test/Counter.t.sol script/Counter.s.sol

# Install OpenZeppelin
forge install OpenZeppelin/openzeppelin-contracts --no-commit

# Create remappings
echo '@openzeppelin/contracts/=lib/openzeppelin-contracts/contracts/' > remappings.txt

# Create .env
cat > .env << 'EOF'
PRIVATE_KEY=your_private_key_here
SCROLL_SEPOLIA_RPC_URL=https://sepolia-rpc.scroll.io
**Update deployment script with your CIDs:**
```bash
nano script/DeployHackathonNFT.s.sol
```

Replace the placeholder CIDs with your actual CIDs from Step 4.

---

### Step 7: Build & Deploy (2 minutes)

```bash
# Build
forge build

# Should compile successfully!

# Deploy to testnet
forge script script/DeployHackathonNFT.s.sol:DeployHackathonNFT \
    --rpc-url $SCROLL_SEPOLIA_RPC_URL \
    --broadcast \
    --verify \
    -vvvv
```

**SAVE THE CONTRACT ADDRESS!**

```bash
echo "CONTRACT_ADDRESS=0xYourContractAddress" >> .env
source .env
```

---

## 🎨 How It Works

When you mint an achievement:

**Winner (level 0):**
```bash
mintAchievement(wallet, "ETHGlobal", "DeFi App", 0, "Jan 18")
```
→ Shows **GOLD trophy** 🏆 (winner.json)

**Runner-up (level 1):**
```bash
mintAchievement(wallet, "ETHGlobal", "NFT Market", 1, "Jan 18")
```
→ Shows **SILVER trophy** 🥈 (runnerup.json)

**Finalist (level 2):**
```bash
mintAchievement(wallet, "ETHGlobal", "DAO Tool", 2, "Jan 18")
```
→ Shows **BRONZE trophy** 🥉 (finalist.json)

**Participant (level 3):**
```bash
mintAchievement(wallet, "ETHGlobal", "Web3 Game", 3, "Jan 18")
```
→ Shows **STANDARD badge** 🎖️ (participant.json)

---

## 🚀 Test Your Deployment

### Test 1: Mint Winner

```bash
cast send $CONTRACT_ADDRESS \
    "mintAchievement(address,string,string,uint8,string)" \
    YOUR_WALLET \
    "ETHGlobal Paris 2024" \
    "DeFi Dashboard" \
    0 \
    "January 18, 2026" \
    --value 0.0003ether \
    --rpc-url $SCROLL_SEPOLIA_RPC_URL \
    --private-key $PRIVATE_KEY
```

**Result:**
- Token ID: 0
- Achievement ID: KL-HACK-0001
- Image: Gold trophy 🏆
- Level: Winner

### Test 2: Check Metadata

```bash
cast call $CONTRACT_ADDRESS "tokenURI(uint256)" 0 --rpc-url $SCROLL_SEPOLIA_RPC_URL
```

Should return your WINNER metadata URI!

### Test 3: Verify on OpenSea (after 30 mins)

```
https://testnets.opensea.io/assets/sepolia/CONTRACT_ADDRESS/0
```

Should show **GOLD trophy** image!

---

## 📊 Batch Mint Example

Award 10 participants from ETHGlobal:

```bash
# 1 Winner, 2 Runner-ups, 3 Finalists, 4 Participants
cast send $CONTRACT_ADDRESS \
    "batchMintAchievements(address[],string,string[],uint8[],string[])" \
    "[0xW1,0xR1,0xR2,0xF1,0xF2,0xF3,0xP1,0xP2,0xP3,0xP4]" \
    "ETHGlobal Paris 2024" \
    "[\"DeFi\",\"NFT\",\"DAO\",\"Game1\",\"Game2\",\"Game3\",\"App1\",\"App2\",\"App3\",\"App4\"]" \
    "[0,1,1,2,2,2,3,3,3,3]" \
    "[\"Jan 18\",\"Jan 18\",\"Jan 18\",\"Jan 18\",\"Jan 18\",\"Jan 18\",\"Jan 18\",\"Jan 18\",\"Jan 18\",\"Jan 18\"]" \
    --rpc-url $SCROLL_SEPOLIA_RPC_URL \
    --private-key $PRIVATE_KEY
```

**Results:**
- Token 0: Winner - Gold 🏆
- Tokens 1-2: Runner-ups - Silver 🥈
- Tokens 3-5: Finalists - Bronze 🥉
- Tokens 6-9: Participants - Standard 🎖️

---

## ✅ Final Checklist

- [ ] 4 badge images created
- [ ] 4 images uploaded to Lighthouse
- [ ] 4 image CIDs saved
- [ ] 4 metadata JSON files created
- [ ] Image CIDs added to JSON files
- [ ] 4 JSON files uploaded to Lighthouse
- [ ] 4 metadata CIDs saved
- [ ] Contract file created
- [ ] Deployment script updated with CIDs
- [ ] Contract built successfully
- [ ] Contract deployed to testnet
- [ ] Winner NFT minted (shows gold trophy)
- [ ] Verified different levels show different images

---

## 🎉 Summary

You now have:
- ✅ 4 different achievement badges
- ✅ Automatic image selection based on level
- ✅ Counter-based achievement IDs (KL-HACK-0001, 0002, etc.)
- ✅ Soulbound NFTs
- ✅ Ready for mainnet deployment!

**Total setup time: ~30 minutes**
**Cost on Scroll mainnet: ~$2-5 to deploy**

Ready to mint hackathon achievements! 🚀