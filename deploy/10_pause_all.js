const {
  chainNameById,
  chainIdByName,
  getDeployData,
  log,
} = require("../js-helpers/deploy");

const _ = require('lodash');

const _PAUSED_STATE = true;
const _ACTION = _PAUSED_STATE ? 'Pausing' : 'Unpausing';

module.exports = async (hre) => {
  const { ethers, getNamedAccounts } = hre;
  const { deployer, owner } = await getNamedAccounts();
  const network = await hre.network;

  const chainId = chainIdByName(network.name);
  const alchemyTimeout = chainId === 31337 ? 0 : (chainId === 1 ? 1 : 3);

  if (chainId !== 1) { return; } // Mainnet only

  const ddGenericWalletManager = getDeployData('GenericWalletManager', chainId);
  const ddGenericBasketManager = getDeployData('GenericBasketManager', chainId);
  const ddAaveWalletManager = getDeployData('AaveWalletManager', chainId);
  const ddCompoundWalletManager = getDeployData('CompoundWalletManager', chainId);
  const ddProton = getDeployData('Proton', chainId);
  const ddLepton = getDeployData('Lepton', chainId);

  log('\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
  log('Charged Particles: Pause All Contracts');
  log('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n');

  log('  Using Network: ', chainNameById(chainId));
  log('  Using Accounts:');
  log('  - Deployer:    ', deployer);
  log('  - Owner:       ', owner);
  log(' ');

  log('  Loading GenericWalletManager from: ', ddGenericWalletManager.address);
  const GenericWalletManager = await ethers.getContractFactory('GenericWalletManager');
  const genericWalletManager = await GenericWalletManager.attach(ddGenericWalletManager.address);

  log('  Loading GenericBasketManager from: ', ddGenericBasketManager.address);
  const GenericBasketManager = await ethers.getContractFactory('GenericBasketManager');
  const genericBasketManager = await GenericBasketManager.attach(ddGenericBasketManager.address);

  log('  Loading AaveWalletManager from: ', ddAaveWalletManager.address);
  const AaveWalletManager = await ethers.getContractFactory('AaveWalletManager');
  const aaveWalletManager = await AaveWalletManager.attach(ddAaveWalletManager.address);

  log('  Loading CompoundWalletManager from: ', ddCompoundWalletManager.address);
  const CompoundWalletManager = await ethers.getContractFactory('CompoundWalletManager');
  const compoundWalletManager = await CompoundWalletManager.attach(ddCompoundWalletManager.address);

  log('  Loading Proton from: ', ddProton.address);
  const Proton = await ethers.getContractFactory('Proton');
  const proton = await Proton.attach(ddProton.address);

  log('  Loading Lepton from: ', ddLepton.address);
  const Lepton = await ethers.getContractFactory('Lepton');
  const lepton = await Lepton.attach(ddLepton.address);


  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // Set Paused State
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  await log(`  - ${_ACTION} GenericWalletManager...`)(alchemyTimeout);
  await genericWalletManager.setPausedState(_PAUSED_STATE);

  await log(`  - ${_ACTION} GenericBasketManager...`)(alchemyTimeout);
  await genericBasketManager.setPausedState(_PAUSED_STATE);

  await log(`  - ${_ACTION} AaveWalletManager...`)(alchemyTimeout);
  await aaveWalletManager.setPausedState(_PAUSED_STATE);

  await log(`  - ${_ACTION} CompoundWalletManager...`)(alchemyTimeout);
  await compoundWalletManager.setPausedState(_PAUSED_STATE);

  await log(`  - ${_ACTION} Proton...`)(alchemyTimeout);
  await proton.setPausedState(_PAUSED_STATE);

  await log(`  - ${_ACTION} Lepton...`)(alchemyTimeout);
  await lepton.setPausedState(_PAUSED_STATE);


  log('\n  Transaction Execution Complete!');
  log('\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n');
}

module.exports.tags = ['pause-all']