// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.5.0;

import {IOtterSwapPoolImmutables} from './pool/IOtterSwapPoolImmutables.sol';
import {IOtterSwapPoolState} from './pool/IOtterSwapPoolState.sol';
import {IOtterSwapPoolDerivedState} from './pool/IOtterSwapPoolDerivedState.sol';
import {IOtterSwapPoolActions} from './pool/IOtterSwapPoolActions.sol';
import {IOtterSwapPoolOwnerActions} from './pool/IOtterSwapPoolOwnerActions.sol';
import {IOtterSwapPoolErrors} from './pool/IOtterSwapPoolErrors.sol';
import {IOtterSwapPoolEvents} from './pool/IOtterSwapPoolEvents.sol';

/// @title The interface for a OtterSwapPool
/// @notice A OtterSwap pool facilitates swapping and automated market making between any two assets that strictly conform
/// to the ERC20 specification
/// @dev The pool interface is broken up into many smaller pieces
interface IOtterSwapPool is
    IOtterSwapPoolImmutables,
    IOtterSwapPoolState,
    IOtterSwapPoolDerivedState,
    IOtterSwapPoolActions,
    IOtterSwapPoolOwnerActions,
    IOtterSwapPoolErrors,
    IOtterSwapPoolEvents
{

}
