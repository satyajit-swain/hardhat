const { ethers, run } = require("hardhat");

async function main() {
  // const [owner] = await ethers.getSigners();
  const ERC20 = await ethers.getContractFactory("ERC20");
  const ERC20Test = await ERC20.deploy();
  console.log("ERC20 address:", ERC20Test.address);

  await ERC20Test.deployTransaction.wait(5);

  //verify

  await hre.run("verify:verify", {
    address: ERC20Test.address,
    contract: "contracts/ERC20.sol:ERC20", //Filename.sol:ClassName
    // constructorArguments: ["URI"],
  });
}
 
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
