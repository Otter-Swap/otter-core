// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.12;

import {TickMath} from '../libraries/TickMath.sol';

import {IOtterSwapSwapCallback} from '../interfaces/callback/IOtterSwapSwapCallback.sol';

import {IOtterSwapPool} from '../interfaces/IOtterSwapPool.sol';

contract TestOtterSwapReentrantCallee is IOtterSwapSwapCallback {
    string private constant expectedError = 'LOK()';

    function swapToReenter(address pool) external {
        IOtterSwapPool(pool).swap(address(0), false, 1, TickMath.MAX_SQRT_RATIO - 1, new bytes(0));
    }

    function otterswapSwapCallback(
        int256,
        int256,
        bytes calldata
    ) external override {
        // try to reenter swap
        try IOtterSwapPool(msg.sender).swap(address(0), false, 1, 0, new bytes(0)) {} catch (bytes memory error) {
            require(keccak256(error) == keccak256(abi.encodeWithSignature(expectedError)));
        }

        // try to reenter mint
        try IOtterSwapPool(msg.sender).mint(address(0), 0, 0, 0, new bytes(0)) {} catch (bytes memory error) {
            require(keccak256(error) == keccak256(abi.encodeWithSignature(expectedError)));
        }

        // try to reenter collect
        try IOtterSwapPool(msg.sender).collect(address(0), 0, 0, 0, 0) {} catch (bytes memory error) {
            require(keccak256(error) == keccak256(abi.encodeWithSignature(expectedError)));
        }

        // try to reenter burn
        try IOtterSwapPool(msg.sender).burn(0, 0, 0) {} catch (bytes memory error) {
            require(keccak256(error) == keccak256(abi.encodeWithSignature(expectedError)));
        }

        // try to reenter flash
        try IOtterSwapPool(msg.sender).flash(address(0), 0, 0, new bytes(0)) {} catch (bytes memory error) {
            require(keccak256(error) == keccak256(abi.encodeWithSignature(expectedError)));
        }

        // try to reenter collectProtocol
        try IOtterSwapPool(msg.sender).collectProtocol(address(0), 0, 0) {} catch (bytes memory error) {
            require(keccak256(error) == keccak256(abi.encodeWithSignature(expectedError)));
        }

        require(false, 'Unable to reenter');
    }
}
