import { JsonRpcProvider, Wallet, ContractFactory, parseEther } from "ethers";
import "dotenv/config";
import fs from "fs/promises";

async function main() {
  // Carga el artifact que generó Hardhat al compilar
  const artifact = JSON.parse(
    await fs.readFile("./artifacts/contracts/kipubank.sol/KipuBank.json", "utf8")
  );

  const provider = new JsonRpcProvider(process.env.SEPOLIA_RPC_URL);
  const wallet = new Wallet(process.env.PRIVATE_KEY, provider);

  const cap = parseEther("10");   // bankCap = 10 ETH
  const lim = parseEther("0.5");  // withdrawLimit = 0.5 ETH

  const factory = new ContractFactory(artifact.abi, artifact.bytecode, wallet);
  const contract = await factory.deploy(cap, lim);
  await contract.deploymentTransaction().wait();

  console.log("KipuBank:", await contract.getAddress());
}

main().catch((e) => { console.error(e); process.exit(1); });
