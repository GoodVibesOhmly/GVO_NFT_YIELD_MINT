const {
  chainNameById,
  chainIdByName,
  getDeployData,
  log,
  toBN,
  toWei,
} = require("../js-helpers/deploy");

const _ = require('lodash');

const SingularityCollection = [
  'https://ipfs.io/ipfs/QmScSSJ8HdKr13qkPHHgM7UMbbsLMRjLt2TRY8nQ97qCrL',
  'https://ipfs.io/ipfs/QmUYDhtnhjJXH5yPzYhEqg7SuQ4W7HwaHFMVUQxSq41dtq',
  'https://ipfs.io/ipfs/QmWc1upvg4C4wSiSu1ry72Lw2smGsEptq73vV5hNk84MR9',
  'https://ipfs.io/ipfs/QmPUoAULoodhy2uipiCZbT4YcMwCJX7jEK9wM8V2A7JXxu',
  'https://ipfs.io/ipfs/QmVT2TvPjznpoNAgRhvzR5paH9rGqZ9kskM7iqK3oVDqAi',

  // 'https://ipfs.io/ipfs/QmNkRS2kXSoquxBzMjAAzAim5MkBmdWapiqMDUx7Ycfev7',
  // 'https://ipfs.io/ipfs/QmWzSAsvMQtrsGua7Bv9VrnjhYzPVQb2tQD82s3nBBL6c5',
  // 'https://ipfs.io/ipfs/QmW9CyctFiLPS4jVYMsphCse39WSzBNMjBqS2nbiUpbQPh',
  // 'https://ipfs.io/ipfs/QmYYz36gkueJjy7LxogPq7Uh2ZyoqByPv6cCypKktVWJ7H',
  // 'https://ipfs.io/ipfs/QmafjdCLdTeXsMUX85fvWAkwcMcNbRdsd2HHysWZVP7TpC',

  // 'https://ipfs.io/ipfs/QmaL5CjZABwLX9L6yXdvHFox7fYFdZGvyDFKuLZssw1Ypo',
  // 'https://ipfs.io/ipfs/QmSeE4icQQte3DPgJsLuHstRocTJSD5vQHNbsrDX3U5wSC',
  // 'https://ipfs.io/ipfs/QmcJX9VWqdeAMq8FJTzS2o2WdRXqGciYHjVk9hL4DC2q85',
  // 'https://ipfs.io/ipfs/QmWAtrv5gvgRGc5u2nqFctgTUU7DgWxnHUXB8Az5HBbyvc',
  // 'https://ipfs.io/ipfs/QmatHa7y7JzBUBYnozCAqXyPaoT5bvWZckHqEMfpdEBgy5',

  // 'https://ipfs.io/ipfs/Qmexdm7Y7WkymGfJAVdF4Ex3TLXhsRGzb6cN8ug9mxKJ4K',
  // 'https://ipfs.io/ipfs/QmcXaXc54txJU8V8u7a3h7dpwDGxbFy6px9FKvdsTqLBvP',
  // 'https://ipfs.io/ipfs/QmUSw99dH3LikLHYBaWnQm9NGXzJkqkBqvfXK2hscPmb8p',
  // 'https://ipfs.io/ipfs/Qme4EazsTrRiGY6HtUJpTCJyePkLgU8xcC3qwiiHB9wfLn',
  // 'https://ipfs.io/ipfs/QmRchzHj74k4virx3WXgoNNJTTYSPhGqQ69LHk4dj1fnqV',
];
const SingularityPrices = [
  toWei('69'),
  toWei('30'),
  toWei('21'),
  toWei('11'),
  toWei('5.5'),

  // toWei('5'),
  // toWei('4'),
  // toWei('3'),
  // toWei('2'),
  // toWei('1'),

  // toWei('1'),
  // toWei('2'),
  // toWei('3'),
  // toWei('2'),
  // toWei('1'),

  // toWei('0.9'),
  // toWei('0.825'),
  // toWei('0.75'),
  // toWei('0.675'),
  // toWei('0.5'),
];

module.exports = async (hre) => {
    const { ethers, getNamedAccounts } = hre;
    const { deployer, initialMinter } = await getNamedAccounts();
    const network = await hre.network;

    const chainId = chainIdByName(network.name);
    const alchemyTimeout = chainId === 31337 ? 0 : (chainId === 1 ? 10 : 7);

    const ddProton = getDeployData('Proton', chainId);

    log('\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    log('Charged Particles: Mint Proton Tokens ');
    log('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n');

    log('  Using Network: ', chainNameById(chainId));
    log('  Using Accounts:');
    log('  - For Creator:     ', initialMinter);
    log(' ');

    log('  Loading Proton from: ', ddProton.address);
    const Proton = await ethers.getContractFactory('Proton');
    const proton = await Proton.attach(ddProton.address);

    await proton.batchProtonsForSale(
      initialMinter,
      toBN('500'),
      toBN('1000'),
      SingularityCollection,
      SingularityPrices,
    );

    log('\n  Proton Minting Complete!');
    log('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n');
}

module.exports.tags = ['mint-protons']