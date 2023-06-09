// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "../ERC721/ERC721Token.sol";
import "./ERC1155Tokens.sol";
import "./ITokenMarketPlace.sol";

contract TokenMarketPlace is ITokenMarketPlace {
    address public erc1155;
    address public erc721;

    mapping(uint256 => mapping(uint256 => mapping(address => TokenOnSale)))
        public tokenSale;

    mapping(uint256 => mapping(uint256 => mapping(address => Auction)))
        public auction;
    mapping(uint256 => mapping(uint256 => mapping(address => Bidders[])))
        private bidder;
    mapping(uint256 => mapping(address => mapping(address => uint256)))
        private bidderAmounts;

    constructor(address _erc721, address _erc1155) {
        erc721 = _erc721;
        erc1155 = _erc1155;
    }

    function _checkToken(uint256 _tokenType) private pure {
        require(
            _tokenType == 0 || _tokenType == 1,
            "TokenMarketPlace: Invalid token type"
        );
    }

    function mint(
        uint256 _tokenType,
        uint256 _tokenId,
        uint256 _quantity
    ) external {
        _checkToken(_tokenType);
        require(_quantity > 0, "TokenMarketPlace: Tokens cannot be zero");
        if (_tokenType == 0) {
            _quantity = 1;
            ERC721Token(erc721).mint(msg.sender);
            _tokenId = ERC721Token(erc721).nextTokenIDMint() - 1;
        } else {
            IERC1155Token(erc1155).mint(msg.sender, _tokenId, _quantity);
        }
    }

    function setOnSale(
        uint256 _tokenId,
        uint256 _tokenPrice,
        uint256 _quantity,
        uint256 _tokenType
    ) external {
        _checkToken(_tokenType);
        require(_tokenPrice > 0, "TokenMarketPlace: invalid price");
        require(
            !auction[_tokenType][_tokenId][msg.sender].activeAuction,
            "TokenMarketPlace: There is a active auction"
        );
        require(
            !tokenSale[_tokenType][_tokenId][msg.sender].isOnSale,
            "TokenMarketPlace: token already on Sale"
        );
        if (_tokenType == 0) {
            _quantity = 1;
            require(
                ERC721Token(erc721).ownerOf(_tokenId) == msg.sender,
                "TokenMarketPlace: not token owner"
            );

            require(
                ERC721Token(erc721).getApproved(_tokenId) == address(this) ||
                    ERC721Token(erc721).isApprovedForAll(
                        msg.sender,
                        address(this)
                    ),
                "TokenMarketPlace: not approved"
            );
        } else {
            require(_quantity > 0, "TokenMarketPlace: invalid quantity");

            require(
                IERC1155Token(erc1155).isApprovedForAll(
                    msg.sender,
                    address(this)
                ),
                "TokenMarketPlace: not approved"
            );
        }
        tokenSale[_tokenType][_tokenId][msg.sender].tokenPrice = _tokenPrice;
        tokenSale[_tokenType][_tokenId][msg.sender].quantity += _quantity;
        tokenSale[_tokenType][_tokenId][msg.sender].seller = msg.sender;
        tokenSale[_tokenType][_tokenId][msg.sender].isOnSale = true;
        tokenSale[_tokenType][_tokenId][msg.sender].tokenType = _tokenType;
        emit SaleSet(msg.sender, _tokenId, _tokenPrice, _quantity);
    }

    function buy(
        uint256 _tokenId,
        uint256 _tokenType,
        uint256 _quantity,
        address _sellerAddress
    ) external payable {
        _checkToken(_tokenType);
        require(
            tokenSale[_tokenType][_tokenId][_sellerAddress].isOnSale,
            "TokenMarketPlace: token not on sale"
        );
        require(
            msg.sender !=
                tokenSale[_tokenType][_tokenId][_sellerAddress].seller,
            "TokenMarketPlace: you are the seller"
        );
        if (_tokenType == 0) {
            _quantity = 1;
            require(
                tokenSale[_tokenType][_tokenId][_sellerAddress].tokenPrice ==
                    msg.value,
                "TokenMarketPlace: invalid Price"
            );
            ERC721Token(erc721).transferFrom(
                _sellerAddress,
                msg.sender,
                _tokenId
            );
        } else {
            require(
                _quantity > 0 &&
                    _quantity <=
                    tokenSale[_tokenType][_tokenId][_sellerAddress].quantity,
                "TokenMarketPlace: invalid quantity"
            );
            require(
                msg.value ==
                    _quantity *
                        tokenSale[_tokenType][_tokenId][_sellerAddress]
                            .tokenPrice,
                "TokenMarketPlace: invalid Price"
            );
            IERC1155Token(erc1155).safeTransferFrom(
                tokenSale[_tokenType][_tokenId][_sellerAddress].seller,
                msg.sender,
                _tokenId,
                _quantity,
                bytes("Purchased")
            );
        }
        tokenSale[_tokenType][_tokenId][_sellerAddress].quantity -= _quantity;

        if (tokenSale[_tokenType][_tokenId][_sellerAddress].quantity == 0) {
            delete tokenSale[_tokenType][_tokenId][_sellerAddress];
        }

        emit TokenPurchased(msg.sender, _tokenId, _quantity, _sellerAddress);
    }

    function stopSale(uint256 _tokenId, uint256 _tokenType) external {
        _checkToken(_tokenType);
        require(
            tokenSale[_tokenType][_tokenId][msg.sender].isOnSale,
            "TokenMarketPlace: not on sale"
        );
        require(
            tokenSale[_tokenType][_tokenId][msg.sender].seller == msg.sender,
            "TokenMarketPlace: you're not the seller"
        );
        delete tokenSale[_tokenType][_tokenId][msg.sender];
        emit SaleEnded(msg.sender, _tokenId);
    }

    function createAuction(
        uint256 _tokenType,
        uint256 _tokenId,
        uint256 _quantity,
        uint256 _startPrice,
        uint256 _startTime,
        uint256 _endTime
    ) external {
        _checkToken(_tokenType);

        require(
            _startTime > block.timestamp || _startTime == 0,
            "TokenMarketPlace: invalid time"
        );

        require(
            _startPrice > 0,
            "TokenMarketPlace: starting price must be greater than zero."
        );

        require(
            !auction[_tokenType][_tokenId][msg.sender].activeAuction,
            "TokenMarketPlace: There is a active auction"
        );

        if (_startTime == 0) {
            _startTime = block.timestamp;
        }

        if (_tokenType == 0) {
            _quantity = 1;
            require(
                !tokenSale[_tokenType][_tokenId][msg.sender].isOnSale,
                "TokenMarketPlace: token already on Sale"
            );
            require(
                ERC721Token(erc721).ownerOf(_tokenId) == msg.sender,
                "TokenMarketPlace: You must own the token to create an auction"
            );

            require(
                ERC721Token(erc721).getApproved(_tokenId) == address(this) ||
                    ERC721Token(erc721).isApprovedForAll(
                        msg.sender,
                        address(this)
                    ),
                "TokenMarketPlace: not approved"
            );
        } else {
            if (tokenSale[_tokenType][_tokenId][msg.sender].quantity > 0) {
                require(
                    _quantity <=
                        IERC1155Token(erc1155).balanceOf(msg.sender, _tokenId) -
                            tokenSale[_tokenType][_tokenId][msg.sender]
                                .quantity,
                    "TokenMarketPlace: unsufficient tokens"
                );
            }
            require(
                _quantity <=
                    IERC1155Token(erc1155).balanceOf(msg.sender, _tokenId),
                "TokenMarketPlace: Not enough tokens"
            );

            require(
                IERC1155Token(erc1155).isApprovedForAll(
                    msg.sender,
                    address(this)
                ),
                "TokenMarketPlace: not approved"
            );
        }

        auction[_tokenType][_tokenId][msg.sender] = Auction({
            seller: msg.sender,
            tokenId: _tokenId,
            quantity: _quantity,
            startPrice: _startPrice,
            startTime: _startTime,
            endTime: _endTime,
            activeAuction: true,
            highestBidder: address(0),
            highestBid: 0
        });

        emit AuctionCreated(
            msg.sender,
            _tokenId,
            _quantity,
            _startPrice,
            _startTime,
            _endTime
        );
    }

    function placeBid(
        uint256 _tokenId,
        uint256 _tokenType,
        address _tokenSeller
    ) external payable {
        _checkToken(_tokenType);
        require(
            auction[_tokenType][_tokenId][_tokenSeller].activeAuction,
            "TokenMarketPlace: Auction is not active"
        );
        require(
            block.timestamp <
                auction[_tokenType][_tokenId][_tokenSeller].endTime,
            "TokenMarketPlace: Auction has ended"
        );
        require(
            msg.sender != auction[_tokenType][_tokenId][_tokenSeller].seller,
            "TokenMarketPlace: You cannot bid"
        );
        require(
            msg.value > auction[_tokenType][_tokenId][_tokenSeller].highestBid,
            "TokenMarketPlace: Bid amount must be higher than the current highest bid"
        );

        bidder[_tokenType][_tokenId][_tokenSeller].push(
            Bidders(msg.sender, msg.value)
        );
        bidderAmounts[_tokenType][_tokenSeller][msg.sender] += msg.value;
        auction[_tokenType][_tokenId][_tokenSeller].highestBidder = msg.sender;
        auction[_tokenType][_tokenId][_tokenSeller].highestBid = msg.value;

        emit BidPlaced(msg.sender, _tokenId, _tokenSeller, msg.value);
    }

    function cancelAuction(
        uint256 _tokenId,
        address _tokenSeller,
        uint256 _tokenType
    ) external {
        _checkToken(_tokenType);
        require(
            msg.sender == auction[_tokenType][_tokenId][_tokenSeller].seller,
            "TokenMarketPlace: Only the seller can perform this action"
        );
        require(
            auction[_tokenType][_tokenId][_tokenSeller].activeAuction,
            "TokenMarketPlace: Auction is not active"
        );

        auction[_tokenType][_tokenId][_tokenSeller].activeAuction = false;

        for (
            uint256 index = 0;
            index < bidder[_tokenType][_tokenId][_tokenSeller].length;
            index++
        ) {
            payable(
                bidder[_tokenType][_tokenId][_tokenSeller][index].bidderAddr
            ).transfer(
                    bidder[_tokenType][_tokenId][_tokenSeller][index].priceBid
                );
        }

        delete auction[_tokenType][_tokenId][_tokenSeller];

        emit AuctionEnded(_tokenSeller, _tokenId);
    }

    function claimToken(
        uint256 _tokenId,
        address _tokenSeller,
        uint256 _tokenType
    ) external {
        _checkToken(_tokenType);
        require(
            msg.sender ==
                auction[_tokenType][_tokenId][_tokenSeller].highestBidder,
            "TokenMarketPlace: You're not the highest bidder"
        );

        require(
            block.timestamp >=
                auction[_tokenType][_tokenId][_tokenSeller].endTime,
            "TokenMarketPlace: Auction has not ended yet"
        );

        if (_tokenType == 0) {
            ERC721Token(erc721).transferFrom(
                _tokenSeller,
                msg.sender,
                _tokenId
            );
        } else {
            IERC1155Token(erc1155).safeTransferFrom(
                _tokenSeller,
                msg.sender,
                _tokenId,
                auction[_tokenType][_tokenId][_tokenSeller].quantity,
                "tokens transferd"
            );
        }

        payable(_tokenSeller).transfer(
            auction[_tokenType][_tokenId][_tokenSeller].highestBid
        );

        for (
            uint256 index = 0;
            index < bidder[_tokenType][_tokenId][_tokenSeller].length;
            index++
        ) {
            if (
                bidder[_tokenType][_tokenId][_tokenSeller][index].bidderAddr !=
                msg.sender
            ) {
                payable(
                    bidder[_tokenType][_tokenId][_tokenSeller][index].bidderAddr
                ).transfer(
                        bidder[_tokenType][_tokenId][_tokenSeller][index]
                            .priceBid
                    );
            }
        }
        delete auction[_tokenType][_tokenId][_tokenSeller];

        emit TokenClaimed(
            msg.sender,
            _tokenId,
            _tokenSeller,
            auction[_tokenType][_tokenId][_tokenSeller].highestBid
        );
    }

    function cancelBid(
        uint256 _tokenId,
        address _tokenSeller,
        uint256 _tokenType
    ) external {
        _checkToken(_tokenType);

        require(
            bidderAmounts[_tokenType][_tokenSeller][msg.sender] > 0,
            "TokenMarketPlace: You haven't bid yet"
        );
        payable(msg.sender).transfer(
            bidderAmounts[_tokenType][_tokenSeller][msg.sender]
        );

        for (
            uint256 index = 0;
            index < bidder[_tokenType][_tokenId][_tokenSeller].length;
            index++
        ) {
            if (
                msg.sender ==
                bidder[_tokenType][_tokenId][_tokenSeller][index].bidderAddr
            ) {
                for (
                    uint256 indexs = 0;
                    indexs <
                    bidder[_tokenType][_tokenId][_tokenSeller].length - 1;
                    indexs++
                ) {
                    bidder[_tokenType][_tokenId][_tokenSeller][indexs] = bidder[
                        _tokenType
                    ][_tokenId][_tokenSeller][indexs + 1];
                }
                bidder[_tokenType][_tokenId][_tokenSeller].pop();
            }
        }

        emit BidCancelation(msg.sender, _tokenId, _tokenSeller);
    }
}
