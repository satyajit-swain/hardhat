const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ERC1155 contract", function () {
  let ERC1155;
  let ERC1155Test;
  let addr1, addr2, owner;

  beforeEach(async function () {
    ERC1155 = await ethers.getContractFactory("ERC1155Token");
    ERC1155Test = await ERC1155.deploy("ERC1155 tokens", "10");
    [owner, addr1, addr2] = await ethers.getSigners();
  });

  describe("Deployment", async function () {
    it("Deployer should be the owner", async function () {
      expect(await ERC1155Test.owner()).to.equal(owner.address);
    });
    it("token mint price should be updated", async function () {
      expect(await ERC1155Test.mintAmount()).to.equal(10);
    });
  });

  describe("Mint Tokens", async () => {
    it("number of tokens is not equal to zero", async () => {
      await expect(ERC1155Test.mint(0, 0)).to.be.revertedWith(
        "ERC1155Token: Tokens cannot be zero"
      );
    });
    it("For minting, minter should own the token or the token belongs to zero address", async () => {
      await ERC1155Test.mint(0, 5, { value: "50" });
      await expect(
        ERC1155Test.connect(addr1).mint(0, 2, { value: "20" })
      ).to.be.revertedWith("ERC1155Token: token id doesn't match");
    });
    it("token amount should match according to no. of tokens", async () => {
      await expect(
        ERC1155Test.connect(addr1).mint(0, 10, { value: "50" })
      ).to.be.revertedWith("ERC1155Token: pay correct amount");
    });
    it("tokens mint successful", async () => {
      const ownerTbalance = await ERC1155Test.balanceOf(owner.address, 0);
      await ERC1155Test.mint(0, 5, { value: "50" });
      expect(await ERC1155Test.balanceOf(owner.address, 0)).to.equal(
        ownerTbalance + 5
      );
    });
    it("after mint,the contract owner should get its mint price", async () => {
      const ownerbalance = await ethers.provider.getBalance(owner.address);
      await ERC1155Test.connect(addr1).mint(0, 5, { value: "50" });
      expect(await ethers.provider.getBalance(owner.address)).to.equal(
        BigInt(ownerbalance) + BigInt(50)
      );
    });
    it("mint event", async () => {
      await expect(ERC1155Test.connect(addr1).mint(0, 3, { value: "30" }))
        .to.be.emit(ERC1155Test, "TransferSingle")
        .withArgs(
          addr1.address,
          "0x0000000000000000000000000000000000000000",
          addr1.address,
          0,
          3
        );
    });
  });

  describe("burn", async () => {
    it("tokens cannot be zero", async () => {
      await ERC1155Test.connect(addr1).mint(0, 5, { value: "50" });
      await expect(ERC1155Test.connect(addr1).burn(0, 0)).to.be.revertedWith(
        "ERC1155Token: Tokens cannot be zero"
      );
    });
    it("tokens burn successful", async () => {
      await ERC1155Test.connect(addr1).mint(0, 5, { value: "50" });
      const add1Tbalance = await ERC1155Test.balanceOf(addr1.address, 0);
      await ERC1155Test.connect(addr1).burn(0, 3);
      expect(await ERC1155Test.balanceOf(addr1.address, 0)).to.equal(
        add1Tbalance - 3
      );
    });
    it("burn event", async () => {
      await ERC1155Test.connect(addr1).mint(0, 5, { value: "50" });
      await expect(ERC1155Test.connect(addr1).burn(0, 3))
        .to.be.emit(ERC1155Test, "TransferSingle")
        .withArgs(
          addr1.address,
          addr1.address,
          "0x0000000000000000000000000000000000000000",
          0,
          3
        );
    });
  });

  describe("Mint batch", async () => {
    it("For minting, minter should own the token or the token belongs to zero address", async () => {
      await ERC1155Test.mintBatch([1, 2], [5, 10], { value: "150" });
      await expect(
        ERC1155Test.connect(addr1).mintBatch([1, 2], [2, 3], { value: "50" })
      ).to.be.revertedWith("ERC1155Token: token id doesn't match");
    });
    it("token ids and no. of tokens should be equal", async () => {
      await expect(
        ERC1155Test.connect(addr1).mintBatch([1, 2, 3], [5, 5], { value: 100 })
      ).to.be.revertedWith("ERC1155: ids and amounts length mismatch");
    });
    it("token amount should match according to no. of tokens", async () => {
      await expect(
        ERC1155Test.connect(addr1).mintBatch([1, 2, 3], [5, 5, 10], {
          value: "100",
        })
      ).to.be.revertedWith("ERC1155Token: pay correct amount");
    });
    it("tokens mint successful", async () => {
      const ownerT1balance = await ERC1155Test.balanceOf(owner.address, 1);
      const ownerT2balance = await ERC1155Test.balanceOf(owner.address, 2);
      await ERC1155Test.mintBatch([1, 2], [5, 10], { value: "150" });
      expect(await ERC1155Test.balanceOf(owner.address, 1)).to.equal(
        ownerT1balance + 5
      );
      expect(await ERC1155Test.balanceOf(owner.address, 2)).to.equal(
        ownerT2balance + 10
      );
    });
    it("after mint,the contract owner should get its mint price", async () => {
      const ownerbalance = await ethers.provider.getBalance(owner.address);
      await ERC1155Test.connect(addr1).mintBatch([1, 2], [10, 30], {
        value: "400",
      });
      expect(await ethers.provider.getBalance(owner.address)).to.equal(
        BigInt(ownerbalance) + BigInt(400)
      );
    });

    it("mint batch event", async () => {
      await expect(ERC1155Test.mintBatch([1, 2], [5, 10], { value: "150" }))
        .to.be.emit(ERC1155Test, "TransferBatch")
        .withArgs(
          owner.address,
          "0x0000000000000000000000000000000000000000",
          owner.address,
          [1, 2],
          [5, 10]
        );
    });
  });

  describe("Burn Batch", async () => {
    it("token ids and no. of tokens should be equal", async () => {
      await expect(
        ERC1155Test.connect(addr1).burnBatch([1, 2, 3], [5, 5])
      ).to.be.revertedWith("ERC1155: ids and amounts length mismatch");
    });
    it("token is less than available balance", async () => {
      await ERC1155Test.connect(addr1).mintBatch([1, 2], [5, 10], {
        value: "150",
      });
      await expect(
        ERC1155Test.connect(addr1).burnBatch([1, 2], [5, 15])
      ).to.be.revertedWith("ERC1155: burn amount exceeds balance");
    });
    it("tokens burn successful", async () => {
      await ERC1155Test.connect(addr1).mintBatch([1, 2], [5, 10], {
        value: "150",
      });
      const add1T1balance = await ERC1155Test.balanceOf(addr1.address, 1);
      const add1T2balance = await ERC1155Test.balanceOf(addr1.address, 2);
      await ERC1155Test.connect(addr1).burnBatch([1, 2], [2, 4]);
      expect(await ERC1155Test.balanceOf(addr1.address, 1)).to.equal(
        add1T1balance - 2
      );
      expect(await ERC1155Test.balanceOf(addr1.address, 2)).to.equal(
        add1T2balance - 4
      );
    });

    it("burn batch event", async () => {
      await ERC1155Test.connect(addr1).mintBatch([1, 2], [5, 10], {
        value: "150",
      });
      await expect(ERC1155Test.connect(addr1).burnBatch([1, 2], [2, 4]))
        .to.be.emit(ERC1155Test, "TransferBatch")
        .withArgs(
          addr1.address,
          addr1.address,
          "0x0000000000000000000000000000000000000000",
          [1, 2],
          [2, 4]
        );
    });
  });

  describe("safe transfer", async () => {
    it("sender must transfering or have allowance", async () => {
      await expect(
        ERC1155Test.safeTransferFrom(addr1.address, addr2.address, 1, 5, "0x00")
      ).to.be.revertedWith("ERC1155: caller is not token owner or approved");
    });

    it("fail if recepient address is zero", async function () {
      await ERC1155Test.mint(1, 5, { value: "50" });
      await expect(
        ERC1155Test.safeTransferFrom(
          owner.address,
          "0x0000000000000000000000000000000000000000",
          1,
          2,
          "0x00"
        )
      ).to.be.revertedWith("ERC1155: transfer to the zero address");
    });

    it("token is less than available balance", async () => {
      await ERC1155Test.connect(addr1).mint(1, 5, { value: "50" });

      await expect(
        ERC1155Test.connect(addr1).safeTransferFrom(
          addr1.address,
          addr2.address,
          1,
          8,
          "0x00"
        )
      ).to.be.revertedWith("ERC1155: insufficient balance for transfer");
    });

    it("safe transfer successful", async () => {
      await ERC1155Test.connect(addr1).mint(1, 5, { value: "50" });
      const addr1Tbalance = await ERC1155Test.balanceOf(addr1.address, 1);
      const addr2Tbalance = await ERC1155Test.balanceOf(addr2.address, 1);
      await ERC1155Test.connect(addr1).safeTransferFrom(
        addr1.address,
        addr2.address,
        1,
        2,
        "0x00"
      );
      expect(await ERC1155Test.balanceOf(addr1.address, 1)).to.equal(
        addr1Tbalance - 2
      );
      expect(await ERC1155Test.balanceOf(addr2.address, 1)).to.equal(
        addr2Tbalance + 2
      );
    });

    it("safe transfer from allowed sender", async () => {
      await ERC1155Test.connect(addr1).mint(1, 5, { value: "50" });
      await ERC1155Test.connect(addr1).setApprovalForAll(addr2.address, true);
      const ownerTbalance = await ERC1155Test.balanceOf(owner.address, 1);
      await ERC1155Test.connect(addr2).safeTransferFrom(
        addr1.address,
        owner.address,
        1,
        2,
        "0x00"
      );

      expect(await ERC1155Test.balanceOf(owner.address, 1)).to.equal(
        ownerTbalance + 2
      );
    });

    it("safe transfer event", async () => {
      await ERC1155Test.connect(addr1).mint(1, 5, { value: "50" });
      await ERC1155Test.connect(addr1).setApprovalForAll(addr2.address, true);
      await expect(
        ERC1155Test.connect(addr2).safeTransferFrom(
          addr1.address,
          owner.address,
          1,
          2,
          "0x00"
        )
      )
        .to.be.emit(ERC1155Test, "TransferSingle")
        .withArgs(addr2.address, addr1.address, owner.address, 1, 2);
    });
  });

  describe("safe batch transfer", async () => {
    it("sender must transfering or have allowance", async () => {
      await expect(
        ERC1155Test.safeBatchTransferFrom(
          addr1.address,
          addr2.address,
          [1, 2],
          [5, 7],
          "0x00"
        )
      ).to.be.revertedWith("ERC1155: caller is not token owner or approved");
    });

    it("fail if recepient address is zero", async function () {
      await ERC1155Test.mintBatch([1, 2], [10, 15], { value: "250" });
      await expect(
        ERC1155Test.safeTransferFrom(
          owner.address,
          "0x0000000000000000000000000000000000000000",
          [1, 2],
          [5, 10],
          "0x00"
        )
      ).to.be.revertedWith("ERC1155: transfer to the zero address");
    });
    it("fail if ids and amounts length doesn't match", async function () {
      await ERC1155Test.mintBatch([1, 2], [10, 15], { value: "250" });
      await expect(
        ERC1155Test.safeBatchTransferFrom(
          owner.address,
          addr1.address,
          [1, 2],
          [5],
          "0x00"
        )
      ).to.be.revertedWith("ERC1155: ids and amounts length mismatch");
    });

    it("token is less than available balance", async () => {
      await ERC1155Test.connect(addr1).mintBatch([1, 2], [10, 15], {
        value: "250",
      });

      await expect(
        ERC1155Test.connect(addr1).safeBatchTransferFrom(
          addr1.address,
          addr2.address,
          [1, 2],
          [10, 20],
          "0x00"
        )
      ).to.be.revertedWith("ERC1155: insufficient balance for transfer");
    });

    it("safe batch transfer successful", async () => {
      await ERC1155Test.connect(addr1).mintBatch([1, 2], [10, 15], {
        value: "250",
      });

      await ERC1155Test.connect(addr1).safeBatchTransferFrom(
        addr1.address,
        addr2.address,
        [1, 2],
        [5, 10],
        "0x00"
      );

      const Tbalance = await ERC1155Test.balanceOfBatch(
        [addr1.address, addr1.address, addr2.address, addr2.address],
        [1, 2, 1, 2]
      );

      const TBalance = Tbalance.map((balance) => balance.toString());
      expect(TBalance).eql(["5", "5", "5", "10"]);
    });

    it("safe batch transfer from allowed address", async () => {
      await ERC1155Test.connect(addr1).mintBatch([1, 2], [10, 15], {
        value: "250",
      });
      await ERC1155Test.connect(addr1).setApprovalForAll(addr2.address, true);

      await ERC1155Test.connect(addr2).safeBatchTransferFrom(
        addr1.address,
        addr2.address,
        [1, 2],
        [5, 10],
        "0x00"
      );
      const Tbalance = await ERC1155Test.balanceOfBatch(
        [addr1.address, addr1.address, addr2.address, addr2.address],
        [1, 2, 1, 2]
      );
      const TBalance = Tbalance.map((balance) => balance.toString());
      expect(TBalance).eql(["5", "5", "5", "10"]);
    });

    it("safe batch transfer event", async () => {
      await ERC1155Test.connect(addr1).mintBatch([1, 2], [10, 15], {
        value: "250",
      });
      await ERC1155Test.connect(addr1).setApprovalForAll(addr2.address, true);

      await expect(
        ERC1155Test.connect(addr2).safeBatchTransferFrom(
          addr1.address,
          addr2.address,
          [1, 2],
          [5, 10],
          "0x00"
        )
      )
        .to.be.emit(ERC1155Test, "TransferBatch")
        .withArgs(addr2.address, addr1.address, addr2.address, [1, 2], [5, 10]);
    });
  });

  describe("approval for all", async () => {
    it("self approve is not allowed", async () => {
      await ERC1155Test.connect(addr1).mint(1, 5, { value: "50" });
      await expect(
        ERC1155Test.connect(addr1).setApprovalForAll(addr1.address, true)
      ).to.be.revertedWith("ERC1155: setting approval status for self");
    });

    it("safe transfer after approval", async () => {
      await ERC1155Test.connect(addr1).mint(1, 5, { value: "50" });
      await ERC1155Test.connect(addr1).setApprovalForAll(addr2.address, true);
      const ownerTbalance = await ERC1155Test.balanceOf(owner.address, 1);

      await ERC1155Test.connect(addr2).safeTransferFrom(
        addr1.address,
        owner.address,
        1,
        2,
        "0x00"
      );

      expect(await ERC1155Test.balanceOf(owner.address, 1)).to.equal(
        ownerTbalance + 2
      );
    });

    it("approve event", async () => {
      await ERC1155Test.connect(addr1).mint(1, 5, { value: "50" });
      await expect(
        ERC1155Test.connect(addr1).setApprovalForAll(addr2.address, true)
      )
        .to.be.emit(ERC1155Test, "ApprovalForAll")
        .withArgs(addr1.address, addr2.address, true);
    });
  });
});
