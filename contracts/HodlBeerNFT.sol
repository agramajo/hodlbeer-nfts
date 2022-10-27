// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract HodlBeerNFT is ERC721URIStorage, Ownable {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  mapping(bytes => bool) public signatureUsed;
  address public SIGNER;

  string public PROVENANCE = "";
  uint256 public MAX_TOKENS = 6000;
  uint256 public CURRENT_PRICE_1 = 0.02 ether;
  uint256 public CURRENT_PRICE_2 = 0.01 ether;
  string public BASE_URI = "https://hodlbeer.nft.baicom.com/api/card/";

  event NewNFTMinted(address indexed sender, uint256 tokenId, string message);

  constructor() ERC721 ("HodlBeerClub", "HODLB") {
      SIGNER = owner();
  }

  function makeNFT(string memory _message) public payable {
    uint256 newItemId = _tokenIds.current();

    require(CURRENT_PRICE_1 <= msg.value, "Value sent is not correct");
    require(newItemId < MAX_TOKENS,"Max supply of NFT");

    _safeMint(msg.sender, newItemId);
    _tokenIds.increment();

    emit NewNFTMinted(msg.sender, newItemId, _message);
  }

  function signNFT(bytes32 hash, bytes memory signature) public payable {
    uint256 newItemId = _tokenIds.current();

    require(CURRENT_PRICE_2 <= msg.value, "Value sent is not correct");
    require(newItemId < MAX_TOKENS,"Max supply of NFT");
    require(recoverSigner(hash, signature) == SIGNER, "Address not allow");
    require(!signatureUsed[signature], "Signature has already been used.");

    _safeMint(msg.sender, newItemId);
    _tokenIds.increment();

    signatureUsed[signature] = true;

    emit NewNFTMinted(msg.sender, newItemId, 'sign');
  }

  function reserveNFT(uint count) public onlyOwner {
    for (uint i = 1; i <= count; i++) {
      uint256 newItemId = _tokenIds.current();

      require(newItemId < MAX_TOKENS,"Max supply of NFT");

      _safeMint(msg.sender, newItemId);
      _tokenIds.increment();

      emit NewNFTMinted(msg.sender, newItemId, 'reserve');
    }
  }

  function recoverSigner(bytes32 hash, bytes memory signature) public pure returns (address) {
    bytes32 messageDigest = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    return ECDSA.recover(messageDigest, signature);
  }

  function totalSupply() view public returns (uint) {
    return _tokenIds.current();
  }

  function withdraw() public onlyOwner {
    payable(msg.sender).transfer(address(this).balance);
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return BASE_URI;
  }

  function setBaseURI(string memory BaseURI) public onlyOwner {
    BASE_URI = BaseURI;
  }

  function setCurrentPrice1(uint256 currentPrice) public onlyOwner {
    CURRENT_PRICE_1 = currentPrice;
  }

  function setCurrentPrice2(uint256 currentPrice) public onlyOwner {
    CURRENT_PRICE_2 = currentPrice;
  }

  function setSigner(address _signer) public onlyOwner {
    SIGNER = _signer;
  }
}
