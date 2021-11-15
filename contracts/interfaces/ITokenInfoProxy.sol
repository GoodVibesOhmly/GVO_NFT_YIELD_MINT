// SPDX-License-Identifier: MIT

// TokenInfoProxy.sol -- Part of the Charged Particles Protocol
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


interface ITokenInfoProxy {

  event ContractFunctionSignatureSet(address indexed contractAddress, string fnName, bytes4 fnSig);

  struct FnSignatures {
    bytes4 ownerOf;
    bytes4 creatorOf;
    bytes4 collectOverride;
    bytes4 depositOverride;
  }

  function setContractFnOwnerOf(address contractAddress, bytes4 fnSig) external;
  function setContractFnCreatorOf(address contractAddress, bytes4 fnSig) external;
  function setContractFnCollectOverride(address contractAddress, bytes4 fnSig) external;
  function setContractFnDepositOverride(address contractAddress, bytes4 fnSig) external;

  function getTokenUUID(address contractAddress, uint256 tokenId) external pure returns (uint256);
  function isNFTOwnerOrOperator(address contractAddress, uint256 tokenId, address sender) external returns (bool);
  function getTokenOwner(address contractAddress, uint256 tokenId) external returns (address);
  function getTokenCreator(address contractAddress, uint256 tokenId) external returns (address);

  function getCollectOverrideFnSig(address contractAddress) external view returns (bytes4);
  function getDepositOverrideFnSig(address contractAddress) external view returns (bytes4);
}