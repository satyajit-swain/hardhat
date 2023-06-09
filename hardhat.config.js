require("@nomicfoundation/hardhat-toolbox");
require("hardhat-gas-reporter");
require("hardhat-contract-sizer");
require('hardhat-abi-exporter');
// require("@nomicfoundation/hardhat-verify");

/** @type import('hardhat/config').HardhatUserConfig */

module.exports = {
  solidity: "0.8.18",
  gasReporter: {
    currency: 'USD',
    gasPrice: 21,
    enabled: true,
    coinmarketcap: 'c322bffd-b7b5-48b6-8395-3dabe53711d6',
  },
  contractSizer: {
    alphaSort: true,
    disambiguatePaths: false,
    runOnCompile: true,
    strict: true,
    // only: [':TokenMarketPlace$'],
  },
  abiExporter: {
    path: './data/abi',
    runOnCompile: true,
    clear: true,
    flat: true,
    only: [':TokenMarketPlace$'],
    spacing: 2,
    pretty: true,
    // format: "minimal",
  },
  solidity: "0.8.18",
  networks: {
    sepolia: {
      url: `https://sepolia.infura.io/v3/d7aabeb1a71e4479bef50257ea30191c`,
      accounts: ["a0d4dfa6ffce883065d8d26c53f1273bd83986e3a31111efd1185a346732a8db"]
    }
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: "E9XG9IMJMN5BN8EIBM368ERTSEDWMHWT58"
  }
};

//const INFURA_API_KEY = "KEY";

// Replace this private key with your Sepolia account private key
// To export your private key from Coinbase Wallet, go to
// Settings > Developer Settings > Show private key
// To export your private key from Metamask, open Metamask and
// go to Account Details > Export Private Key
// Beware: NEVER put real Ether into testing accounts
//const SEPOLIA_PRIVATE_KEY = "a0d4dfa6ffce883065d8d26c53f1273bd83986e3a31111efd1185a346732a8db";

// module.exports = {
//   solidity: "0.8.18",
//   networks: {
//     sepolia: {
//       url: `https://sepolia.infura.io/v3/d7aabeb1a71e4479bef50257ea30191c`,
//       accounts: ["a0d4dfa6ffce883065d8d26c53f1273bd83986e3a31111efd1185a346732a8db"]
//     }
//   },
//   etherscan: {
//     // Your API key for Etherscan
//     // Obtain one at https://etherscan.io/
//     apiKey: "E9XG9IMJMN5BN8EIBM368ERTSEDWMHWT58"
//   }
// };
