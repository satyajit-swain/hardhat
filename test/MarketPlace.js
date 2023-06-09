const { expect } = require("chai");
const { ethers } = require("hardhat");
const{time} = require("@nomicfoundation/hardhat-network-helpers");

describe("Market contract", async () => {
  let owner, addr1, addr2;
  let ERC1155, ERC1155Test, ERC721, ERC721Test, Market, MarketTest;
  beforeEach(async () => {
    [owner, addr1, addr2] = await ethers.getSigners();
    ERC1155 = await ethers.getContractFactory("ERC1155Tokens");
    ERC1155Test = await ERC1155.deploy("erc1155T", "E1155");

    ERC721 = await ethers.getContractFactory("ERC721Token");
    ERC721Test = await ERC721.deploy();

    Market = await ethers.getContractFactory("TokenMarketPlace");
    MarketTest = await Market.deploy(ERC721Test.address, ERC1155Test.address);

    it("token type should be only 0 for erc721 and 1 for erc1155", async () => {
      await expect(MarketTest.setOnSale(1, "10", 5, 2)).to.be.revertedWith(
        "TokenMarketPlace: Invalid token type"
      );
    });
  });

  describe("Market deployment", async () => {
    it("deployed contract of erc721 should set properly", async () => {
      expect(await MarketTest.erc721()).to.equal(ERC721Test.address);
    });
    it("deployed contract of erc1155 should set properly", async () => {
      expect(await MarketTest.erc1155()).to.equal(ERC1155Test.address);
    });
  });

  describe("sale setup", async () => {
    it("fail if token price is less than or equals to 0", async () => {
      await expect(MarketTest.setOnSale(1, 0, 3, 0)).to.be.revertedWith(
        "TokenMarketPlace: invalid price"
      );
    });
    it("fail if the owner have an active auction on the same token", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await MarketTest.connect(addr1).createAuction(
        0,
        0,
        1,
        "10",
        1685688636,
        1685775036
      );
      await expect(
        MarketTest.connect(addr1).setOnSale(0, "10", 1, 0)
      ).to.be.revertedWith("TokenMarketPlace: There is a active auction");
    });
    it("fail if the owner have an active sale on the same token", async () => {
      await MarketTest.connect(addr1).mint(1, 0, 10);
      await ERC1155Test.connect(addr1).setApprovalForAll(
        MarketTest.address,
        true
      );
      await MarketTest.connect(addr1).setOnSale(0, "8", 5, 1);
      await expect(
        MarketTest.connect(addr1).setOnSale(0, "10", 3, 1)
      ).to.be.revertedWith("TokenMarketPlace: token already on Sale");
    });

    it("sale of erc721 token", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await MarketTest.connect(addr1).setOnSale(0, "10", 1, 0);
      const saleInfo=await MarketTest.tokenSale(0,0,addr1.address);
      
      expect(await saleInfo.seller).to.equal(addr1.address);
      expect(await saleInfo.isOnSale).to.equal(true);
    });
    it("sale of erc1155 token", async () => {
      await MarketTest.connect(addr1).mint(1, 0, 10);
      await ERC1155Test.connect(addr1).setApprovalForAll(
        MarketTest.address,
        true
      );
      await MarketTest.connect(addr1).setOnSale(0, "10", 10, 1);

      const saleInfo=await MarketTest.tokenSale(1,0,addr1.address);
      
      expect(await saleInfo.seller).to.equal(addr1.address);
      expect(await saleInfo.isOnSale).to.equal(true);
    });
    it("sale event", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await expect(MarketTest.connect(addr1).setOnSale(0, "10", 1, 0))
        .to.be.emit(MarketTest, "SaleSet")
        .withArgs(addr1.address, 0, "10", 1);
    });
  });

  describe("purchase tokens", async () => {
    it("fail is the required token is not on sale", async () => {
      await expect(MarketTest.buy(0, 0, 1, addr1.address)).to.be.revertedWith(
        "TokenMarketPlace: token not on sale"
      );
    });
    it("fail if the seller is trying to purchase tokens", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await MarketTest.connect(addr1).setOnSale(0, "10", 1, 0);
      await expect(
        MarketTest.connect(addr1).buy(0, 0, 1, addr1.address)
      ).to.be.revertedWith("TokenMarketPlace: you are the seller");
    });
    it("purchase value should match the price of erc721 token", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await MarketTest.connect(addr1).setOnSale(0, "10", 1, 0);
      await expect(
        MarketTest.buy(0, 0, 1, addr1.address, { value: "20" })
      ).to.be.revertedWith("TokenMarketPlace: invalid Price");
    });
    it("purchase value should match the price of erc1155 token", async () => {
      await MarketTest.connect(addr1).mint(1, 1, 10);
      await ERC1155Test.connect(addr1).setApprovalForAll(
        MarketTest.address,
        true
      );
      await MarketTest.connect(addr1).setOnSale(1, "10", 10, 1);
      await expect(
        MarketTest.buy(1, 1, 10, addr1.address, { value: "20" })
      ).to.be.revertedWith("TokenMarketPlace: invalid Price");
    });
    it("buying quantity should greater than zero and less than or same as selling quantity", async () => {
      await MarketTest.connect(addr1).mint(1, 1, 10);
      await ERC1155Test.connect(addr1).setApprovalForAll(
        MarketTest.address,
        true
      );
      await MarketTest.connect(addr1).setOnSale(1, "10", 10, 1);
      await expect(
        MarketTest.buy(1, 1, 0, addr1.address, { value: "0" })
      ).to.be.revertedWith("TokenMarketPlace: invalid quantity");

      await expect(
        MarketTest.buy(1, 1, 15, addr1.address, { value: "150" })
      ).to.be.revertedWith("TokenMarketPlace: invalid quantity");
    });

    it("successful purchase of erc721 token", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await MarketTest.connect(addr1).setOnSale(0, "10", 1, 0);
      addr2TBalance = await ERC721Test.balanceOf(addr2.address);
      await MarketTest.connect(addr2).buy(0, 0, 1, addr1.address, {
        value: "10",
      });
      expect(await ERC721Test.balanceOf(addr2.address)).to.equal(
        addr2TBalance + 1
      );
    });

    it("successful purchase of erc1155 token", async () => {
      await MarketTest.connect(addr1).mint(1, 0, 10);

      let addr2TBalance = await ERC1155Test.balanceOf(addr2.address, 1);
      await ERC1155Test.connect(addr1).setApprovalForAll(
        MarketTest.address,
        true
      );
      await MarketTest.connect(addr1).setOnSale(0, 10, 10, 1);
      await MarketTest.connect(addr2).buy(0, 1, 10, addr1.address, {
        value: "100",
      });
      expect(await ERC1155Test.balanceOf(addr2.address, 0)).to.equal(
        addr2TBalance + 10
      );
    });
    it("purchase event", async () => {
      await MarketTest.connect(addr1).mint(1, 0, 10);

      await ERC1155Test.connect(addr1).setApprovalForAll(
        MarketTest.address,
        true
      );
      await MarketTest.connect(addr1).setOnSale(0, 10, 10, 1);
      await expect(
        MarketTest.connect(addr2).buy(0, 1, 10, addr1.address, { value: "100" })
      )
        .to.be.emit(MarketTest, "TokenPurchased")
        .withArgs(addr2.address, 0, 10, addr1.address);
    });
  });

  describe("end sale", async () => {
    it("fail if trying to end the sale that is not started", async () => {
      await expect(MarketTest.stopSale(0, 0)).to.be.revertedWith(
        "TokenMarketPlace: not on sale"
      );
    });
    it("fail if someone other than the seller trying to end sale", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await MarketTest.connect(addr1).setOnSale(0, "10", 1, 0);
      await expect(MarketTest.connect(addr2).stopSale(0, 0)).to.be.revertedWith(
        "TokenMarketPlace: not on sale"
      );
    });
    it("sale ended", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await MarketTest.connect(addr1).setOnSale(0, "10", 1, 0);
      await MarketTest.connect(addr1).stopSale(0, 0);
      const saleInfo=await MarketTest.tokenSale(0,0,addr1.address);
      
      expect(await saleInfo.isOnSale).to.equal(false);
      
    });
    it("end sale event", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await MarketTest.connect(addr1).setOnSale(0, "10", 1, 0);
      await expect(MarketTest.connect(addr1).stopSale(0, 0))
        .to.be.emit(MarketTest, "SaleEnded")
        .withArgs(addr1.address, 0);
    });
  });

  describe("create auction", async () => {
    it("fail if time passed for the auction start", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await expect(
        MarketTest.connect(addr1).createAuction(
          0,
          0,
          1,
          "10",
          1685449853,
          1685507453
        )
      ).to.be.revertedWith("TokenMarketPlace: invalid time");
    });
    it("fail if the start price is less than zero", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await expect(
        MarketTest.connect(addr1).createAuction(
          0,
          0,
          1,
          "0",
          1685688636,
          1685775036
        )
      ).to.be.revertedWith(
        "TokenMarketPlace: starting price must be greater than zero."
      );
    });
    it("fail if there is a active auction on the token", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await MarketTest.connect(addr1).createAuction(
        0,
        0,
        1,
        "1",
        1685688636,
        1685775036
      );
      await expect(
        MarketTest.connect(addr1).createAuction(
          0,
          0,
          1,
          "1",
          1685688636,
          1685775036
        )
      ).to.be.revertedWith("TokenMarketPlace: There is a active auction");
    });
    it("fail if a sale is active in the same token of erc721", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await MarketTest.connect(addr1).setOnSale(0, "10", 1, 0);
      await expect(
        MarketTest.connect(addr1).createAuction(
          0,
          0,
          1,
          "10",
          1685688636,
          1685775036
        )
      ).to.be.revertedWith("TokenMarketPlace: token already on Sale");
    });
    it("fail if someone other than the token owner trying to start auction in erc721", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await expect(
        MarketTest.connect(addr2).createAuction(
          0,
          0,
          1,
          "10",
          1685688636,
          1685775036
        )
      ).to.be.revertedWith(
        "TokenMarketPlace: You must own the token to create an auction"
      );
    });
    it("fail if contract is not approved in erc721", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);

      await expect(
        MarketTest.connect(addr1).createAuction(
          0,
          0,
          1,
          "10",
          1685688636,
          1685775036
        )
      ).to.be.revertedWith("TokenMarketPlace: not approved");
    });

    it("fail if more tokens are in sale than the available balance in erc1155", async () => {
      await MarketTest.connect(addr1).mint(1, 0, 10);
      await ERC1155Test.connect(addr1).setApprovalForAll(
        MarketTest.address,
        true
      );
      await MarketTest.connect(addr1).setOnSale(0, "10", 5, 1);
      await expect(
        MarketTest.connect(addr1).createAuction(
          1,
          0,
          6,
          "10",
          1685688636,
          1685775036
        )
      ).to.be.revertedWith("TokenMarketPlace: unsufficient tokens");
    });
    it("fail if trying to place more tokens in auction than the available balance in erc1155", async () => {
      await MarketTest.connect(addr1).mint(1, 0, 10);
      await ERC1155Test.connect(addr1).setApprovalForAll(
        MarketTest.address,
        true
      );
      await expect(
        MarketTest.connect(addr1).createAuction(
          1,
          0,
          15,
          "10",
          1685688636,
          1685775036
        )
      ).to.be.revertedWith("TokenMarketPlace: Not enough tokens");
    });

    it("fail if the contract is not approved in erc1155", async () => {
      await MarketTest.connect(addr1).mint(1, 0, 10);

      await expect(
        MarketTest.connect(addr1).createAuction(
          1,
          0,
          9,
          "10",
          1685688636,
          1685775036
        )
      ).to.be.revertedWith("TokenMarketPlace: not approved");
    });

    it("Auction created in erc721", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await MarketTest.connect(addr1).createAuction(
        0,
        0,
        1,
        "10",
        1685688636,
        1685775036
      );
      const auctionInfo=await MarketTest.auction(0,0,addr1.address);
      expect(await auctionInfo.seller).to.equal(addr1.address)
      expect(await auctionInfo.activeAuction).to.equal(true);
    });

    it("Auction created in erc1155", async () => {
      await MarketTest.connect(addr1).mint(1, 0, 10);
      await ERC1155Test.connect(addr1).setApprovalForAll(
        MarketTest.address,
        true
      );
      await MarketTest.connect(addr1).createAuction(
        1,
        0,
        10,
        10,
        1685688636,
        1685507453
      );
      const auctionInfo=await MarketTest.auction(1,0,addr1.address);
      expect(await auctionInfo.seller).to.equal(addr1.address)
      expect(await auctionInfo.activeAuction).to.equal(true);

    });

    it("Auction event", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await expect(
        MarketTest.connect(addr1).createAuction(
          0,
          0,
          1,
          "10",
          1685688636,
          1685775036
        )
      )
        .to.be.emit(MarketTest, "AuctionCreated")
        .withArgs(addr1.address, 0, 1,"10", 1685688636, 1685775036);
    });
  });

  describe("Place bid", async () => {
    it("fail is bit placed in an inactive auction", async () => {
      await expect(
        MarketTest.connect(addr1).placeBid(0, 0, addr2.address)
      ).to.be.revertedWith("TokenMarketPlace: Auction is not active");
    });

    it("fail if time is over", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await MarketTest.connect(addr1).createAuction(
        0,
        0,
        1,
        "10",
        1685688636,
        1685463038
      );
      await expect(
        MarketTest.connect(addr2).placeBid(0, 0, addr1.address)
      ).to.be.revertedWith("TokenMarketPlace: Auction has ended");
    });
    it("fail if owner is trying to bid", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await MarketTest.connect(addr1).createAuction(
        0,
        0,
        1,
        "10",
        1685688636,
        1685775036
      );
      await expect(
        MarketTest.connect(addr1).placeBid(0, 0, addr1.address)
      ).to.be.revertedWith("TokenMarketPlace: You cannot bid");
    });
    it("fail if bid amount is less than previous bid", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await MarketTest.connect(addr1).createAuction(
        0,
        0,
        1,
        "10",
        1685688636,
        1685775036
      );
      await MarketTest.connect(addr2).placeBid(0, 0, addr1.address, {
        value: "50",
      });
      await expect(
        MarketTest.placeBid(0, 0, addr1.address, { value: "30" })
      ).to.be.revertedWith(
        "TokenMarketPlace: Bid amount must be higher than the current highest bid"
      );
    });

    it("Bid successful", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await MarketTest.connect(addr1).createAuction(
        0,
        0,
        1,
        "10",
        1685688636,
        1685775036
      );

      await MarketTest.connect(addr2).placeBid(0, 0, addr1.address, {
        value: "50",
      });
    });

    it("Bid event", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await MarketTest.connect(addr1).createAuction(
        0,
        0,
        1,
        "10",
        1685688636,
        1685775036
      );
      await expect(
        MarketTest.connect(addr2).placeBid(0, 0, addr1.address, { value: "50" })
      )
        .to.be.emit(MarketTest, "BidPlaced")
        .withArgs(addr2.address, 0, addr1.address, "50");
    });
  });

  describe("Cancel auction", async () => {
    it("only owner can cancel auction", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await MarketTest.connect(addr1).createAuction(
        0,
        0,
        1,
        "10",
        1685688636,
        1685775036
      );

      await expect(
        MarketTest.connect(addr2).cancelAuction(0, addr1.address, 0)
      ).to.be.revertedWith(
        "TokenMarketPlace: Only the seller can perform this action"
      );
    });

    it("Auction cancelled in erc721", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await MarketTest.connect(addr1).createAuction(
        0,
        0,
        1,
        "10",
        1685688636,
        1685775036
      );

      await MarketTest.connect(addr1).cancelAuction(0, addr1.address, 0);
      expect(await ERC721Test.balanceOf(addr1.address)).to.equal(1);

      const auctionInfo=await MarketTest.auction(0,0,addr1.address);
      
      expect(await auctionInfo.activeAuction).to.equal(false);
    });

    it("Auction cancelled in erc1155", async () => {
      await MarketTest.connect(addr1).mint(1, 0, 10);
      await ERC1155Test.connect(addr1).setApprovalForAll(
        MarketTest.address,
        true
      );
      await MarketTest.connect(addr1).createAuction(
        1,
        0,
        10,
        "10",
        1685688636,
        1685775036
      );
      await MarketTest.connect(addr1).cancelAuction(0, addr1.address, 1)
      const auctionInfo=await MarketTest.auction(1,0,addr1.address);
      
      expect(await auctionInfo.activeAuction).to.equal(false);
      
    });

    it("cancel auction event", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await MarketTest.connect(addr1).createAuction(
        0,
        0,
        1,
        "10",
        1685688636,
        1685775036
      );

      await expect(MarketTest.connect(addr1).cancelAuction(0, addr1.address, 0))
        .to.be.emit(MarketTest, "AuctionEnded")
        .withArgs(addr1.address, 0);
    });
  });

  describe("claim token", async () => {
    it("only highest bidder can claim token", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await MarketTest.connect(addr1).createAuction(
        0,
        0,
        1,
        "10",
        1685688636,
        1685775036
      );

      await MarketTest.connect(addr2).placeBid(0, 0, addr1.address, {
        value: "50",
      });

      await expect(
        MarketTest.claimToken(0, addr1.address, 0)
      ).to.be.revertedWith("TokenMarketPlace: You're not the highest bidder");
    });
    it("fail if auction has not ended", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await MarketTest.connect(addr1).createAuction(
        0,
        0,
        1,
        "10",
        1685688636,
        1685775036
      );

      await MarketTest.connect(addr2).placeBid(0, 0, addr1.address, {
        value: "50",
      });

      await expect(
        MarketTest.connect(addr2).claimToken(0, addr1.address, 0)
      ).to.be.revertedWith("TokenMarketPlace: Auction has not ended yet");
    });
    it("token claimed", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      const latestTime = await time.latest();

      await MarketTest.connect(addr1).createAuction(
        0,
        0,
        1,
        "10",
        latestTime+60,
        latestTime+120
      );

      await MarketTest.connect(addr2).placeBid(0, 0, addr1.address, {
        value: "50",
      });
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await time.increaseTo(latestTime+121);
      await MarketTest.connect(addr2).claimToken(0, addr1.address, 0);
      expect(await ERC721Test.ownerOf(0)).to.equal(addr2.address);
    });
    

  });

  describe("cancel bid", async () => {
    it("fail if someone trying to cancel bid without bidded", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await MarketTest.connect(addr1).createAuction(
        0,
        0,
        1,
        "10",
        1685688636,
        1685775036
      );

      await MarketTest.connect(addr2).placeBid(0, 0, addr1.address, {
        value: "50",
      });
      await expect(
        MarketTest.cancelBid(0, addr1.address, 0)
      ).to.be.revertedWith("TokenMarketPlace: You haven't bid yet");
    });
    it("Bid cancelled", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await MarketTest.connect(addr1).createAuction(
        0,
        0,
        1,
        "10",
        1685688636,
        1685775036
      );

      await MarketTest.connect(addr2).placeBid(0, 0, addr1.address, {
        value: "50",
      });
      
      await MarketTest.connect(addr2).cancelBid(0, addr1.address, 0);
      
    });

    it("cancel bid event ", async () => {
      await MarketTest.connect(addr1).mint(0, 0, 1);
      await ERC721Test.connect(addr1).approve(MarketTest.address, 0);
      await MarketTest.connect(addr1).createAuction(
        0,
        0,
        1,
        "10",
        1685688636,
        1685775036
      );

      await MarketTest.connect(addr2).placeBid(0, 0, addr1.address, {
        value: "50",
      });
      await expect(MarketTest.connect(addr2).cancelBid(0, addr1.address, 0))
        .to.be.emit(MarketTest, "BidCancelation")
        .withArgs(addr2.address, 0, addr1.address);
    });
  });
  describe("mint", async () => {
    it("token must be greater than zero", async () => {
      await expect(MarketTest.mint(0, 0, 0)).to.be.revertedWith(
        "TokenMarketPlace: Tokens cannot be zero"
      );
    });
    it("mint tokens for erc721", async () => {
      const addr1Tbalance = await ERC721Test.balanceOf(addr1.address);
      await MarketTest.connect(addr1).mint(0, 0, 1);
      expect(await ERC721Test.balanceOf(addr1.address)).to.equal(
        addr1Tbalance + 1
      );
    });
    it("mint tokens for erc1155", async () => {
      const addr2Tbalance = await ERC1155Test.balanceOf(addr1.address, 0);
      await MarketTest.connect(addr1).mint(1, 0, 10);
      expect(await ERC1155Test.balanceOf(addr1.address, 0)).to.equal(
        addr2Tbalance + 10
      );
    });
  });
});
