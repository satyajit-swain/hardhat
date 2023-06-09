const { ethers, run } = require("hardhat");

async function main() {
    // const [owner] = await ethers.getSigners();
    const ERC1155 = await ethers.getContractFactory("ERC1155Tokens");
    const ERC1155Test = await ERC1155.deploy("saken","skn");
    console.log("ERC1155 address:", ERC1155Test.address);

    await ERC1155Test.deployTransaction.wait(5);

//verify

await hre.run("verify:verify", {
  address: ERC1155Test.address,
  contract: "contracts/ERC1155.sol:ERC1155", //Filename.sol:ClassName
constructorArguments: ["URI"],
});
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
