// SPDX-License-Identifier: GPL
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract NFTMarketplace {
    using SafeMath for uint256;

    address public owner;
    uint256 public serviceFee; // Fee percentage to be deducted from each sale

    struct Listing {
        address seller;
        address nftContract;
        uint256 tokenId;
        uint256 price;
        bool active;
    }

    mapping(uint256 => Listing) public listings;
    uint256 public listingCounter;

    event ListingCreated(uint256 indexed listingId, address indexed seller, address indexed nftContract, uint256 tokenId, uint256 price);
    event ListingCancelled(uint256 indexed listingId);
    event Sale(uint256 indexed listingId, address indexed seller, address indexed buyer, uint256 price);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
        serviceFee = 1; // 1% service fee
        listingCounter = 0;
    }

    function createListing(address _nftContract, uint256 _tokenId, uint256 _price) external {
        require(_nftContract != address(0), "Invalid NFT contract address");
        require(_price > 0, "Price must be greater than zero");

        IERC721 nft = IERC721(_nftContract);
        require(nft.ownerOf(_tokenId) == msg.sender, "Only NFT owner can create a listing");

        uint256 listingId = listingCounter;
        listings[listingId] = Listing({
            seller: msg.sender,
            nftContract: _nftContract,
            tokenId: _tokenId,
            price: _price,
            active: true
        });

        listingCounter++;

        emit ListingCreated(listingId, msg.sender, _nftContract, _tokenId, _price);
    }

    function cancelListing(uint256 _listingId) external {
        Listing storage listing = listings[_listingId];
        require(listing.active, "Listing is not active");
        require(listing.seller == msg.sender, "Only the seller can cancel the listing");

        listing.active = false;

        emit ListingCancelled(_listingId);
    }

    function buyNFT(uint256 _listingId) external payable {
        Listing storage listing = listings[_listingId];
        require(listing.active, "Listing is not active");
        require(listing.price > 0, "Invalid listing price");
        require(msg.value >= listing.price, "Insufficient payment");

        listing.active = false;

        // Transfer the NFT to the buyer
        IERC721 nft = IERC721(listing.nftContract);
        nft.safeTransferFrom(listing.seller, msg.sender, listing.tokenId);

        // Calculate service fee
        uint256 serviceFeeAmount = listing.price.mul(serviceFee).div(100);

        // Transfer payment to the seller after deducting the service fee
        uint256 sellerAmount = listing.price.sub(serviceFeeAmount);
        payable(listing.seller).transfer(sellerAmount);

        // Transfer service fee to the marketplace owner
        payable(owner).transfer(serviceFeeAmount);

      emit Sale(_listingId, listing.seller, msg.sender, listing.price);
    }

    function setServiceFee(uint256 _fee) external onlyOwner {
        require(_fee >= 0 && _fee <= 100, "Invalid service fee percentage");
        serviceFee = _fee;
    }
}