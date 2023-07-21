// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract Events {
    event OrderCreated(bytes _id);

    event OrderCanceled(bytes _id);

    event Withdrawn(bytes _id);

    event EmergencyWithdrawn(
        address[] tokens,
        address recipient,
        uint256[] amount
    );
}
