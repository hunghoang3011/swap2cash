// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

abstract contract Configuration is
    OwnableUpgradeable,
    ReentrancyGuardUpgradeable
{

    address signer;
    function setSigner(address newSigner) external onlyOwner {
        require(newSigner != signer, "Setting: Same addresses");
        signer = newSigner;
    }

    function getSigner() external view returns (address) {
        return signer;
    }
}
