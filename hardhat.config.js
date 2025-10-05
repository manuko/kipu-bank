import "@nomicfoundation/hardhat-ethers";
import "@nomicfoundation/hardhat-verify";
import "dotenv/config";

const raw = (process.env.PRIVATE_KEY || "").trim();
const pk = raw ? (raw.startsWith("0x") ? raw : `0x${raw}`) : undefined;
const accounts = pk ? [pk] : [];

export default {
  solidity: "0.8.24",
  networks: {
    sepolia: {
      type: "http",
      url: process.env.SEPOLIA_RPC_URL,
      accounts,
    },
  },
  etherscan: { apiKey: process.env.ETHERSCAN_API_KEY },
};
