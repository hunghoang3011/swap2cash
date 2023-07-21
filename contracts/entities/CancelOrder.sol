// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol";

abstract contract CancelOrderEntity {

    struct CancelOrder {
        address from;
        address to;
        address token;
        uint256 amount;
        uint256 nonce;
        bytes userId;
        bytes _id;
    }

    function hash(CancelOrder memory cancelOrder) internal pure returns (bytes32) {
        return ECDSAUpgradeable.toEthSignedMessageHash(
            keccak256(
                abi.encodePacked(
                    cancelOrder.from,
                    cancelOrder.to,
                    cancelOrder.token,
                    cancelOrder.amount,
                    cancelOrder.nonce,
                    cancelOrder.userId,
                    cancelOrder._id
                )
            )
        );
    }
}
