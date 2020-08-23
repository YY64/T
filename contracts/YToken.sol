/* SPDX-License-Identifier: MIT */
pragma solidity ^0.6.10;

import "@nomiclabs/buidler/console.sol";
import "./YTokenInterface.sol";

contract YToken is YTokenInterface {
    modifier isVaultOpen() {
        require(vaults[msg.sender].isOpen, "ERR_VAULT_NOT_OPEN");
        _;
    }

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        address fintroller_,
        address underlying_,
        address collateral_,
        address guarantorPool_,
        uint256 expirationTime_
    ) public {
        fintroller = fintroller_;

        /* Set the guarantor pool. */
        guarantorPool = guarantorPool_;

        /* Set the expiration time. */
        expirationTime = expirationTime_;
    }

    function setVaultDebt(uint256 debt) external override {
        vaults[msg.sender].debt = debt;
    }

    function setVaultOpen(bool state) external override {
        vaults[msg.sender].isOpen = true;
    }

    function setLockedCollateral(uint256 lockedCollateral) external override {
        vaults[msg.sender].lockedCollateral = lockedCollateral;
    }

    struct FreeCollateralLocalVars {
        MathError mathErr;
        uint256 collateralizationRatioMantissa;
        Exp newCollateralizationRatio;
        uint256 newFreeCollateral;
        uint256 newLockedCollateral;
    }

    function freeCollateral(uint256 collateralAmount) external override isVaultOpen returns (bool) {
        Vault memory vault = vaults[msg.sender];
        require(vault.lockedCollateral >= collateralAmount, "ERR_FREE_COLLATERAL_INSUFFICIENT_LOCKED_COLLATERAL");

        FreeCollateralLocalVars memory vars;

        /* This operation can't fail because of the first `require` in this function. */
        (vars.mathErr, vars.newLockedCollateral) = subUInt(vault.lockedCollateral, collateralAmount);
        assert(vars.mathErr == MathError.NO_ERROR);
        vaults[msg.sender].lockedCollateral = vars.newLockedCollateral;

        /* Comment this "if" block to silence the bug */
        if (vaults[msg.sender].debt > 0) {
            /* This operation can't fail because both operands are non-zero. */
            (vars.mathErr, vars.newCollateralizationRatio) = divExp(
                Exp({ mantissa: vars.newLockedCollateral }),
                Exp({ mantissa: vaults[msg.sender].debt })
            );
            assert(vars.mathErr == MathError.NO_ERROR);

            // (vars.collateralizationRatioMantissa) = fintroller.getBond(address(this));
            console.log("vars.newLockedCollateral: %d", vars.newLockedCollateral);
            require(
                vars.newCollateralizationRatio.mantissa >= vars.collateralizationRatioMantissa,
                "ERR_BELOW_COLLATERALIZATION_RATIO"
            );
        }

        (vars.mathErr, vars.newFreeCollateral) = addUInt(vault.freeCollateral, collateralAmount);
        require(vars.mathErr == MathError.NO_ERROR, "ERR_FREE_COLLATERAL_MATH_ERROR");
        vaults[msg.sender].freeCollateral = vars.newFreeCollateral;

        emit FreeCollateral(msg.sender, collateralAmount);
        return true;
    }
}
