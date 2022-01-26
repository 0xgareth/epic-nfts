// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// import OpenZeppelin contracts
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// inherit imported contract
contract MyEpicNFT is ERC721URIStorage {
    
    // magic from OZ to track token ids
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    // pass name of NFT token + its symbol
    constructor() ERC721 ("SquareNFT", "Square") {
        console.log("This is my NFT contract. Whoa!");
    }

    // hit to mint/get NFT
    function makeAnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();

        // minft nft to sender via msg.sender
        _safeMint(msg.sender, newItemId);
        // set nft data
        _setTokenURI(newItemId, "https://jsonkeeper.com/b/IJY3");
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
        // increment counter for next NFT
        _tokenIds.increment();
    }
}