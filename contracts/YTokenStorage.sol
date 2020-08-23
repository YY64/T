/* SPDX-License-Identifier: LGPL-3.0-or-later */
pragma solidity ^0.6.10;

import "./math/Exponential.sol";

/**
 * @title YTokenInterface
 * @author Mainframe
 */
abstract contract YTokenStorage is Exponential {
    /*** Structs ***/
    struct Vault {
        uint256 debt;
        uint256 freeCollateral;
        uint256 lockedCollateral;
        bool isOpen;
    }

    /*** Storage Properties ***/

    /**
     * @notice Indicator that this is a YToken contract, for inspection.
     */
    bool public constant isYToken = true;
    /**
     * @notice The address of the fintroller contract.
     */
    address public fintroller;

    /**
     * @notice Unix timestamp in seconds for when this token expires.
     */
    uint256 public expirationTime;

    /**
     * @notice The pool into which Guarantors of this YToken deposit their capital.
     */
    address public guarantorPool;

    /**
     * @notice ...
     */
    mapping(address => Vault) internal vaults;
}
