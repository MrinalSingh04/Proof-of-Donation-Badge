// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/// @title Proof-of-Donation Badge 
/// @notice Donors receive NFT badges as proof of their contribution
contract DonationBadge is ERC721, Ownable {
    using Counters for Counters.Counter; 
    using Strings for uint256;

    // tokenId counter
    Counters.Counter private _tokenIds;

    // Track donation details
    struct Donation {
        uint256 amount;
        uint256 timestamp;
        uint256 causeId;
    }

    // Mapping tokenId → Donation details
    mapping(uint256 => Donation) public donations;

    // Mapping donor → all their tokenIds
    mapping(address => uint256[]) public donorBadges;

    // Mapping tokenId → causeId
    mapping(uint256 => uint256) public tokenCause;

    // Event logs
    event DonationMade(
        address indexed donor,
        uint256 amount,
        uint256 causeId,
        uint256 tokenId
    );
    event Withdrawal(address indexed owner, uint256 amount);

    // Base URI for token metadata
    string private _baseTokenURI;

    constructor(
        string memory baseURI
    ) ERC721("ProofOfDonationBadge", "PODB") Ownable(msg.sender) {
        _baseTokenURI = baseURI;
    }

    /// @notice Donate ETH and receive a badge NFT
    function donateToCause(uint256 causeId) external payable returns (uint256) {
        require(msg.value > 0, "Donation must be greater than zero");

        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        // Mint NFT badge
        _safeMint(msg.sender, newTokenId);

        // Store donation data
        donations[newTokenId] = Donation({
            amount: msg.value,
            timestamp: block.timestamp,
            causeId: causeId
        });

        donorBadges[msg.sender].push(newTokenId);
        tokenCause[newTokenId] = causeId;

        emit DonationMade(msg.sender, msg.value, causeId, newTokenId);
        return newTokenId;
    }

    /// @notice Withdraw collected donations (only owner)
    function withdrawDonations() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");

        payable(owner()).transfer(balance);
        emit Withdrawal(owner(), balance);
    }

    /// @notice Get all badge IDs of a donor
    function getBadgesOf(
        address donor
    ) external view returns (uint256[] memory) {
        return donorBadges[donor];
    }

    /// @notice Token URI with cause metadata
    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");

        uint256 causeId = tokenCause[tokenId];
        return
            string(
                abi.encodePacked(
                    _baseTokenURI,
                    causeId.toString(),
                    "/",
                    tokenId.toString(),
                    ".json"
                )
            );
    }

    /// @notice Update base URI
    function setBaseURI(string memory newBaseURI) external onlyOwner {
        _baseTokenURI = newBaseURI;
    }

    /// @dev Internal override for baseURI
    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }
}
