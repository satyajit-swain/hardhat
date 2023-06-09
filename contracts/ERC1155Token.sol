// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract ERC1155Token is ERC1155 {
    string private _uri;
    uint256 public mintAmount;
    address public owner;

    mapping(uint256 => address) private idOwner;

    constructor(string memory uri, uint256 _mintAmount) ERC1155(uri) {
        _uri = uri;
        mintAmount = _mintAmount;
        owner = msg.sender;
    }

    function mint(uint256 tokenId, uint256 numberOfTokens) external payable {
        require(numberOfTokens != 0, "ERC1155Token: Tokens cannot be zero");
        require(
            idOwner[tokenId] == msg.sender || idOwner[tokenId] == address(0),
            "ERC1155Token: token id doesn't match"
        );
        require(
            msg.value == mintAmount * numberOfTokens,
            "ERC1155Token: pay correct amount"
        );
        if (idOwner[tokenId] == address(0)) idOwner[tokenId] = msg.sender;

        _mint(msg.sender, tokenId, numberOfTokens, "");
        payable(owner).transfer(msg.value);
    }

    function mintBatch(
        uint256[] memory tokenIds,
        uint256[] memory numberOfTokens
    ) external payable {
        uint256 numberOfToken1;
        for (uint256 index; index < numberOfTokens.length; index++) {
            numberOfToken1 += numberOfTokens[index];

            require(
                idOwner[tokenIds[index]] == msg.sender ||
                    idOwner[tokenIds[index]] == address(0),
                "ERC1155Token: token id doesn't match"
            );
            if (idOwner[tokenIds[index]] == address(0)) {
                idOwner[tokenIds[index]] = msg.sender;
            }
        }
        require(
            msg.value == mintAmount * numberOfToken1,
            "ERC1155Token: pay correct amount"
        );
        _mintBatch(msg.sender, tokenIds, numberOfTokens, "");
        payable(owner).transfer(msg.value);
    }

    function burn(uint256 tokenId, uint256 numberOfTokens) external {
        require(numberOfTokens != 0, "ERC1155Token: Tokens cannot be zero");
        _burn(msg.sender, tokenId, numberOfTokens);
    }

    function burnBatch(
        uint256[] memory tokenIds,
        uint256[] memory numberOfTokens
    ) external {
        _burnBatch(msg.sender, tokenIds, numberOfTokens);
    }
}
