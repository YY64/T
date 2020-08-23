/* SPDX-License-Identifier: LGPL-3.0-or-later */
pragma solidity ^0.6.10;

import "./YTokenStorage.sol";

/**
 * @title YTokenInterface
 * @author Mainframe
 */
abstract contract YTokenInterface is YTokenStorage {
    /*** Non-Constant Functions ***/
    function freeCollateral(uint256 collateralAmount) external virtual returns (bool);

    function setVaultDebt(uint256 debt) external virtual;

    function setVaultOpen(bool state) external virtual;

    function setLockedCollateral(uint256 lockedCollateral) external virtual;

    /*** Events ***/
    event FreeCollateral(address indexed user, uint256 collateralAmount);
}
