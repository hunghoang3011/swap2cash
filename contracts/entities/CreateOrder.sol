// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol";

abstract contract CreateOrderEntity {

    struct CreateOrder {
        address from;
        address to;
        address token;
        uint256 amount;
        bytes _id;
    }

    function hash(CreateOrder memory createOrder) internal pure returns (bytes32) {
        return ECDSAUpgradeable.toEthSignedMessageHash(
            keccak256(
                abi.encodePacked(
                    createOrder.from,
                    createOrder.to,
                    createOrder.token,
                    createOrder.amount,
                    createOrder._id
                )
            )
        );
    }
}
