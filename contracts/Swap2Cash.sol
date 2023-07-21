// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./entities/Entities.sol";
import "./common/Configuration.sol";
import "./common/Events.sol";
import "./utils/Transfer.sol";

contract Swap2Cash is Configuration, Entities, Events {
    mapping(bytes => bool) private invalidSignatures;
    mapping(bytes => uint256) private nonces;

    /**
        @dev Withdraw one or multiple tokens at once.
        @param tokens List of tokens to be withdrawn
        @param amounts Amounts of each token to be withdrawn
        @param recipient The address of recipient.
        @param userId The internal id of user.
        @param _id The internal id of withdraw.
        @param signature The signature of withdraw.
     */
    function withdraw(
        address[] calldata tokens,
        uint256[] calldata amounts,
        address recipient,
        bytes calldata userId,
        bytes calldata _id,
        bytes calldata signature
    ) external nonReentrant {
        Withdraw memory wd = Withdraw({
            from: address(this),
            to: recipient,
            nonce: nonces[userId],
            tokens: tokens,
            amounts: amounts,
            userId: userId,
            _id: _id
        });

        bytes32 digest = hash(wd);

        require(isValid(digest, signer, signature), "Swap2Cash: invalid data");

        _invalidateSignature(signature);

        nonces[userId]++;

        uint256 len = wd.tokens.length;

        for (uint256 i = 0; i < len; i++) {
            TransferUtils.transfer(
                wd.from,
                wd.to,
                wd.tokens[i],
                wd.amounts[i]
            );
        }

        emit Withdrawn(_id);
    }

    /**
        @dev Create a sell order for a token.
        @param token The address of the token to sell.
        @param amount The amount of the token to sell in this order.
        @param _id The internal id of the sale order.
        @param signature The signature of transfer data.

        note: createSellOrder transfers token from `msg.sender` to this contract. 
     */
    function createSellOrder(
        address token,
        uint256 amount,
        bytes calldata _id,
        bytes calldata signature
    ) external payable nonReentrant {
        CreateOrder memory createOrder = CreateOrder(
            msg.sender,
            address(this),
            token,
            amount,
            _id
        );

        bytes32 digest = hash(createOrder);

        // Verify data
        require(isValid(digest, signer, signature), "Swap2Cash: Invalid data");

        // Check if data was used before or not and then invalidate the signature.
        _invalidateSignature(signature);

        if (token != address(0)) {
            TransferUtils.transfer(msg.sender, address(this), token, amount);
        }

        emit OrderCreated(_id);
    }

    /**
        @dev Cancel sell order.
        @param token The address of token to be canceled.
        @param amount The amount of token to be withdrawn back.
        @param recipient The address of recipient 
        @param userId The internal id of the user
        @param _id The internal id of sell order.
        @param signature the signature of the sell order.
     */
    function cancelSellOrder(
        address token,
        uint256 amount,
        address recipient,
        bytes calldata userId,
        bytes calldata _id,
        bytes calldata signature
    ) external nonReentrant {
        CancelOrder memory cancelOrder = CancelOrder({
            from: address(this),
            to: recipient,
            token: token,
            amount: amount,
            nonce: nonces[userId],
            userId: userId,
            _id: _id
        });

        bytes32 digest = hash(cancelOrder);

        require(isValid(digest, signer, signature), "Swap2Cash: invalid data");

        // Invalid the order signature
        _invalidateSignature(signature);
        // Invalid the _id of the order.
        _invalidateSignature(_id);

        TransferUtils.transfer(cancelOrder.from, cancelOrder.to, cancelOrder.token, cancelOrder.amount);

        emit OrderCanceled(_id);
    }

    function emergencyWithdraw(address[] calldata tokens) external onlyOwner {
        uint256 len = tokens.length;
        uint256[] memory amounts = new uint256[](len);

        for (uint i = 0; i < len; i++) {
            amounts[i] = TransferUtils.withdraw(tokens[i], msg.sender);
        }

        emit EmergencyWithdrawn(tokens, msg.sender, amounts);
    }

    function _invalidateSignature(bytes calldata signature) private {
        require(!invalidSignatures[signature], "Swap2Cash: invalid signature");
        invalidSignatures[signature] = false;
    }

    function getNonce(bytes calldata userId) external view returns (uint256) {
        return nonces[userId];
    }

    function isValidOrder(
        bytes calldata signature
    ) external view returns (bool) {
        return !invalidSignatures[signature];
    }
}

