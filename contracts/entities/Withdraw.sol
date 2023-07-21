// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol";

abstract contract WithdrawEntity {
    struct Withdraw {
        address from;
        address to;
        uint256 nonce;
        address[] tokens;
        uint256[] amounts;
        bytes userId;
        bytes _id;
    }

    /**
    * @dev Calculates the hash of a withdraw.
    * @param wd The withdraw to calculate the hash for.
    * @return The hash of the withdraw.
    */
    function hash(Withdraw memory wd) internal pure returns (bytes32) {
        require(wd.tokens.length == wd.amounts.length);

        return ECDSAUpgradeable.toEthSignedMessageHash(
            keccak256(abi.encodePacked(wd.from, wd.to, wd.nonce, wd.tokens, wd.amounts, wd.userId, wd._id))
        );
    }
}