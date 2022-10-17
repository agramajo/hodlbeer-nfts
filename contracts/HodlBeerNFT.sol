// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract HodlBeerNFT is ERC721URIStorage, Ownable {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  uint256 public MAX_TOKENS = 6000;
  uint256 public CURRENT_PRICE = 0.01 ether;
  string public BASE_URI = "https://hodlbeer.nft.baicom.com/api/card/";

  event NewNFTMinted(address sender, uint256 tokenId);

  constructor() ERC721 ("HodlBeerClub", "HODLB") {
  }

  function makeNFT() public payable {
    uint256 newItemId = _tokenIds.current();

    require(CURRENT_PRICE <= msg.value, "Value sent is not correct");
    require(newItemId < MAX_TOKENS,"Max supply of NFT");

    _safeMint(msg.sender, newItemId);
    _tokenIds.increment();

    emit NewNFTMinted(msg.sender, newItemId);
  }

  function reserveNFT(uint count) public onlyOwner {
    for (uint i = 1; i <= count; i++) {
      uint256 newItemId = _tokenIds.current();

      require(newItemId < MAX_TOKENS,"Max supply of NFT");

      _safeMint(msg.sender, newItemId);
      _tokenIds.increment();

      emit NewNFTMinted(msg.sender, newItemId);
    }
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

  function setCurrentPrice(uint256 currentPrice) public onlyOwner {
    CURRENT_PRICE = currentPrice;
  }

  function contractURI() public view returns (string memory) {
    return BASE_URI;
  }
}
