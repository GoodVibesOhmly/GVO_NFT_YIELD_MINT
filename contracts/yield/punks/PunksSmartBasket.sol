// SPDX-License-Identifier: MIT

// GenericSmartWallet.sol -- Part of the Charged Particles Protocol
// Copyright (c) 2021 Firma Lux, Inc. <https://charged.fi>
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

pragma solidity 0.6.12;



import "@openzeppelin/contracts/utils/EnumerableSet.sol";
import "../../interfaces/ISmartBasket.sol";
import "../../lib/BlackholePrevention.sol";
import "../../lib/NftTokenType.sol";

import "../../interfaces/ICryptoPunksBridge.sol";

/**
 * @notice Generic ERC721-Token Smart-Basket
 * @dev Non-upgradeable Contract
 */
contract PunksSmartBasket is ISmartBasket, BlackholePrevention {
  using EnumerableSet for EnumerableSet.UintSet;
  using EnumerableSet for EnumerableSet.AddressSet;
  using NftTokenType for address;

  address internal _basketManager;

  ICryptoPunksBridge internal _bridge;

  // NFT contract address => Token Ids in Basket
  mapping (address => mapping(uint256 => EnumerableSet.UintSet)) internal _nftContractTokens;


  /***********************************|
  |          Initialization           |
  |__________________________________*/

  function initialize() public {
    require(_basketManager == address(0x0), "PSB:E-002");
    _basketManager = msg.sender;
  }


  /***********************************|
  |              Public               |
  |__________________________________*/

  function getTokenCountByType(address contractAddress, uint256) external view override returns (uint256) {
    return _nftContractTokens[contractAddress][0].length();
  }

  function addToBasket(address contractAddress, uint256 tokenId)
    external
    override
    onlyBasketManager
    returns (bool)
  {
    uint256 nftType = contractAddress.getTokenType(tokenId);
    require(!_nftContractTokens[contractAddress][nftType].contains(tokenId), "PSB:E-425");

    bool added = _nftContractTokens[contractAddress][nftType].add(tokenId);
    if (added) {
      // NFT should have been Transferred into here via Charged-Particles
      added = (IERC721(contractAddress).ownerOf(tokenId) == address(this));
    }
    return added;
  }

  function removeFromBasket(address receiver, address contractAddress, uint256 tokenId)
    external
    override
    onlyBasketManager
    returns (bool)
  {
    uint256 nftType = contractAddress.getTokenType(tokenId);
    require(_nftContractTokens[contractAddress][nftType].contains(tokenId), "PSB:E-426");

    bool removed = _nftContractTokens[contractAddress][nftType].remove(tokenId);
    if (removed) {
      IERC721(contractAddress).safeTransferFrom(address(this), receiver, tokenId);
    }
    return removed;
  }

  function executeForAccount(
    address contractAddress,
    uint256 ethValue,
    bytes memory encodedParams
  )
    external
    override
    onlyBasketManager
    returns (bytes memory)
  {
    (bool success, bytes memory result) = contractAddress.call{value: ethValue}(encodedParams);
    require(success, string(result));
    return result;
  }


  /***********************************|
  |          Only Admin/DAO           |
  |      (blackhole prevention)       |
  |__________________________________*/

  function withdrawEther(address payable receiver, uint256 amount) external virtual override onlyBasketManager {
    _withdrawEther(receiver, amount);
  }

  function withdrawERC20(address payable receiver, address tokenAddress, uint256 amount) external virtual override onlyBasketManager {
    _withdrawERC20(receiver, tokenAddress, amount);
  }

  function withdrawERC721(address payable receiver, address tokenAddress, uint256 tokenId) external virtual override onlyBasketManager {
    _withdrawERC721(receiver, tokenAddress, tokenId);
  }


  /***********************************|
  |         Private Functions         |
  |__________________________________*/

  /// @dev Throws if called by any account other than the basket manager
  modifier onlyBasketManager() {
    require(_basketManager == msg.sender, "PSB:E-109");
    _;
  }
}