import { BigNumber } from 'ethers'
import { ethers } from 'hardhat'
import { MockTimeOtterSwapPool } from '../../typechain/MockTimeOtterSwapPool'
import { TestERC20 } from '../../typechain/TestERC20'
import { OtterSwapFactory } from '../../typechain/OtterSwapFactory'
import { TestOtterSwapCallee } from '../../typechain/TestOtterSwapCallee'
import { TestOtterSwapRouter } from '../../typechain/TestOtterSwapRouter'
import { MockTimeOtterSwapPoolDeployer } from '../../typechain/MockTimeOtterSwapPoolDeployer'

import { Fixture } from 'ethereum-waffle'

interface FactoryFixture {
  factory: OtterSwapFactory
}

async function factoryFixture(): Promise<FactoryFixture> {
  const factoryFactory = await ethers.getContractFactory('OtterSwapFactory')
  const factory = (await factoryFactory.deploy()) as OtterSwapFactory
  return { factory }
}

interface TokensFixture {
  token0: TestERC20
  token1: TestERC20
  token2: TestERC20
}

async function tokensFixture(): Promise<TokensFixture> {
  const tokenFactory = await ethers.getContractFactory('TestERC20')
  const tokenA = (await tokenFactory.deploy(BigNumber.from(2).pow(255))) as TestERC20
  const tokenB = (await tokenFactory.deploy(BigNumber.from(2).pow(255))) as TestERC20
  const tokenC = (await tokenFactory.deploy(BigNumber.from(2).pow(255))) as TestERC20

  const [token0, token1, token2] = [tokenA, tokenB, tokenC].sort((tokenA, tokenB) =>
    tokenA.address.toLowerCase() < tokenB.address.toLowerCase() ? -1 : 1
  )

  return { token0, token1, token2 }
}

type TokensAndFactoryFixture = FactoryFixture & TokensFixture

interface PoolFixture extends TokensAndFactoryFixture {
  swapTargetCallee: TestOtterSwapCallee
  swapTargetRouter: TestOtterSwapRouter
  createPool(
    fee: number,
    tickSpacing: number,
    firstToken?: TestERC20,
    secondToken?: TestERC20
  ): Promise<MockTimeOtterSwapPool>
}

// Monday, October 5, 2020 9:00:00 AM GMT-05:00
export const TEST_POOL_START_TIME = 1601906400

export const poolFixture: Fixture<PoolFixture> = async function (): Promise<PoolFixture> {
  const { factory } = await factoryFixture()
  const { token0, token1, token2 } = await tokensFixture()

  const MockTimeOtterSwapPoolDeployerFactory = await ethers.getContractFactory('MockTimeOtterSwapPoolDeployer')
  const MockTimeOtterSwapPoolFactory = await ethers.getContractFactory('MockTimeOtterSwapPool')

  const calleeContractFactory = await ethers.getContractFactory('TestOtterSwapCallee')
  const routerContractFactory = await ethers.getContractFactory('TestOtterSwapRouter')

  const swapTargetCallee = (await calleeContractFactory.deploy()) as TestOtterSwapCallee
  const swapTargetRouter = (await routerContractFactory.deploy()) as TestOtterSwapRouter

  return {
    token0,
    token1,
    token2,
    factory,
    swapTargetCallee,
    swapTargetRouter,
    createPool: async (fee, tickSpacing, firstToken = token0, secondToken = token1) => {
      const mockTimePoolDeployer =
        (await MockTimeOtterSwapPoolDeployerFactory.deploy()) as MockTimeOtterSwapPoolDeployer
      const tx = await mockTimePoolDeployer.deploy(
        factory.address,
        firstToken.address,
        secondToken.address,
        fee,
        tickSpacing
      )

      const receipt = await tx.wait()
      const poolAddress = receipt.events?.[0].args?.pool as string
      return MockTimeOtterSwapPoolFactory.attach(poolAddress) as MockTimeOtterSwapPool
    },
  }
}
