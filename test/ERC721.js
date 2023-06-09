const { expect } = require("chai");

describe("ERC721Test contract", function () {
  let ERC721Test;
  let addr1, addr2, owner;

  beforeEach(async function () {
    ERC721Test = await ethers.getContractFactory("ERC721Token");
    ERC721Test = await ERC721Test.deploy();
    [owner, addr1, addr2] = await ethers.getSigners();
  });

  describe("Deployment", async function () {
    it("Deployer should be the owner", async function () {
      expect(await ERC721Test.contractOwner()).to.equal(owner.address);
    });
  });

  describe("Balance", async function () {
    it("address should not be zero address", async function () {
      await expect(
        ERC721Test.balanceOf("0x0000000000000000000000000000000000000000")
      ).to.be.revertedWith("ERC721Token: invalid address");
    });
  });

  describe("Mint", async function () {
    it("owner cannot be zero address", async function () {
      await expect(
        ERC721Test.mint("0x0000000000000000000000000000000000000000")
      ).to.be.revertedWith("ERC721Token: invalid address");
    });

    it("token id should be updated", async function () {
      const ownerTokenId = await ERC721Test.nextTokenIDMint();
      await ERC721Test.mint(owner.address);
      expect(await ERC721Test.nextTokenIDMint()).to.equal(ownerTokenId + 1);
    });

    it("Mint token to the account of owner", async function () {
      const ownerBalance = await ERC721Test.balanceOf(owner.address);
      await ERC721Test.mint(owner.address);
      expect(await ERC721Test.balanceOf(owner.address)).to.equal(
        ownerBalance + 1
      );
    });

    it("mint event", async function () {
      const tokenMint = await ERC721Test.mint(owner.address);
      const tokenId = await ERC721Test.nextTokenIDMint();

      expect(tokenMint)
        .to.emit(ERC721Test, "Transfer")
        .withArgs(
          "0x0000000000000000000000000000000000000000",
          owner.address,
          tokenId
        );
    });
  });

  describe("Burn tokens", async function () {
    it("only owner can burn tokens", async function () {
      await ERC721Test.mint(owner.address);
      await expect(ERC721Test.connect(addr1).burn(0)).to.be.revertedWith(
        "ERC721Token: You're not the token owner"
      );
    });

    it("burn tokens from the token owner's account", async function () {
      await ERC721Test.mint(owner.address);
      const tokenId = await ERC721Test.nextTokenIDMint();
      await ERC721Test.burn(0);
      expect(await ERC721Test.nextTokenIDMint()).to.equal(tokenId - 1);
    });

    it("burn event", async function () {
      await ERC721Test.mint(owner.address);
      await expect(ERC721Test.burn(0))
        .to.be.emit(ERC721Test, "Transfer")
        .withArgs(
          owner.address,
          "0x0000000000000000000000000000000000000000",
          0
        );
    });
  });

  describe("approve and allowance", async function () {
    it("sender must be the token owner", async function () {
      await ERC721Test.mint(owner.address);
      await expect(
        ERC721Test.connect(addr1).approve(addr2.address, 0)
      ).to.be.revertedWith("ERC721Token: token owner doesn't match");
    });

    it("tokens approved", async function () {
      await ERC721Test.mint(owner.address);
      await ERC721Test.approve(addr1.address, 0);

      expect(await ERC721Test.getApproved(0)).to.equal(addr1.address);
    });

    it("approve event", async function () {
      await ERC721Test.mint(owner.address);

      expect(await ERC721Test.approve(addr1.address, 0))
        .to.emit(ERC721Test, "Approval")
        .withArgs(owner.address, addr1.address, 0);
    });

    it("all token approval", async function () {
      await ERC721Test.mint(owner.address);
      await ERC721Test.mint(owner.address);
      await ERC721Test.setApprovalForAll(addr1.address, true);
      expect(
        await ERC721Test.isApprovedForAll(owner.address, addr1.address)
      ).to.equal(true);
    });

    it("Approval for all event", async function () {
      await ERC721Test.mint(owner.address);
      await ERC721Test.mint(owner.address);
      expect(await ERC721Test.setApprovalForAll(addr1.address, true))
        .to.be.emit(ERC721Test, "ApprovalForAll")
        .withArgs(owner.address, addr1.address, true);
    });
  });

  describe("Transaction ", async function () {
    it("fail if sender is not approved", async function () {
      await ERC721Test.mint(owner.address);
      await expect(
        ERC721Test.connect(addr1).transferFrom(owner.address, addr2.address, 0)
      ).to.be.revertedWith("ERC721Token: token owner doesn't match");
    });
    it("sender must be the token owner", async function () {
      await ERC721Test.mint(owner.address);
      await ERC721Test.approve(addr1.address, 0);
      await expect(
        ERC721Test.connect(addr1).transferFrom(addr1.address, addr2.address, 0)
      ).to.be.revertedWith("ERC721Token: token owner doesn't match");
    });

    it("recepient cannot be zero address", async function () {
      await ERC721Test.mint(owner.address);
      await ERC721Test.approve(addr1.address, 0);

      await expect(
        ERC721Test.connect(addr1).transferFrom(
          owner.address,
          "0x0000000000000000000000000000000000000000",
          0
        )
      ).to.be.revertedWith("ERC721Token: unsafe recepient");
    });

    it("transfer between accounts", async function () {
      await ERC721Test.mint(owner.address);
      await ERC721Test.approve(addr1.address, 0);

      const ownerbalance = await ERC721Test.balanceOf(owner.address);
      const addr2balance = await ERC721Test.balanceOf(addr2.address);
      await ERC721Test.connect(addr1).transferFrom(
        owner.address,
        addr2.address,
        0
      );
      expect(await ERC721Test.balanceOf(addr2.address)).to.equal(
        addr2balance + 1
      );
      expect(await ERC721Test.balanceOf(owner.address)).to.equal(
        ownerbalance - 1
      );
      expect(await ERC721Test.ownerOf(0)).to.equal(addr2.address);
    });

    it("transfer event", async function () {
      await ERC721Test.mint(owner.address);
      await ERC721Test.approve(addr1.address, 0);

      expect(
        await ERC721Test.connect(addr1).transferFrom(
          owner.address,
          addr2.address,
          0
        )
      )
        .to.be.emit(ERC721Test, "Transfer")
        .withArgs(owner.address, addr2.address, 0);
    });
  });

  describe("safeTransferFrom", async function(){
    it("fail if caller is not owner or approved", async function () {
      await ERC721Test.mint(owner.address);
      await expect(
        ERC721Test
          .connect(addr1)
          ["safeTransferFrom(address,address,uint256,bytes)"](
            owner.address,
            addr2.address,
            0,
            "0x"
          )
      ).to.be.revertedWith("ERC721Token: token owner doesn't match");
    });

    it("fail if safeTransferFrom from incorrect owner", async function () {
      await ERC721Test.mint(owner.address);
      await expect(
        ERC721Test["safeTransferFrom(address,address,uint256,bytes)"](
          addr1.address,
          addr2.address,
          0,
          "0x"
        )
      ).to.be.revertedWith("ERC721Token: token owner doesn't match");
    });

    it("fail if recepient address is zero", async function () {
      await ERC721Test.mint(owner.address);
      await expect(
        ERC721Test["safeTransferFrom(address,address,uint256,bytes)"](
          owner.address,
          "0x0000000000000000000000000000000000000000",
          0,
          "0x"
        )
      ).to.be.revertedWith("ERC721Token: unsafe recepient");
    });

    it("safeTransferFrom", async function () {
      await ERC721Test.mint(owner.address);
      await ERC721Test["safeTransferFrom(address,address,uint256,bytes)"](
        owner.address,
        addr1.address,
        0,
        "0x"
      );
      expect(await ERC721Test.ownerOf(0)).to.equal(addr1.address);
    });

    it("should safeTransferFrom if approve ", async function () {
      await ERC721Test.mint(owner.address);
      await ERC721Test.approve(addr1.address, 0);
      await ERC721Test
        .connect(addr1)
        ["safeTransferFrom(address,address,uint256,bytes)"](
          owner.address,
          addr2.address,
          0,
          "0x"
        );
      expect(await ERC721Test.ownerOf(0)).to.equal(addr2.address);
    });

    it("safeTransferFrom if approved for all ", async function () {
      await ERC721Test.mint(owner.address);
      await ERC721Test.setApprovalForAll(addr1.address, true);
      await ERC721Test
        .connect(addr1)
        ["safeTransferFrom(address,address,uint256,bytes)"](
          owner.address,
          addr2.address,
          0,
          "0x"
        );
      expect(await ERC721Test.ownerOf(0)).to.equal(addr2.address);
    });

    it("should emit an event", async function() {
      await ERC721Test.mint(owner.address);
      await ERC721Test.approve(addr1.address, 0);

      await expect(
        ERC721Test
          .connect(addr1)
          ["safeTransferFrom(address,address,uint256,bytes)"](
            owner.address,
            addr2.address,
            0,
            "0x"
          )
      )
        .to.emit(ERC721Test, "Transfer")
        .withArgs(owner.address, addr2.address, 0);
    });
  });

});
