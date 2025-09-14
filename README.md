# Proof-of-Donation Badge 🎖️

## What is this?

This project is a **Proof-of-Donation Badge** system built as an ERC721 NFT smart contract.

- Each time someone donates ETH to a cause, they receive a **unique NFT badge**. 
- Each badge stores **donation amount, timestamp, and cause ID** on-chain.     
- Metadata (via `baseURI`) allows linking to JSON files that display donation details or badge artwork.  
  
### Key Features
 
- **NFT Minting:** Every donation generates a unique NFT badge.
- **On-Chain Donation Record:** Each NFT stores donation details including amount and timestamp.
- **Cause-Based Metadata:** Metadata is organized per cause (e.g., `baseURI/causeId/tokenId.json`).
- **Withdrawal Function:** Contract owner can withdraw collected ETH donations.
- **Transparent & Trustless:** Donors get verifiable NFTs, no central authority needed.

---

## Why build this?

Charity and donation systems often suffer from **lack of recognition and transparency**. This contract solves that:

1. ✅ **Recognition:** Donors receive unique NFT badges for each donation.
2. ✅ **Transparency:** Donations are verifiable on-chain.
3. ✅ **Gamification:** Each badge can represent a cause or achievement level.
4. ✅ **Trust:** Charities can showcase verified supporters without managing manual records.

**In short:**

- Donors get recognition.
- Charities get verifiable proof of support.
- Communities get a transparent donation record.

---

## Tech Stack

- **Solidity** – Smart contract language.
- **OpenZeppelin Contracts** – Secure implementation of ERC721 standard.

---
