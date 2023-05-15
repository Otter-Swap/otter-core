// SPDX-License-Identifier: BUSL-1.1
pragma solidity =0.8.12;

import {IOtterSwapPoolDeployer} from './interfaces/IOtterSwapPoolDeployer.sol';

import {OtterSwapPool} from './OtterSwapPool.sol';

contract OtterSwapPoolDeployer is IOtterSwapPoolDeployer {
    struct Parameters {
        address factory;
        address token0;
        address token1;
        uint24 fee;
        int24 tickSpacing;
    }

    /// @inheritdoc IOtterSwapPoolDeployer
    Parameters public override parameters;

    /// @dev Deploys a pool with the given parameters by transiently setting the parameters storage slot and then
    /// clearing it after deploying the pool.
    /// @param factory The contract address of the OtterSwapfactory
    /// @param token0 The first token of the pool by address sort order
    /// @param token1 The second token of the pool by address sort order
    /// @param fee The fee collected upon every swap in the pool, denominated in hundredths of a bip
    /// @param tickSpacing The spacing between usable ticks
    function deploy(
        address factory,
        address token0,
        address token1,
        uint24 fee,
        int24 tickSpacing
    ) internal returns (address pool) {
        parameters = Parameters({factory: factory, token0: token0, token1: token1, fee: fee, tickSpacing: tickSpacing});
        pool = address(new OtterSwapPool{salt: keccak256(abi.encode(token0, token1, fee))}());
        delete parameters;
    }
}
