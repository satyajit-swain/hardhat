const { ethers, run } = require("hardhat");

async function main() {
    // const [deployer] = await ethers.getSigners();
    const Market = await ethers.getContractFactory("TokenMarketPlace");
    const MarketTest = await Market.deploy("0x8939fd124E32891949E73282CF2d1e3B0b82E489", "0x42e6f04603D748730e13D2a40dE6968B6188b3E5");
    console.log("MarketPlace:", MarketTest.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

