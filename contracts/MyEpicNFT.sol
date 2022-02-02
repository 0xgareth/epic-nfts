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
        _setTokenURI(newItemId, "data:application/json;base64,eyJuYW1lIjoiU2F0b3J1IEdvam8iLCJkZXNjcmlwdGlvbiI6IkEgaGVyby4iLCJpbWFnZSI6ImRhdGE6aW1hZ2Uvc3ZnK3htbDtiYXNlNjQsUEhOMlp5QjRiV3h1Y3owaWFIUjBjRG92TDNkM2R5NTNNeTV2Y21jdk1qQXdNQzl6ZG1jaUlIQnlaWE5sY25abFFYTndaV04wVW1GMGFXODlJbmhOYVc1WlRXbHVJRzFsWlhRaUlIWnBaWGRDYjNnOUlqQWdNQ0F6TlRBZ016VXdJajRLSUNBZ0lEeHpkSGxzWlQ0dVltRnpaU0I3SUdacGJHdzZJSGRvYVhSbE95Qm1iMjUwTFdaaGJXbHNlVG9nYzJWeWFXWTdJR1p2Ym5RdGMybDZaVG9nTVRSd2VEc2dmVHd2YzNSNWJHVStDaUFnSUNBOGNtVmpkQ0IzYVdSMGFEMGlNVEF3SlNJZ2FHVnBaMmgwUFNJeE1EQWxJaUJtYVd4c1BTSmliR0ZqYXlJZ0x6NEtJQ0FnSUR4MFpYaDBJSGc5SWpVd0pTSWdlVDBpTlRBbElpQmpiR0Z6Y3owaVltRnpaU0lnWkc5dGFXNWhiblF0WW1GelpXeHBibVU5SW0xcFpHUnNaU0lnZEdWNGRDMWhibU5vYjNJOUltMXBaR1JzWlNJK1JYQnBZMHh2Y21SSVlXMWlkWEpuWlhJOEwzUmxlSFErQ2p3dmMzWm5QZz09In0=");
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
        // increment counter for next NFT
        _tokenIds.increment();
    }
}