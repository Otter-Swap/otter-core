// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.12;

import {IOtterSwapPoolDeployer} from '../interfaces/IOtterSwapPoolDeployer.sol';

import {MockTimeOtterSwapPool} from './MockTimeOtterSwapPool.sol';

contract MockTimeOtterSwapPoolDeployer is IOtterSwapPoolDeployer {
    struct Parameters {
        address factory;
        address token0;
        address token1;
        uint24 fee;
        int24 tickSpacing;
    }

    Parameters public override parameters;

    event PoolDeployed(address pool);

    function deploy(
        address factory,
        address token0,
        address token1,
        uint24 fee,
        int24 tickSpacing
    ) external returns (address pool) {
        parameters = Parameters({factory: factory, token0: token0, token1: token1, fee: fee, tickSpacing: tickSpacing});
        pool = address(
            new MockTimeOtterSwapPool{salt: keccak256(abi.encodePacked(token0, token1, fee, tickSpacing))}()
        );
        emit PoolDeployed(pool);
        delete parameters;
    }
}
