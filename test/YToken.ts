import chai from "chai";
import { Signer } from "@ethersproject/abstract-signer";
import { deployContract, solidity } from "ethereum-waffle";
import { ethers } from "@nomiclabs/buidler";

import YTokenArtifact from "../artifacts/YToken.json";

import { YToken } from "../typechain/YToken";
import { shouldBehaveLikeYToken } from "./YToken.behavior";

chai.use(solidity);

setTimeout(async function () {
  const signers: Signer[] = await ethers.getSigners();
  const admin: Signer = signers[0];

  describe("YToken", function () {
    beforeEach(async function () {
      const fintrollerAddress: string = "0x0000000000000000000000000000000000000001";
      const underlyingAddress: string = "0x0000000000000000000000000000000000000002";
      const collateralAddress: string = "0x0000000000000000000000000000000000000003";
      const guarantorPoolAddress: string = "0x0000000000000000000000000000000000000004";
      const expirationTime: number = 1609459199;
      this.yToken = ((await deployContract(admin, YTokenArtifact, [
        "DAI/ETH (2021-01-01)",
        "yDAI-JAN21",
        18,
        fintrollerAddress,
        underlyingAddress,
        collateralAddress,
        guarantorPoolAddress,
        expirationTime,
      ])) as unknown) as YToken;
    });

    shouldBehaveLikeYToken();
  });

  run();
}, 1000);
