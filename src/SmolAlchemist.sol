// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "./Material.sol";

// Alchemist is an ERC-721 contract representing the player
// An alchemist can have multiple materials
// An alchemist can combine multiple materials into new ones
// An alchemist can go on a quest to gather new materials (at random)

contract SmolAlchemist is
    ERC721("SmolAlchemist", "SMAL"),
    ERC1155Holder,
    Ownable
{
    struct Recipe {
        string name;
        mapping(Material => uint256) materialsRequired; // Example: Metal: 52, Gold: 60
        uint256 delay; // The amount of time it will take to concoct this recipe
    }

    address lilMatterContract;
    address crafterMatterContract;
    address burnAddress = 0x000000000000000000000000000000000000dEaD;
    mapping(uint256 => mapping(Material => uint256))
        private materialsOwnedByAlchemist;
    Recipe[] private recipes;

    function setLilMatterContract(address _lilMatterContract)
        external
        onlyOwner
    {
        lilMatterContract = _lilMatterContract;
    }

    function setCraftedMatterContract(address _crafterMatterContract)
        external
        onlyOwner
    {
        crafterMatterContract = _crafterMatterContract;
    }

    function addRecipe(
        string memory _name,
        uint256[] memory _materials,
        uint256[] memory _materialAmounts,
        uint256 _delay
    ) external onlyOwner {}

    function recipe(uint256 _recipeId) public view returns (string memory) {}

    // An alchemist can go on a quest to obtain lil matter
    // Or recipe
    // for transmutation purpose
    function goOnAQuest(uint256 alchemistId) public {}

    function transmute(uint256 alchemistId) public {}

    ////////////////////////////// HELPERS
    function bytesToUint(bytes memory data) internal pure returns (uint256) {
        require(data.length == 32, "slicing out of range");
        uint256 x;
        assembly {
            x := mload(add(data, 0x20))
        }
        return x;
    }

    ////////////////////////////// OVERRIDES
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721, ERC1155Receiver)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes memory data
    ) public override returns (bytes4) {
        uint256 alchemistId = bytesToUint(data);
        Material material = Material(id);
        materialsOwnedByAlchemist[alchemistId][material] += value;
        return
            bytes4(
                keccak256(
                    "onERC1155Received(address,address,uint256,uint256,bytes)"
                )
            );
    }
}
