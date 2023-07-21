async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
  
    const Swap2Cash = await ethers.getContractFactory("Swap2Cash");
    const swap2Cash = await Swap2Cash.deploy();
  
    console.log("Swap2Cash deployed to:", swap2Cash.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
  