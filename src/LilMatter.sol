// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "hardhat/console.sol";
import "./Material.sol";

contract LilMatter is ERC1155, Ownable {
    address questContract;

    // TODO: Create an API to return this value
    constructor() ERC1155("https://game.example/api/item/{id}.json") {
        // _mint(msg.sender, uint256(Material.Metal), 2000, "");
        // MINT all necessary materials to sender
    }

    function setQuestContract(address _questContract) external {
        questContract = _questContract;
    }

    // This should only be called by Quest contract
    function requestQuestReward(address to) public {
        require(
            questContract == _msgSender(),
            "Only quest contract can request reward"
        );

        uint256 metalMaterialId = uint256(Material.Metal);
        _mint(to, metalMaterialId, unsafeRand(metalMaterialId), "");
    }

    function name() public pure returns (string memory) {
        return "LilMatter";
    }

    function symbol() public pure returns (string memory) {
        return "LILM";
    }

    // HELPERS
    function unsafeRand(uint256 materialId) private view returns (uint256) {
        uint256 seed = uint256(
            keccak256(
                abi.encodePacked(
                    block.timestamp +
                        block.difficulty +
                        ((
                            uint256(keccak256(abi.encodePacked(block.coinbase)))
                        ) / (now)) +
                        block.gaslimit +
                        ((uint256(keccak256(abi.encodePacked(materialId)))) /
                            (now)) +
                        block.number
                )
            )
        );

        console.log("RANDO");
        console.log(seed);
        uint256 randValue = (seed - ((seed / 1000) * 100));
        console.log(randValue);

        return randValue;
    }
}
