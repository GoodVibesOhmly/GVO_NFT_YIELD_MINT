// SPDX-License-Identifier: MIT

// SmartWalletBase.sol -- Charged Particles
// Copyright (c) 2019, 2020 Rob Secord <robsecord.eth>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

pragma solidity >=0.6.0;

import "../interfaces/ISmartWallet.sol";

/**
 * @notice ERC20-Token Smart-Wallet Bridge to Bloom
 * @dev Non-upgradeable Contract
 */
abstract contract SmartWalletBase is ISmartWallet {

  uint256 constant internal PERCENTAGE_SCALE = 1e4;  // 10000  (100%)

  address internal nftCreator;
  uint256 internal nftCreatorAnnuityPct;

  address internal _walletManager;

  // List of Asset Tokens held in Wallet
  address[] internal _assetTokens;

  //   Asset Token => Interest Token
  mapping (address => address) internal _assetToInterestToken;


  /***********************************|
  |          Initialization           |
  |__________________________________*/

  function initializeBase() public {
    _walletManager = msg.sender;
  }


  /***********************************|
  |              Public               |
  |__________________________________*/

  function getAssetTokenCount() external view virtual override returns (uint256) {
    return _assetTokens.length;
  }

  function getAssetTokenByIndex(uint256 index) external view virtual override returns (address) {
    if (index >= _assetTokens.length) {
      return address(0);
    }
    return _assetTokens[index];
  }

  function getInterestTokenOfAsset(address assetToken) external view virtual override returns (address) {
    return _assetToInterestToken[assetToken];
  }

  function setNftCreator(address creator, uint256 annuityPct) external virtual override onlyWalletManager {
    nftCreator = creator;
    nftCreatorAnnuityPct = annuityPct;
  }

  function withdrawEther(address payable receiver, uint256 amount) external virtual override onlyWalletManager {
    receiver.transfer(amount);
  }

  function executeForAccount(
    address contractAddress,
    uint256 ethValue,
    bytes memory encodedParams
  )
    external
    override
    onlyWalletManager
    returns (bytes memory)
  {
    (bool success, bytes memory result) = contractAddress.call{value: ethValue}(encodedParams);
    require(success, string(result));
    return result;
  }

  /***********************************|
  |         Private Functions         |
  |__________________________________*/

  function _addAssetToken(address assetToken, address interestToken) internal virtual {
    if (_assetToInterestToken[assetToken] == address(0x0)) {
      _assetTokens.push(assetToken);
      _assetToInterestToken[assetToken] = interestToken;
    }
  }

  /***********************************|
  |             Modifiers             |
  |__________________________________*/

  /// @dev Throws if called by any account other than the wallet manager
  modifier onlyWalletManager() {
    require(_walletManager == msg.sender, "SmartWalletBase: ONLY_WALLET_MGR");
    _;
  }
}