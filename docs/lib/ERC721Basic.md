## `ERC721Basic`



see https://eips.ethereum.org/EIPS/eip-721


### `constructor(string name, string symbol)` (public)



Initializes the contract by setting a `name` and a `symbol` to the token collection.

### `balanceOf(address owner) → uint256` (public)



See {IERC721-balanceOf}.

### `ownerOf(uint256 tokenId) → address` (public)



See {IERC721-ownerOf}.

### `name() → string` (public)



See {IERC721Metadata-name}.

### `symbol() → string` (public)



See {IERC721Metadata-symbol}.

### `tokenURI(uint256) → string` (public)



See {IERC721Metadata-tokenURI}.

### `approve(address to, uint256 tokenId)` (public)



See {IERC721-approve}.

### `getApproved(uint256 tokenId) → address` (public)



See {IERC721-getApproved}.

### `setApprovalForAll(address operator, bool approved)` (public)



See {IERC721-setApprovalForAll}.

### `isApprovedForAll(address owner, address operator) → bool` (public)



See {IERC721-isApprovedForAll}.

### `transferFrom(address from, address to, uint256 tokenId)` (public)



See {IERC721-transferFrom}.

### `safeTransferFrom(address from, address to, uint256 tokenId)` (public)



See {IERC721-safeTransferFrom}.

### `safeTransferFrom(address from, address to, uint256 tokenId, bytes _data)` (public)



See {IERC721-safeTransferFrom}.

### `_safeTransfer(address from, address to, uint256 tokenId, bytes _data)` (internal)



Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
are aware of the ERC721 protocol to prevent tokens from being forever locked.

`_data` is additional data, it has no specified format and it is sent in call to `to`.

This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
implement alternative mecanisms to perform token transfer, such as signature-based.

Requirements:

- `from` cannot be the zero address.
- `to` cannot be the zero address.
- `tokenId` token must exist and be owned by `from`.
- If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.

Emits a {Transfer} event.

### `_exists(uint256 tokenId) → bool` (internal)



Returns whether `tokenId` exists.

Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.

Tokens start existing when they are minted (`_mint`),
and stop existing when they are burned (`_burn`).

### `_isApprovedOrOwner(address spender, uint256 tokenId) → bool` (internal)



Returns whether `spender` is allowed to manage `tokenId`.

Requirements:

- `tokenId` must exist.

### `_safeMint(address to, bytes _data) → uint256` (internal)



Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
forwarded in {IERC721Receiver-onERC721Received} to contract recipients.

### `_safeMintBatch(address to, uint256 count, bytes _data)` (internal)



Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
forwarded in {IERC721Receiver-onERC721Received} to contract recipients.

### `_mint(address to) → uint256` (internal)



Mints `tokenId` and transfers it to `to`.

WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible

Requirements:

- `tokenId` must not exist.
- `to` cannot be the zero address.

Emits a {Transfer} event.

### `_mintBatch(address to, uint256 count) → uint256` (internal)



Mints `tokenId` and transfers it to `to`.

WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible

Requirements:

- `tokenId` must not exist.
- `to` cannot be the zero address.

Emits a {Transfer} event.

### `_transfer(address from, address to, uint256 tokenId)` (internal)



Transfers `tokenId` from `from` to `to`.
 As opposed to {transferFrom}, this imposes no restrictions on msg.sender.

Requirements:

- `to` cannot be the zero address.
- `tokenId` token must be owned by `from`.

Emits a {Transfer} event.

### `_checkOnERC721Received(address from, address to, uint256 tokenId, bytes _data) → bool` (internal)



Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
The call is not executed if the target address is not a contract.



### `_approve(address to, uint256 tokenId)` (internal)





