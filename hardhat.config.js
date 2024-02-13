require("@nomicfoundation/hardhat-toolbox");

const INFURA_API_KEY = "60998abe461d44128032f3771b42890b";
const SEPOLIA_PRIVATE_KEY = "95d0fa8665320492bbca0b3dd2c8326e3b9f8c33f7093dfc9588c76ccca7af34";

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.23",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
  sepolia: {
    url: `https://sepolia.infura.io/v3/${INFURA_API_KEY}`,
    accounts: [SEPOLIA_PRIVATE_KEY]
  }
}
};
