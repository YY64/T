import { BigNumber } from "@ethersproject/bignumber";

export const OneToken: BigNumber = BigNumber.from("1000000000000000000");

export function shouldBehaveLikeYToken(): void {
  it("shows the console.log bug", async function () {
    await this.yToken.setVaultOpen(true);
    /* Collateral is in ETH */
    await this.yToken.setLockedCollateral(OneToken.mul(10));
    /* Debt is in DAI */
    await this.yToken.setVaultDebt(OneToken.mul(100));
    /* Freeing 1 ETH out of 10 ETH */
    await this.yToken.freeCollateral(OneToken);
  });
}
