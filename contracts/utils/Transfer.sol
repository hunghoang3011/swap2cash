// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/interfaces/IERC20Upgradeable.sol";

library TransferUtils {
    using SafeERC20Upgradeable for IERC20Upgradeable;

    /**
     * @dev Transfers `amount` from `from` to `to`.
     * @param from The address of the sender.
     * @param to The address of the recipient.
     * @param token The address of the token to transfer.
     * @param amount The amount to transfer.
     */
    function transfer(
        address from,
        address to,
        address token,
        uint256 amount
    ) internal {
        if (token == address(0)) {
            // Transfer ETH.
            (bool sent, ) = msg.sender.call{value: amount}("");
            require(sent, "Swap2Cash: Failed to transfer Ether");
            return;
        }

        // Transfer ERC20 token.
        IERC20Upgradeable(token).safeTransferFrom(from, to, amount);
    }

    /**
     * @dev Withdraws `amount` of token `token` from the contract and transfers it to `recipient`.
     * @param token The address of the token to withdraw.
     * @param recipient The address of the recipient.
     * @return amount The amount of token withdrawn.
     */
    function withdraw(
        address token,
        address recipient
    ) internal returns (uint256 amount) {
        amount = IERC20Upgradeable(token).balanceOf(address(this));
        IERC20Upgradeable(token).safeTransfer(recipient, amount);
        return amount;
    }
}
