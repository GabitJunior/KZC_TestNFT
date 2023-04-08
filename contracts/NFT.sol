// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract NFT is ERC721Enumerable, Ownable {
    using Strings for uint256;

    //1000 NFT done
    //pay ETH to mint NFT done
    //unique metadata for each NFT

    uint256 maxSupply = 10;
    uint256 cost = 0.001 ether; //0.001 BNB
    string baseURI = "ipfs://QmbuFxymcSsQvx3AoGVE1hMaW5mPSoM9SAefBXDYVqjzQr/"; 

    //NFT storage

    //on chain => svg => base64
    //central server (cloudinary, file storage, firestore, github)
    //IPFS (decentralized file storage), arweave.

    constructor() ERC721("KZCash_NFT02", "NFT") {}

    //ON-CHAIN DATA
    //EVENT

    function _baseURI() internal view override returns (string memory) {
        return baseURI;

        //
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        _requireMinted(tokenId);
        //string memory baseURI = _baseURI();
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
                : "";
    }

    function changeBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function safeMint(address _to) public payable {
        uint256 _currentSupply = totalSupply();
        require(_currentSupply < maxSupply, "You reached max supply");
        require(msg.value == cost, "Please add valid amount of ETH");
        _safeMint(_to, _currentSupply);
    }

    function withdraw() public onlyOwner {
        //
        //payable(msg.sender).transfer(address(this).balance);
        //(bool os, ) = payable(owner()).call{value: address(this).balance}(""); require(os);
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success);
    }
}