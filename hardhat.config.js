require('@nomiclabs/hardhat-ethers');
require("@nomiclabs/hardhat-waffle");
require('@openzeppelin/hardhat-upgrades');
require("dotenv").config();
require("@nomiclabs/hardhat-etherscan");

module.exports = {
    solidity: {
        compilers: [{
            version: "0.8.10",
            settings: {
                optimizer: {
                    enabled: true,
                    runs: 200,
                }
            },
            allowUnlimitedContractSize: true
        }],
    },

    networks: {
        goerli: {
            url: process.env.GOERLI_RPC,
            accounts: [process.env.PRIVATE_KEY],
        },
        // bscTestnet: {
        //     url: process.env.BSC_TESTNET_RPC,
        //     accounts: [process.env.PRIVATE_KEY],
        // },
        // polygonTestnet: {
        //     url: process.env.POLYGON_TESTNET_RPC,
        //     accounts: [process.env.PRIVATE_KEY],
        // },
        // bsc: {
        //     url: "https://bsc-dataseed.binance.org/",
        //     chainId: 56,
        //     gasPrice: 6000000000,
        //     accounts: [process.env.PRIVATE_KEY],
        // },
        private: {
          url: process.env.PRIVATE_PRC,
          chainId: 3111992,
          gasPrice: 6000000000,
          accounts: [process.env.PRIVATE_KEY],
        }
        ,
        // mainnet: {
        //     url: "https://eth.llamarpc.com",
        //     chainId: 1,
        //     gasPrice: 20000000000,
        //     accounts: [process.env.PRIVATE_KEY],
        // },
        
    },
    etherscan: {
        apiKey: {
            goerli: process.env.ETHERSCAN_API,
            // bscTestnet: process.env.BSCSCAN_API,
            // polygonMumbai: process.env.POLYGON_API,
            // mainnet: "2UR784WKFTQUCUFC99ZCCNJBKM4YGQBTQN",
            // private: process.env.PRIVATE_API,
            // bsc: process.env.BSCSCAN_API
        },
    },
};