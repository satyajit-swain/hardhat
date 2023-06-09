const { expect } = require("chai");
const { ethers } = require("hardhat");
const { getErrorCode } = require("hardhat/internal/core/errors-list");

describe("ERC20 contract", function () {
  let ERC20;
  let ERC20Test;
  let addr1, addr2, owner;

  beforeEach(async function () {
    ERC20 = await ethers.getContractFactory("ERC20");
    ERC20Test = await ERC20.deploy();
    [owner, addr1, addr2] = await ethers.getSigners();
  });

  describe("Deployment", async function () {
    it("Deployer should be the owner", async function () {
      expect(await ERC20Test.owner()).to.equal(owner.address);
    });
    it("total supply should be assigned to the owner's account", async function () {
      expect(await ERC20Test.totalSupply()).to.equal(
        await ERC20Test.balanceOf(owner.address)
      );
    });
  });
  describe("Transactions", async function () {
    it("Fail if sender doesn't have enough tokens", async function () {
      const ownerBalance = await ERC20Test.balanceOf(owner.address);
      await expect(
        ERC20Test.connect(addr1).transfer(owner.address, 5000000000000000000n)
      ).to.be.revertedWith("ERC20: Not enough tokens");
      expect(await ERC20Test.balanceOf(owner.address)).to.equal(ownerBalance);
    });
    it("Transfer tokens between the accounts should be succeessfull", async function () {
      await ERC20Test.transfer(addr1.address, 10000000000000000000n);
      expect(await ERC20Test.balanceOf(addr1.address)).to.equal(
        10000000000000000000n
      );
    });
    it("balances should get updated after token transfer", async function () {
      const ownerBalance = await ERC20Test.balanceOf(owner.address);
      await ERC20Test.transfer(addr1.address, 10000000000000000000n);
      expect(await ERC20Test.balanceOf(owner.address)).to.equal(
        BigInt(ownerBalance) - 10000000000000000000n
      );
      expect(await ERC20Test.balanceOf(addr1.address)).to.equal(
        10000000000000000000n
      );
    });
  });

  describe("Mint", async function () {
    it("only owner can mint tokens", async function () {
      const ownerBalance = await ERC20Test.balanceOf(owner.address);
      await expect(
        ERC20Test.connect(addr1).mint(50000000000000000000n)
      ).to.be.revertedWith("ERC20: Only Owner can access");
    });

    it("owner should mint valid number of tokens ṭhat satisfy accoording to the max supply", async function () {
      const ownerBalance = await ERC20Test.balanceOf(owner.address);
      await expect(ERC20Test.mint(55000000000000000000n)).to.be.revertedWith(
        "ERC20: Reached MAX supply"
      );
      await expect(ERC20Test.mint(0)).to.be.revertedWith(
        "ERC20: Reached MAX supply"
      );
      expect(await ERC20Test.balanceOf(owner.address)).to.equal(ownerBalance);
    });
    it("Mint tokens to the account of owner", async function () {
      const ownerBalance = await ERC20Test.balanceOf(owner.address);
      const intialSupply = await ERC20Test.totalSupply();

      const tokenMint = await ERC20Test.mint(20000000000000000000n);
      expect(await ERC20Test.balanceOf(owner.address)).to.equal(
        BigInt(ownerBalance) + 20000000000000000000n
      );
      expect(await ERC20Test.totalSupply()).to.equal(
        BigInt(intialSupply) + 20000000000000000000n
      );
      expect(tokenMint)
        .to.emit(ERC20Test, "Transfer")
        .withArgs(
          "0x0000000000000000000000000000000000000000",
          owner.address,
          10000000000000000000n
        );
    });
    it("Mint event", async function () {
      await expect(ERC20Test.mint(20000000000000000000n))
        .to.emit(ERC20Test, "Transfer")
        .withArgs(
          "0x0000000000000000000000000000000000000000",
          owner.address,
          20000000000000000000n
        );
    });
  });

  describe("approve and allowance", async function () {
    it("tokens approved", async function () {
      await ERC20Test.transfer(addr1.address, 20000000000000000000n);
      const addr1Balance = await ERC20Test.balanceOf(addr1.address);
      await ERC20Test.approve(addr1.address, 15000000000000000000n);

      expect(await ERC20Test.allowance(owner.address, addr1.address)).to.equal(
        15000000000000000000n
      );
    });
    it("fail if approval address doesn't have enough tokens", async function () {
      const addr1Allowance = await ERC20Test.allowance(
        owner.address,
        addr1.address
      );
      await expect(
        ERC20Test.approve(addr1.address, 10000000000000000000n)
      ).to.be.revertedWith("ERC20: insuficient balance for approval");
      expect(await ERC20Test.allowance(owner.address, addr1.address)).to.equal(
        addr1Allowance
      );
    });
  });
  describe("Burn tokens", async function () {
    it("owner can burn tokens less than or equals to total supply", async function () {
      const ownerBalance = await ERC20Test.balanceOf(owner.address);
      await expect(ERC20Test.burn(55000000000000000000n)).to.be.revertedWith(
        "ERC20: Not enough tokens"
      );
      expect(await ERC20Test.balanceOf(owner.address)).to.equal(ownerBalance);
    });
    it("only owner can burn tokens", async function () {
      const initialSupply = await ERC20Test.totalSupply();
      await expect(
        ERC20Test.connect(addr1).burn(10000000000000000000n)
      ).to.be.revertedWith("ERC20: Only Owner can access");
      expect(await ERC20Test.totalSupply()).to.equal(initialSupply);
    });
    it("burn tokens from the owner's account", async function () {
      ERC20Test.mint(10000000000000000000n);
      const ownerBalance = await ERC20Test.balanceOf(owner.address);

      const tokenBurn = await ERC20Test.burn(5000000000000000000n);
      expect(await ERC20Test.balanceOf(owner.address)).to.equal(
        BigInt(ownerBalance) - 5000000000000000000n
      );
      // await expect(tokenBurn)
      //   .to.emit(ERC20Test, "Transfer")
      //   .withArgs(
      //     owner.address,
      //     "0x0000000000000000000000000000000000000000",
      //     10000000000000000000n
      //   );
    });
    it("burn event", async function () {
      ERC20Test.mint(10000000000000000000n);

      await expect(ERC20Test.burn(5000000000000000000n))
        .to.be.emit(ERC20Test, "Transfer")
        .withArgs(
          owner.address,
          "0x0000000000000000000000000000000000000000",
          5000000000000000000n
        );
    });
  });
  describe("transferFrom allowance", async function () {
    it("fail is allowance is less than transfered amount", async function () {
      await expect(
        ERC20Test.transferFrom(
          addr1.address,
          addr2.address,
          10000000000000000000n
        )
      ).to.be.revertedWith("ERC20: Not Allowed");
      expect(await ERC20Test.balanceOf(addr2.address)).to.equal(0);
    });

    it("fail if token owner does't have enough token balance", async function () {
      await ERC20Test.transfer(addr1.address, 40000000000000000000n);
      await ERC20Test.approve(addr1.address, 30000000000000000000n);
      const addr1Allowance = await ERC20Test.allowance(
        owner.address,
        addr1.address
      );
      await expect(
        ERC20Test.connect(addr1).transferFrom(
          owner.address,
          addr2.address,
          20000000000000000000n
        )
      ).to.be.revertedWith("ERC20: Not enough tokens!");
      expect(await ERC20Test.allowance(owner.address, addr1.address)).to.equal(
        addr1Allowance
      );
    });

    it("transfer tokens to other account", async function () {
      await ERC20Test.transfer(addr1.address, 20000000000000000000n);
      await ERC20Test.approve(addr1.address, 10000000000000000000n);
      const addr1Balance = await ERC20Test.balanceOf(addr1.address);
      const addr1Allowance = await ERC20Test.allowance(
        owner.address,
        addr1.address
      );
      const tokenSent = await ERC20Test.connect(addr1).transferFrom(
        owner.address,
        addr2.address,
        5000000000000000000n
      );
      expect(await ERC20Test.allowance(owner.address, addr1.address)).to.equal(
        BigInt(addr1Allowance) - 5000000000000000000n
      );
      expect(await ERC20Test.balanceOf(addr2.address)).to.equal(
        5000000000000000000n
      );

      expect(tokenSent)
        .to.emit(ERC20Test, "Transfer")
        .withArgs(owner.address, addr2.address, 5000000000000000000n);
    });
  });

  describe("events", async function () {
    it("transfer event", async function () {
      expect(await ERC20Test.transfer(addr1.address, 10000000000000000000n))
        .to.emit(ERC20Test, "Transfer")
        .withArgs(owner.address, addr1.address, 10000000000000000000n);
    });
    it("approve event", async function () {
      await ERC20Test.transfer(addr1.address, 20000000000000000000n);
      expect(await ERC20Test.approve(addr1.address, 15000000000000000000n))
        .to.emit(ERC20Test, "Approval")
        .withArgs(owner.address, addr1.address, 15000000000000000000n);
    });
  });
});
