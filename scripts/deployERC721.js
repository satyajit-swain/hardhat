const { ethers, run } = require("hardhat");

async function main() {
    // const [owner] = await ethers.getSigners();
    const ERC721 = await ethers.getContractFactory("ERC721Token");
    const ERC721Test = await ERC721.deploy();
    console.log("ERC721 address:", ERC721Test.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
