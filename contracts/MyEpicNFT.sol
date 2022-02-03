// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// import OpenZeppelin contracts
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// inherit imported contract
contract MyEpicNFT is ERC721URIStorage {
    // magic from OZ to track token ids
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    // base SVG code, we only change the string being injected into the SVG image
    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = ["Curious", "Wild", "Crazy", "Illusive", "Obtrsuive", "Unreliable", "Mysterious"];
    string[] secondWords = ["Bright", "Glowing", "Shiny", "Fake", "Hollow", "Empty", "Sweet"];
    string[] thirdWords = ["Naruti", "Shoto", "Goku", "Minato", "Kakashi", "Todoroki", "Airbender"];

    // pass name of NFT token + its symbol
    constructor() ERC721 ("SquareNFT", "SQUARE") {
        console.log("This is my NFT contract. Whoa!");
    }

    // randomly select word from each array for an NFT
    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
        // seed random generator
        uint256 rand = random(string(abi.encodePacked("FIRST WORD",Strings.toString(tokenId))));

        // squash num between 0 and len of array
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    // hit to mint/get NFT
    function makeAnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();

        // randomly grab one word from each of the 3 arrays
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);

        // concatenate + close the svg tags
        string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));
        console.log("\n___________");
        console.log(finalSvg);
        console.log("\n___________");

        // minft nft to sender via msg.sender
        _safeMint(msg.sender, newItemId);
        // set nft data
        _setTokenURI(newItemId, "blah");
        // _setTokenURI(newItemId, "data:application/json;base64,eyJuYW1lIjoiU2F0b3J1IEdvam8iLCJkZXNjcmlwdGlvbiI6IkEgaGVyby4iLCJpbWFnZSI6ImRhdGE6aW1hZ2Uvc3ZnK3htbDtiYXNlNjQsUEhOMlp5QjRiV3h1Y3owaWFIUjBjRG92TDNkM2R5NTNNeTV2Y21jdk1qQXdNQzl6ZG1jaUlIQnlaWE5sY25abFFYTndaV04wVW1GMGFXODlJbmhOYVc1WlRXbHVJRzFsWlhRaUlIWnBaWGRDYjNnOUlqQWdNQ0F6TlRBZ016VXdJajRLSUNBZ0lEeHpkSGxzWlQ0dVltRnpaU0I3SUdacGJHdzZJSGRvYVhSbE95Qm1iMjUwTFdaaGJXbHNlVG9nYzJWeWFXWTdJR1p2Ym5RdGMybDZaVG9nTVRSd2VEc2dmVHd2YzNSNWJHVStDaUFnSUNBOGNtVmpkQ0IzYVdSMGFEMGlNVEF3SlNJZ2FHVnBaMmgwUFNJeE1EQWxJaUJtYVd4c1BTSmliR0ZqYXlJZ0x6NEtJQ0FnSUR4MFpYaDBJSGc5SWpVd0pTSWdlVDBpTlRBbElpQmpiR0Z6Y3owaVltRnpaU0lnWkc5dGFXNWhiblF0WW1GelpXeHBibVU5SW0xcFpHUnNaU0lnZEdWNGRDMWhibU5vYjNJOUltMXBaR1JzWlNJK1JYQnBZMHh2Y21SSVlXMWlkWEpuWlhJOEwzUmxlSFErQ2p3dmMzWm5QZz09In0=");
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
        // increment counter for next NFT
        _tokenIds.increment();
    }
}