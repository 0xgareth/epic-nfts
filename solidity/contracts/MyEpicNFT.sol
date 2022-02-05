// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// import OpenZeppelin contracts
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// import helper func for converting to base64
import { Base64 } from "./libraries/Base64.sol";

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
        string memory combined = string(abi.encodePacked(first, second, third));

        // concatenate + close the svg tags
        string memory finalSvg = string(abi.encodePacked(baseSvg, combined, "</text></svg>"));

        // get JSON data and encode in base64
        string memory json = Base64.encode(abi.encodePacked(
            '{"name": "',
            // We set the title of our NFT as the generated word.
            combined,
            '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
            // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
            Base64.encode(bytes(finalSvg)),
            '"}'
        ));

        // prepend data:application/json;base64, to our data
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n___________");
        console.log(
            string(
                abi.encodePacked(
                    "https://nftpreview.0xdev.codes/?code=",
                    finalTokenUri
            )
        ));
        console.log("\n___________");

        // minft nft to sender via msg.sender
        _safeMint(msg.sender, newItemId);
        // set nft data
        _setTokenURI(newItemId, finalTokenUri);
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
        // increment counter for next NFT
        _tokenIds.increment();
    }
}