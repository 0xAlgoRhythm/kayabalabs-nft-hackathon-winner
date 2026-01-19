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
**Total setup time: ~30 minutes**
**Cost on Scroll mainnet: ~$2-5 to deploy**

Ready to mint hackathon achievements! 🚀