const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  const swap2CashAddress = "<Swap2Cash Contract Address>";
  const newSignerAddress = "<New Signer Address>";

  const Swap2Cash = await ethers.getContractFactory("Swap2Cash");
  const swap2Cash = await Swap2Cash.attach(swap2CashAddress);

  console.log("Calling setSigner function in Swap2Cash contract...");

  const tx = await swap2Cash.connect(deployer).setSigner(newSignerAddress);
  await tx.wait();

  console.log("setSigner function executed successfully.");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
