// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.12;

import {IERC20Minimal} from '../interfaces/IERC20Minimal.sol';

import {IOtterSwapSwapCallback} from '../interfaces/callback/IOtterSwapSwapCallback.sol';
import {IOtterSwapPool} from '../interfaces/IOtterSwapPool.sol';

contract OtterSwapPoolSwapTest is IOtterSwapSwapCallback {
    int256 private _amount0Delta;
    int256 private _amount1Delta;

    function getSwapResult(
        address pool,
        bool zeroForOne,
        int256 amountSpecified,
        uint160 sqrtPriceLimitX96
    )
        external
        returns (
            int256 amount0Delta,
            int256 amount1Delta,
            uint160 nextSqrtRatio
        )
    {
        (amount0Delta, amount1Delta) = IOtterSwapPool(pool).swap(
            address(0),
            zeroForOne,
            amountSpecified,
            sqrtPriceLimitX96,
            abi.encode(msg.sender)
        );

        (nextSqrtRatio, , , , , , ) = IOtterSwapPool(pool).slot0();
    }

    function otterswapSwapCallback(
        int256 amount0Delta,
        int256 amount1Delta,
        bytes calldata data
    ) external override {
        address sender = abi.decode(data, (address));

        if (amount0Delta > 0) {
            IERC20Minimal(IOtterSwapPool(msg.sender).token0()).transferFrom(sender, msg.sender, uint256(amount0Delta));
        } else if (amount1Delta > 0) {
            IERC20Minimal(IOtterSwapPool(msg.sender).token1()).transferFrom(sender, msg.sender, uint256(amount1Delta));
        }
    }
}
