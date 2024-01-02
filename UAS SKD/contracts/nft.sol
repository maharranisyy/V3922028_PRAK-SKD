// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import { Base64 } from "@openzeppelin/contracts/utils/Base64.sol";


contract EventCertificate is ERC721Enumerable, Ownable {
    uint256 public nextTokenId;

    struct EventDetails {
        string eventName;
        string eventDescription;
        uint256 eventTime;
        address nameHolder;
    }

    string private constant BASE_URI = "https://ibb.co/zZcMbrR";

    mapping(uint256 => EventDetails) public eventDetails;

    constructor() ERC721("EventCertificate", "EC") Ownable(msg.sender) {
        // Mint the first token to the contract creator (deployer)
        _safeMint(msg.sender, 1);

        // Predefine event details for the first token
        eventDetails[1] = EventDetails({
            eventName: "Default Event",
            eventDescription: "This is a default event description",
            eventTime: block.timestamp, // You may need to set a specific timestamp
            nameHolder: msg.sender
        });
    }

    function mintCertificate(address _nameHolder) external onlyOwner {
        uint256 tokenId = nextTokenId++;
        _safeMint(_nameHolder, tokenId);

        // You may set predefined event details based on tokenId
        // Here, we assume that event details are predefined for each tokenId
        // Update the details accordingly based on your requirement

        // For example:
        eventDetails[tokenId] = EventDetails({
            eventName: "Predefined Event",
            eventDescription: "This is a predefined event description",
            eventTime: block.timestamp, // You may need to set a specific timestamp
            nameHolder: _nameHolder
        });
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        EventDetails memory details = eventDetails[tokenId];

        string memory json = string(
            abi.encodePacked(
                '{"name": "', details.eventName,
                '", "description": "', details.eventDescription,
                '", "image": "', BASE_URI, '", "attributes": []}'
            )
        );

        return string(abi.encodePacked("data:application/json;base64,", Base64.encode(bytes(json))));
    }

    function getNFTDetails(uint256 tokenId) external view returns (EventDetails memory) {
        return eventDetails[tokenId];
    }
}