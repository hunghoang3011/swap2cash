// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CancelOrder.sol";
import "./CreateOrder.sol";
import "./Withdraw.sol";

abstract contract Entities is
    WithdrawEntity,
    CreateOrderEntity,
    CancelOrderEntity
{
    /**
        @dev Check if a signature is valid or not.
     */
    function isValid(bytes32 digest, address signer, bytes calldata signature)
        internal
        pure
        returns (bool)
    {
        return ECDSAUpgradeable.recover(digest, signature) == signer;
    }
}
