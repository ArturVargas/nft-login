//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract SpecialNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter; // Contador que solo incrementa o decrementa en 1
    Counters.Counter private _tokenIds;
    uint256 TOTAL_SUPPLY = 1559; // solo se podra mintear esta cantidad de nfts
    uint256 public constant MINT_PRICE = 5e17; // precio de minteo 0.5

    constructor() ERC721("SpecialNFT", "RektSol"){ } // Nombre y Simbolo de la coleccion

    function mintSpecialNFT(string memory tokenURI) external payable returns(uint256) {
        _tokenIds.increment();
        // Revisa que el contador no sea mayor al total supply
        require(_tokenIds.current() <= TOTAL_SUPPLY, "No more Special NFT's available to mint");
        // El precio de minteo sera de 0.5 
        require(msg.value == MINT_PRICE, "Send the correct amount");
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    function withdraw() external payable onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Not founds to withdraw");
        (bool success, ) = (msg.sender).call{value: balance}("");
        require(success, "Transfer failed.");
    }
    
    // Todo: reserve nft's for the team
}
