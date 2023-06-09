// Sources flattened with hardhat v2.14.0 https://hardhat.org

// File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.9.0

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}


// File @openzeppelin/contracts/token/ERC1155/IERC1155.sol@v4.9.0

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC1155/IERC1155.sol)

pragma solidity ^0.8.0;

/**
 * @dev Required interface of an ERC1155 compliant contract, as defined in the
 * https://eips.ethereum.org/EIPS/eip-1155[EIP].
 *
 * _Available since v3.1._
 */
interface IERC1155 is IERC165 {
    /**
     * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
     */
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);

    /**
     * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
     * transfers.
     */
    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] values
    );

    /**
     * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
     * `approved`.
     */
    event ApprovalForAll(address indexed account, address indexed operator, bool approved);

    /**
     * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
     *
     * If an {URI} event was emitted for `id`, the standard
     * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
     * returned by {IERC1155MetadataURI-uri}.
     */
    event URI(string value, uint256 indexed id);

    /**
     * @dev Returns the amount of tokens of token type `id` owned by `account`.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function balanceOf(address account, uint256 id) external view returns (uint256);

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
     *
     * Requirements:
     *
     * - `accounts` and `ids` must have the same length.
     */
    function balanceOfBatch(
        address[] calldata accounts,
        uint256[] calldata ids
    ) external view returns (uint256[] memory);

    /**
     * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
     *
     * Emits an {ApprovalForAll} event.
     *
     * Requirements:
     *
     * - `operator` cannot be the caller.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
     *
     * See {setApprovalForAll}.
     */
    function isApprovedForAll(address account, address operator) external view returns (bool);

    /**
     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
     * - `from` must have a balance of tokens of type `id` of at least `amount`.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata data
    ) external;
}


// File @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol@v4.9.0

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
 * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
 *
 * _Available since v3.1._
 */
interface IERC1155MetadataURI is IERC1155 {
    /**
     * @dev Returns the URI for token type `id`.
     *
     * If the `\{id\}` substring is present in the URI, it must be replaced by
     * clients with the actual token type ID.
     */
    function uri(uint256 id) external view returns (string memory);
}


// File @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol@v4.9.0

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)

pragma solidity ^0.8.0;

/**
 * @dev _Available since v3.1._
 */
interface IERC1155Receiver is IERC165 {
    /**
     * @dev Handles the receipt of a single ERC1155 token type. This function is
     * called at the end of a `safeTransferFrom` after the balance has been updated.
     *
     * NOTE: To accept the transfer, this must return
     * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
     * (i.e. 0xf23a6e61, or its own function selector).
     *
     * @param operator The address which initiated the transfer (i.e. msg.sender)
     * @param from The address which previously owned the token
     * @param id The ID of the token being transferred
     * @param value The amount of tokens being transferred
     * @param data Additional data with no specified format
     * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
     */
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4);

    /**
     * @dev Handles the receipt of a multiple ERC1155 token types. This function
     * is called at the end of a `safeBatchTransferFrom` after the balances have
     * been updated.
     *
     * NOTE: To accept the transfer(s), this must return
     * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
     * (i.e. 0xbc197c81, or its own function selector).
     *
     * @param operator The address which initiated the batch transfer (i.e. msg.sender)
     * @param from The address which previously owned the token
     * @param ids An array containing ids of each token being transferred (order and length must match values array)
     * @param values An array containing amounts of each token being transferred (order and length must match ids array)
     * @param data Additional data with no specified format
     * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
     */
    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external returns (bytes4);
}


// File @openzeppelin/contracts/utils/Address.sol@v4.9.0

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)

pragma solidity ^0.8.1;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     *
     * Furthermore, `isContract` will also return true if the target contract within
     * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
     * which only has an effect at the end of a transaction.
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}


// File @openzeppelin/contracts/utils/Context.sol@v4.9.0

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


// File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.9.0

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
 */
abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}


// File @openzeppelin/contracts/token/ERC1155/ERC1155.sol@v4.9.0

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC1155/ERC1155.sol)

pragma solidity ^0.8.0;






/**
 * @dev Implementation of the basic standard multi-token.
 * See https://eips.ethereum.org/EIPS/eip-1155
 * Originally based on code by Enjin: https://github.com/enjin/erc-1155
 *
 * _Available since v3.1._
 */
contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
    using Address for address;

    // Mapping from token ID to account balances
    mapping(uint256 => mapping(address => uint256)) private _balances;

    // Mapping from account to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
    string private _uri;

    /**
     * @dev See {_setURI}.
     */
    constructor(string memory uri_) {
        _setURI(uri_);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC1155).interfaceId ||
            interfaceId == type(IERC1155MetadataURI).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC1155MetadataURI-uri}.
     *
     * This implementation returns the same URI for *all* token types. It relies
     * on the token type ID substitution mechanism
     * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
     *
     * Clients calling this function must replace the `\{id\}` substring with the
     * actual token type ID.
     */
    function uri(uint256) public view virtual override returns (string memory) {
        return _uri;
    }

    /**
     * @dev See {IERC1155-balanceOf}.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
        require(account != address(0), "ERC1155: address zero is not a valid owner");
        return _balances[id][account];
    }

    /**
     * @dev See {IERC1155-balanceOfBatch}.
     *
     * Requirements:
     *
     * - `accounts` and `ids` must have the same length.
     */
    function balanceOfBatch(
        address[] memory accounts,
        uint256[] memory ids
    ) public view virtual override returns (uint256[] memory) {
        require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");

        uint256[] memory batchBalances = new uint256[](accounts.length);

        for (uint256 i = 0; i < accounts.length; ++i) {
            batchBalances[i] = balanceOf(accounts[i], ids[i]);
        }

        return batchBalances;
    }

    /**
     * @dev See {IERC1155-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) public virtual override {
        _setApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {IERC1155-isApprovedForAll}.
     */
    function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[account][operator];
    }

    /**
     * @dev See {IERC1155-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public virtual override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: caller is not token owner or approved"
        );
        _safeTransferFrom(from, to, id, amount, data);
    }

    /**
     * @dev See {IERC1155-safeBatchTransferFrom}.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: caller is not token owner or approved"
        );
        _safeBatchTransferFrom(from, to, ids, amounts, data);
    }

    /**
     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `from` must have a balance of tokens of type `id` of at least `amount`.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
    function _safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) internal virtual {
        require(to != address(0), "ERC1155: transfer to the zero address");

        address operator = _msgSender();
        uint256[] memory ids = _asSingletonArray(id);
        uint256[] memory amounts = _asSingletonArray(amount);

        _beforeTokenTransfer(operator, from, to, ids, amounts, data);

        uint256 fromBalance = _balances[id][from];
        require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
        unchecked {
            _balances[id][from] = fromBalance - amount;
        }
        _balances[id][to] += amount;

        emit TransferSingle(operator, from, to, id, amount);

        _afterTokenTransfer(operator, from, to, ids, amounts, data);

        _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
    }

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
    function _safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {
        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
        require(to != address(0), "ERC1155: transfer to the zero address");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, from, to, ids, amounts, data);

        for (uint256 i = 0; i < ids.length; ++i) {
            uint256 id = ids[i];
            uint256 amount = amounts[i];

            uint256 fromBalance = _balances[id][from];
            require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
            unchecked {
                _balances[id][from] = fromBalance - amount;
            }
            _balances[id][to] += amount;
        }

        emit TransferBatch(operator, from, to, ids, amounts);

        _afterTokenTransfer(operator, from, to, ids, amounts, data);

        _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
    }

    /**
     * @dev Sets a new URI for all token types, by relying on the token type ID
     * substitution mechanism
     * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
     *
     * By this mechanism, any occurrence of the `\{id\}` substring in either the
     * URI or any of the amounts in the JSON file at said URI will be replaced by
     * clients with the token type ID.
     *
     * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
     * interpreted by clients as
     * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
     * for token type ID 0x4cce0.
     *
     * See {uri}.
     *
     * Because these URIs cannot be meaningfully represented by the {URI} event,
     * this function emits no events.
     */
    function _setURI(string memory newuri) internal virtual {
        _uri = newuri;
    }

    /**
     * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
    function _mint(address to, uint256 id, uint256 amount, bytes memory data) internal virtual {
        require(to != address(0), "ERC1155: mint to the zero address");

        address operator = _msgSender();
        uint256[] memory ids = _asSingletonArray(id);
        uint256[] memory amounts = _asSingletonArray(amount);

        _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);

        _balances[id][to] += amount;
        emit TransferSingle(operator, address(0), to, id, amount);

        _afterTokenTransfer(operator, address(0), to, ids, amounts, data);

        _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
    }

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
    function _mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {
        require(to != address(0), "ERC1155: mint to the zero address");
        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);

        for (uint256 i = 0; i < ids.length; i++) {
            _balances[ids[i]][to] += amounts[i];
        }

        emit TransferBatch(operator, address(0), to, ids, amounts);

        _afterTokenTransfer(operator, address(0), to, ids, amounts, data);

        _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
    }

    /**
     * @dev Destroys `amount` tokens of token type `id` from `from`
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `from` must have at least `amount` tokens of token type `id`.
     */
    function _burn(address from, uint256 id, uint256 amount) internal virtual {
        require(from != address(0), "ERC1155: burn from the zero address");

        address operator = _msgSender();
        uint256[] memory ids = _asSingletonArray(id);
        uint256[] memory amounts = _asSingletonArray(amount);

        _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");

        uint256 fromBalance = _balances[id][from];
        require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
        unchecked {
            _balances[id][from] = fromBalance - amount;
        }

        emit TransferSingle(operator, from, address(0), id, amount);

        _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
    }

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     */
    function _burnBatch(address from, uint256[] memory ids, uint256[] memory amounts) internal virtual {
        require(from != address(0), "ERC1155: burn from the zero address");
        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");

        for (uint256 i = 0; i < ids.length; i++) {
            uint256 id = ids[i];
            uint256 amount = amounts[i];

            uint256 fromBalance = _balances[id][from];
            require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
            unchecked {
                _balances[id][from] = fromBalance - amount;
            }
        }

        emit TransferBatch(operator, from, address(0), ids, amounts);

        _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
    }

    /**
     * @dev Approve `operator` to operate on all of `owner` tokens
     *
     * Emits an {ApprovalForAll} event.
     */
    function _setApprovalForAll(address owner, address operator, bool approved) internal virtual {
        require(owner != operator, "ERC1155: setting approval status for self");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    /**
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning, as well as batched variants.
     *
     * The same hook is called on both single and batched variants. For single
     * transfers, the length of the `ids` and `amounts` arrays will be 1.
     *
     * Calling conditions (for each `id` and `amount` pair):
     *
     * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * of token type `id` will be  transferred to `to`.
     * - When `from` is zero, `amount` tokens of token type `id` will be minted
     * for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
     * will be burned.
     * - `from` and `to` are never both zero.
     * - `ids` and `amounts` have the same, non-zero length.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {}

    /**
     * @dev Hook that is called after any token transfer. This includes minting
     * and burning, as well as batched variants.
     *
     * The same hook is called on both single and batched variants. For single
     * transfers, the length of the `id` and `amount` arrays will be 1.
     *
     * Calling conditions (for each `id` and `amount` pair):
     *
     * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * of token type `id` will be  transferred to `to`.
     * - When `from` is zero, `amount` tokens of token type `id` will be minted
     * for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
     * will be burned.
     * - `from` and `to` are never both zero.
     * - `ids` and `amounts` have the same, non-zero length.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {}

    function _doSafeTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) private {
        if (to.isContract()) {
            try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
                if (response != IERC1155Receiver.onERC1155Received.selector) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non-ERC1155Receiver implementer");
            }
        }
    }

    function _doSafeBatchTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) private {
        if (to.isContract()) {
            try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
                bytes4 response
            ) {
                if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non-ERC1155Receiver implementer");
            }
        }
    }

    function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
        uint256[] memory array = new uint256[](1);
        array[0] = element;

        return array;
    }
}


// File contracts/ERC1155Token.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
contract ERC1155Token is ERC1155 {
    string private _uri;
    uint256 public mintAmount;
    address public owner;

    mapping(uint256 => address) private idOwner;

    constructor(string memory uri, uint256 _mintAmount) ERC1155(uri) {
        _uri = uri;
        mintAmount = _mintAmount;
        owner = msg.sender;
    }

    function mint(uint256 tokenId, uint256 numberOfTokens) external payable {
        require(numberOfTokens != 0, "ERC1155Token: Tokens cannot be zero");
        require(
            idOwner[tokenId] == msg.sender || idOwner[tokenId] == address(0),
            "ERC1155Token: token id doesn't match"
        );
        require(
            msg.value == mintAmount * numberOfTokens,
            "ERC1155Token: pay correct amount"
        );
        if (idOwner[tokenId] == address(0)) idOwner[tokenId] = msg.sender;

        _mint(msg.sender, tokenId, numberOfTokens, "");
        payable(owner).transfer(msg.value);
    }

    function mintBatch(
        uint256[] memory tokenIds,
        uint256[] memory numberOfTokens
    ) external payable {
        uint256 numberOfToken1;
        for (uint256 index; index < numberOfTokens.length; index++) {
            numberOfToken1 += numberOfTokens[index];

            require(
                idOwner[tokenIds[index]] == msg.sender ||
                    idOwner[tokenIds[index]] == address(0),
                "ERC1155Token: token id doesn't match"
            );
            if (idOwner[tokenIds[index]] == address(0)) {
                idOwner[tokenIds[index]] = msg.sender;
            }
        }
        require(
            msg.value == mintAmount * numberOfToken1,
            "ERC1155Token: pay correct amount"
        );
        _mintBatch(msg.sender, tokenIds, numberOfTokens, "");
        payable(owner).transfer(msg.value);
    }

    function burn(uint256 tokenId, uint256 numberOfTokens) external {
        require(numberOfTokens != 0, "ERC1155Token: Tokens cannot be zero");
        _burn(msg.sender, tokenId, numberOfTokens);
    }

    function burnBatch(
        uint256[] memory tokenIds,
        uint256[] memory numberOfTokens
    ) external {
        _burnBatch(msg.sender, tokenIds, numberOfTokens);
    }
}


// File contracts/ERC721/IERC721TokenReceiver.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IERC721TokenReceiver
{

  function onERC721Received(
    address _operator,
    address _from,
    uint256 _tokenId,
    bytes calldata _data
  )
    external
    returns(bytes4);

}


// File contracts/ERC721/ERC721Token.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IERC721 {
    function balanceOf(address _owner) external view returns (uint256);

    function ownerOf(uint256 _tokenId) external view returns (address);

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory data
    ) external;

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external;

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external;

    function approve(address _approved, uint256 _tokenId) external;

    function setApprovalForAll(address _operator, bool _approved) external;

    function getApproved(uint256 _tokenId) external view returns (address);

    function isApprovedForAll(
        address _owner,
        address _operator
    ) external view returns (bool);

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );
    event Approval(
        address indexed _owner,
        address indexed _approved,
        uint256 indexed _tokenId
    );
    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );
}

contract ERC721Token is IERC721TokenReceiver, IERC721 {
    uint256 public nextTokenIDMint;
    address public contractOwner;

    //tokenid => owner
    mapping(uint256 => address) owner;

    //owner =>tokenBalance
    mapping(address => uint256) balance;

    //tokenid => approvedAdress
    mapping(uint256 => address) tokenApprovals;

    //owner =>(operator=> true/false)
    mapping(address => mapping(address => bool)) operatorApproval;

    constructor() {
        nextTokenIDMint = 0;
        contractOwner = msg.sender;
    }

    function balanceOf(address _owner) external view returns (uint256) {
        require(_owner != address(0), "ERC721Token: invalid address");
        return balance[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address) {
        return owner[_tokenId];
    }

    function mint(address _to) public {
        require(_to != address(0), "ERC721Token: invalid address");
        owner[nextTokenIDMint] = _to;
        balance[_to] += 1;
        nextTokenIDMint += 1;
        emit Transfer(address(0), _to, nextTokenIDMint);
    }

    function burn(uint256 _tokenId) public {
        require(
            ownerOf(_tokenId) == msg.sender,
            "ERC721Token: You're not the token owner"
        );

        balance[msg.sender] -= 1;
        nextTokenIDMint -= 1;
        emit Transfer(msg.sender, address(0), _tokenId);
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) public pure returns (bytes4) {
        return
            bytes4(
                keccak256("onERC721Received(address, address, uint256, bytes)")
            );
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external {
        safeTransferFrom(_from, _to, _tokenId, "");
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory _data
    ) public {
        require(
            ownerOf(_tokenId) == msg.sender ||
                tokenApprovals[_tokenId] == msg.sender ||
                operatorApproval[ownerOf(_tokenId)][msg.sender],
            "ERC721Token: token owner doesn't match"
        );
        transfer(_from, _to, _tokenId);

        require(
            _to.code.length == 0 ||
                IERC721TokenReceiver(_to).onERC721Received(
                    msg.sender,
                    _from,
                    _tokenId,
                    _data
                ) ==
                IERC721TokenReceiver.onERC721Received.selector,
            "ERC721Token: unsafe recepient"
        );
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external {
        require(
            ownerOf(_tokenId) == msg.sender ||
                tokenApprovals[_tokenId] == msg.sender ||
                operatorApproval[ownerOf(_tokenId)][msg.sender],
            "ERC721Token: token owner doesn't match"
        );
        transfer(_from, _to, _tokenId);
    }

    function transfer(address _from, address _to, uint256 _tokenId) internal {
        require(
            ownerOf(_tokenId) == _from,
            "ERC721Token: token owner doesn't match"
        );
        require(_to != address(0), "ERC721Token: unsafe recepient");

        delete tokenApprovals[_tokenId];

        balance[_from] -= 1;
        balance[_to] += 1;
        owner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) external {
        require(
            ownerOf(_tokenId) == msg.sender,
            "ERC721Token: token owner doesn't match"
        );
        tokenApprovals[_tokenId] = _approved;
        emit Approval(ownerOf(_tokenId), _approved, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        operatorApproval[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function getApproved(uint256 _tokenId) external view returns (address) {
        return tokenApprovals[_tokenId];
    }

    function isApprovedForAll(
        address _owner,
        address _operator
    ) external view returns (bool) {
        return operatorApproval[_owner][_operator];
    }
}


// File contracts/MarketPlace/ERC1155Receiver.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IERC1155Receiver {
    function onERC1155Received(
        address operator,
        address from,
        address to,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4);


}


// File contracts/MarketPlace/ERC1155Tokens.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IERC1155Token {
    function balanceOf(address _owner, uint256 _tokenId)
        external
        view
        returns (uint256);
    
     function mint(
        address _to,
        uint256 _tokenId,
        uint256 _amount
    ) external;

    function balanceOfBatch(
        address[] memory _accounts,
        uint256[] memory _tokenIds
    ) external view returns (uint256[] memory);

    function setApprovalForAll(address _operator, bool _approved) external;

    function isApprovedForAll(address _account, address _operator)
        external
        view
        returns (bool);

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _id,
        uint256 _amount,
        bytes memory _data
    ) external;

    function safeBatchTransferFrom(
        address _from,
        address _to,
        uint256[] memory _ids,
        uint256[] memory _amounts,
        bytes memory _data
    ) external;

    event TransferSingle(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 id,
        uint256 value
    );

    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] values
    );

    event ApprovalForAll(
        address indexed account,
        address indexed operator,
        bool approved
    );
}

contract ERC1155Tokens is IERC1155Token, IERC1155Receiver {
    // token id => (address => balance)
    mapping(uint256 => mapping(address => uint256)) internal _balances;
    // owner => (operator => yes/no)
    mapping(address => mapping(address => bool)) internal _operatorApprovals;

    // token id => supply
    mapping(uint256 => uint256) public totalSupply;

    uint256 public nextTokenIdToMint;
    string public name;
    string public symbol;
    address public owner;

    constructor(string memory _name, string memory _symbol) {
        owner = msg.sender;
        name = _name;
        symbol = _symbol;
        nextTokenIdToMint = 0;
    }

    function balanceOf(address _owner, uint256 _tokenId)
        public
        view
        returns (uint256)
    {
        require(_owner != address(0), "ERC1155Token: invalid address");
        return _balances[_tokenId][_owner];
    }

    function balanceOfBatch(
        address[] memory _accounts,
        uint256[] memory _tokenIds
    ) public view returns (uint256[] memory) {
        require(
            _accounts.length == _tokenIds.length,
            "ERC1155Token: accounts id length mismatch"
        );
        // create an array dynamically
        uint256[] memory balances = new uint256[](_accounts.length);

        for (uint256 i = 0; i < _accounts.length; i++) {
            balances[i] = balanceOf(_accounts[i], _tokenIds[i]);
        }

        return balances;
    }

    function setApprovalForAll(address _operator, bool _approved) public {
        _operatorApprovals[msg.sender][_operator] = _approved;
    }

    function isApprovedForAll(address _account, address _operator)
        public
        view
        returns (bool)
    {
        return _operatorApprovals[_account][_operator];
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _id,
        uint256 _amount,
        bytes memory _data
    ) public {
        require(
            _from == msg.sender || isApprovedForAll(_from, msg.sender),
            "ERC1155Token: not authorized"
        );

        // transfer
        transfer(_from, _to, _id, _amount);
        // safe transfer checks

        _doSafeTransferAcceptanceCheck(
            msg.sender,
            _from,
            _to,
            _id,
            _amount,
            _data
        );
        emit TransferSingle(msg.sender, _from, _to, _id, _amount);
    }

    function safeBatchTransferFrom(
        address _from,
        address _to,
        uint256[] memory _ids,
        uint256[] memory _amounts,
        bytes memory _data
    ) public {
        require(
            _from == msg.sender || isApprovedForAll(_from, msg.sender),
            "ERC1155Token: not authorized"
        );
        require(
            _ids.length == _amounts.length,
            "ERC1155Token: length mismatch"
        );

         
        
        for (uint256 i = 0; i < _ids.length; i++) {
            transfer(_from, _to, _ids[i], _amounts[i]);
            _doSafeTransferAcceptanceCheck(
                msg.sender,
                _from,
                _to,
                _ids[i],
                _amounts[i],
                _data
            );
        }

        emit TransferBatch(msg.sender, _from, _to, _ids, _amounts);
    }

    function mint(
        address _to,
        uint256 _tokenId,
        uint256 _amount
    ) public {
        

        uint256 tokenIdToMint;

        if (_tokenId > nextTokenIdToMint) {
            require(
                _tokenId == nextTokenIdToMint+1,
                "ERC1155Token: invalid tokenId"
            );
            tokenIdToMint = nextTokenIdToMint;
            nextTokenIdToMint += 1;
        } else {
            tokenIdToMint = _tokenId;
        }

        _balances[tokenIdToMint][_to] += _amount;
        totalSupply[tokenIdToMint] += _amount;

        emit TransferSingle(msg.sender, address(0), _to, _tokenId, _amount);
    }

    // INTERNAL FUNCTIONS

    function transfer(
        address _from,
        address _to,
        uint256 _ids,
        uint256 _amounts
    ) internal {
        require(_to != address(0), "ERC1155Token: transfer to address 0");

        uint256 id = _ids;
        uint256 amount = _amounts;

        uint256 fromBalance = _balances[id][_from];
        require(
            fromBalance >= amount,
            "ERC1155Token: insufficient balance for transfer"
        );
        _balances[id][_from] -= amount;
        _balances[id][_to] += amount;

    }

    function _doSafeTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) private {
        require(
            to.code.length == 0 ||
                IERC1155Receiver(to).onERC1155Received(
                    operator,
                    from,
                    to,
                    id,
                    amount,
                    data
                ) ==
                IERC1155Receiver.onERC1155Received.selector,
            "ERC1155Token: unsafe recepient"
        );
    }

    function onERC1155Received(
        address,
        address,
        address,
        uint256,
        uint256,
        bytes calldata
    ) external pure returns (bytes4) {
        return
            bytes4(
                keccak256(
                    "onERC1155Received(address, address, address, uint256, uint256, bytes)"
                )
            );
    }
}


// File contracts/MarketPlace/ITokenMarketPlace.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface ITokenMarketPlace {
    struct TokenOnSale {
        address seller;
        uint256 tokenId;
        uint256 quantity;
        uint256 tokenPrice;
        bool isOnSale;
        uint256 tokenType;
    }

    struct Auction {
        address seller;
        uint256 tokenId;
        uint256 quantity;
        uint256 startPrice;
        uint256 startTime;
        uint256 endTime;
        uint256 highestBid;
        address highestBidder;
        bool activeAuction;
    }

    struct Bidders {
        address bidderAddr;
        uint256 priceBid;
    }

    event SaleSet(
        address seller,
        uint256 tokenId,
        uint256 tokenPrice,
        uint256 quantity
    );
    event TokenPurchased(
        address buyer,
        uint256 tokenId,
        uint256 quantity,
        address tokenSeller
    );
    event AuctionCreated(
        address seller,
        uint256 tokenId,
        uint256 quantity,
        uint256 startPrice,
        uint256 startTime,
        uint256 endTime
    );
    event BidPlaced(
        address bidder,
        uint256 tokenId,
        address tokenSeller,
        uint256 bidAmount
    );
    event SaleEnded(address seller, uint256 tokenId);
    event AuctionEnded(address seller, uint256 tokenId);
    event TokenClaimed(
        address highestBidder,
        uint256 tokenId,
        address tokenSeller,
        uint256 highestBid
    );
    event BidCancelation(
        address BidCanceler,
        uint256 tokenId,
        address tokenSeller
    );

    function setOnSale(
        uint256 _tokenId,
        uint256 _tokenPrice,
        uint256 _quantity,
        uint256 _tokenType
    ) external;

    function buy(
        uint256 _tokenId,
        uint256 _tokenType,
        uint256 _quantity,
        address _sellerAddress
    ) external payable;

    function stopSale(uint256 _tokenId, uint256 _tokenType) external;

    function createAuction(
        uint256 _tokenType,
        uint256 _tokenId,
        uint256 _quantity,
        uint256 _startPrice,
        uint256 _startTime,
        uint256 _duration
    ) external;

    function placeBid(
        uint256 _tokenId,
        uint256 _tokenType,
        address _tokenSeller
    ) external payable;

    function cancelAuction(
        uint256 _tokenId,
        address _tokenSeller,
        uint256 _tokenType
    ) external;

    function claimToken(
        uint256 _tokenId,
        address _tokenSeller,
        uint256 _tokenType
    ) external;

    function cancelBid(
        uint256 _tokenId,
        address _tokenSeller,
        uint256 _tokenType
    ) external;
}


// File contracts/MarketPlace/TokenMarketPlace.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;



contract TokenMarketPlace is ITokenMarketPlace {
    address public erc1155;
    address public erc721;

    mapping(uint256 => mapping(uint256 => mapping(address => TokenOnSale)))
        public tokenSale;

    mapping(uint256 => mapping(uint256 => mapping(address => Auction)))
        public auction;
    mapping(uint256 => mapping(uint256 => mapping(address => Bidders[])))
        private bidder;
    mapping(uint256 => mapping(address => mapping(address => uint256)))
        private bidderAmounts;

    constructor(address _erc721, address _erc1155) {
        erc721 = _erc721;
        erc1155 = _erc1155;
    }

    function mint(
        uint256 _tokenType,
        uint256 _tokenId,
        uint256 _quantity
    ) public {
        require(
            _tokenType == 0 || _tokenType == 1,
            "TokenMarketPlace: Invalid token type"
        );
        require(_quantity > 0, "TokenMarketPlace: Tokens cannot be zero");
        if (_tokenType == 0) {
            _quantity = 1;
            ERC721Token(erc721).mint(msg.sender);
            _tokenId = ERC721Token(erc721).nextTokenIDMint() - 1;
        } else {
            IERC1155Token(erc1155).mint(msg.sender, _tokenId, _quantity);
        }
    }

    function setOnSale(
        uint256 _tokenId,
        uint256 _tokenPrice,
        uint256 _quantity,
        uint256 _tokenType
    ) public {
        require(
            _tokenType == 0 || _tokenType == 1,
            "TokenMarketPlace: Invalid token type"
        );
        require(_tokenPrice > 0, "TokenMarketPlace: invalid price");
        require(
            !auction[_tokenType][_tokenId][msg.sender].activeAuction,
            "TokenMarketPlace: There is a active auction"
        );
        require(
            !tokenSale[_tokenType][_tokenId][msg.sender].isOnSale,
            "TokenMarketPlace: token already on Sale"
        );
        if (_tokenType == 0) {
            _quantity = 1;
            require(
                ERC721Token(erc721).ownerOf(_tokenId) == msg.sender,
                "TokenMarketPlace: not token owner"
            );

            require(
                ERC721Token(erc721).getApproved(_tokenId) == address(this) ||
                    ERC721Token(erc721).isApprovedForAll(
                        msg.sender,
                        address(this)
                    ),
                "TokenMarketPlace: not approved"
            );
        } else {
            require(_quantity > 0, "TokenMarketPlace: invalid quantity");

            require(
                IERC1155Token(erc1155).isApprovedForAll(
                    msg.sender,
                    address(this)
                ),
                "TokenMarketPlace: not approved"
            );
        }
        tokenSale[_tokenType][_tokenId][msg.sender].tokenPrice = _tokenPrice;
        tokenSale[_tokenType][_tokenId][msg.sender].quantity += _quantity;
        tokenSale[_tokenType][_tokenId][msg.sender].seller = msg.sender;
        tokenSale[_tokenType][_tokenId][msg.sender].isOnSale = true;
        tokenSale[_tokenType][_tokenId][msg.sender].tokenType = _tokenType;
        emit SaleSet(msg.sender, _tokenId, _tokenPrice, _quantity);
    }

    function buy(
        uint256 _tokenId,
        uint256 _tokenType,
        uint256 _quantity,
        address _sellerAddress
    ) public payable {
        require(
            _tokenType == 0 || _tokenType == 1,
            "TokenMarketPlace: Invalid token type"
        );
        require(
            tokenSale[_tokenType][_tokenId][_sellerAddress].isOnSale,
            "TokenMarketPlace: token not on sale"
        );
        require(
            msg.sender !=
                tokenSale[_tokenType][_tokenId][_sellerAddress].seller,
            "TokenMarketPlace: you are the seller"
        );
        if (_tokenType == 0) {
            _quantity = 1;
            require(
                tokenSale[_tokenType][_tokenId][_sellerAddress].tokenPrice ==
                    msg.value,
                "TokenMarketPlace: invalid Price"
            );
            ERC721Token(erc721).transferFrom(
                _sellerAddress,
                msg.sender,
                _tokenId
            );
        } else {
            require(
                _quantity > 0 &&
                    _quantity <=
                    tokenSale[_tokenType][_tokenId][_sellerAddress].quantity,
                "TokenMarketPlace: invalid quantity"
            );
            require(
                msg.value ==
                    _quantity *
                        tokenSale[_tokenType][_tokenId][_sellerAddress]
                            .tokenPrice,
                "TokenMarketPlace: invalid Price"
            );
            IERC1155Token(erc1155).safeTransferFrom(
                tokenSale[_tokenType][_tokenId][_sellerAddress].seller,
                msg.sender,
                _tokenId,
                _quantity,
                bytes("Purchased")
            );
        }
        tokenSale[_tokenType][_tokenId][_sellerAddress].quantity -= _quantity;

        if (tokenSale[_tokenType][_tokenId][_sellerAddress].quantity == 0) {
            delete tokenSale[_tokenType][_tokenId][_sellerAddress];
        }

        emit TokenPurchased(msg.sender, _tokenId, _quantity, _sellerAddress);
    }

    function stopSale(uint256 _tokenId, uint256 _tokenType) external {
        require(
            _tokenType == 0 || _tokenType == 1,
            "TokenMarketPlace: Invalid token type"
        );
        require(
            tokenSale[_tokenType][_tokenId][msg.sender].isOnSale,
            "TokenMarketPlace: not on sale"
        );
        require(
            tokenSale[_tokenType][_tokenId][msg.sender].seller == msg.sender,
            "TokenMarketPlace: you're not the seller"
        );
        delete tokenSale[_tokenType][_tokenId][msg.sender];
        emit SaleEnded(msg.sender, _tokenId);
    }

    function createAuction(
        uint256 _tokenType,
        uint256 _tokenId,
        uint256 _quantity,
        uint256 _startPrice,
        uint256 _startTime,
        uint256 _endTime
    ) external {
        require(
            _tokenType == 0 || _tokenType == 1,
            "TokenMarketPlace: Invalid token type"
        );

        require(
            _startTime > block.timestamp || _startTime == 0,
            "TokenMarketPlace: invalid time"
        );

        require(
            _startPrice > 0,
            "TokenMarketPlace: starting price must be greater than zero."
        );

        require(
            !auction[_tokenType][_tokenId][msg.sender].activeAuction,
            "TokenMarketPlace: There is a active auction"
        );

        if (_startTime == 0) {
            _startTime = block.timestamp;
        }

        if (_tokenType == 0) {
            _quantity = 1;
            require(
                !tokenSale[_tokenType][_tokenId][msg.sender].isOnSale,
                "TokenMarketPlace: token already on Sale"
            );
            require(
                ERC721Token(erc721).ownerOf(_tokenId) == msg.sender,
                "TokenMarketPlace: You must own the token to create an auction"
            );

            require(
                ERC721Token(erc721).getApproved(_tokenId) == address(this) ||
                    ERC721Token(erc721).isApprovedForAll(
                        msg.sender,
                        address(this)
                    ),
                "TokenMarketPlace: not approved"
            );

            // ERC721Token(erc721).transferFrom(
            //     msg.sender,
            //     address(this),
            //     _tokenId
            // );
        } else {
            if (tokenSale[_tokenType][_tokenId][msg.sender].quantity > 0) {
                require(
                    _quantity <=
                        IERC1155Token(erc1155).balanceOf(msg.sender, _tokenId) -
                            tokenSale[_tokenType][_tokenId][msg.sender]
                                .quantity,
                    "TokenMarketPlace: unsufficient tokens"
                );
            }
            require(
                _quantity <=
                    IERC1155Token(erc1155).balanceOf(msg.sender, _tokenId),
                "TokenMarketPlace: Not enough tokens"
            );

            require(
                IERC1155Token(erc1155).isApprovedForAll(
                    msg.sender,
                    address(this)
                ),
                "TokenMarketPlace: not approved"
            );

            // IERC1155Token(erc1155).safeTransferFrom(
            //     msg.sender,
            //     address(this),
            //     _tokenId,
            //     _quantity,
            //     "0x00"
            // );
        }

        auction[_tokenType][_tokenId][msg.sender] = Auction({
            seller: msg.sender,
            tokenId: _tokenId,
            quantity: _quantity,
            startPrice: _startPrice,
            startTime: _startTime,
            endTime: _endTime,
            activeAuction: true,
            highestBidder: address(0),
            highestBid: 0
        });

        emit AuctionCreated(
            msg.sender,
            _tokenId,
            _quantity,
            _startPrice,
            _startTime,
            _endTime
        );
    }

    function placeBid(
        uint256 _tokenId,
        uint256 _tokenType,
        address _tokenSeller
    ) external payable {
        require(
            _tokenType == 0 || _tokenType == 1,
            "TokenMarketPlace: Invalid token type"
        );
        require(
            auction[_tokenType][_tokenId][_tokenSeller].activeAuction,
            "TokenMarketPlace: Auction is not active"
        );
        require(
            block.timestamp <
                auction[_tokenType][_tokenId][_tokenSeller].endTime,
            "TokenMarketPlace: Auction has ended"
        );
        require(
            msg.sender != auction[_tokenType][_tokenId][_tokenSeller].seller,
            "TokenMarketPlace: You cannot bid"
        );
        require(
            msg.value > auction[_tokenType][_tokenId][_tokenSeller].highestBid,
            "TokenMarketPlace: Bid amount must be higher than the current highest bid"
        );

        bidder[_tokenType][_tokenId][_tokenSeller].push(
            Bidders(msg.sender, msg.value)
        );
        bidderAmounts[_tokenType][_tokenSeller][msg.sender] += msg.value;
        auction[_tokenType][_tokenId][_tokenSeller].highestBidder = msg.sender;
        auction[_tokenType][_tokenId][_tokenSeller].highestBid = msg.value;

        emit BidPlaced(msg.sender, _tokenId, _tokenSeller, msg.value);
    }

    function cancelAuction(
        uint256 _tokenId,
        address _tokenSeller,
        uint256 _tokenType
    ) external {
        require(
            _tokenType == 0 || _tokenType == 1,
            "TokenMarketPlace: Invalid token type"
        );
        require(
            msg.sender == auction[_tokenType][_tokenId][_tokenSeller].seller,
            "TokenMarketPlace: Only the seller can perform this action"
        );
        require(
            auction[_tokenType][_tokenId][_tokenSeller].activeAuction,
            "TokenMarketPlace: Auction is not active"
        );

        auction[_tokenType][_tokenId][_tokenSeller].activeAuction = false;

        // if (_tokenType == 0) {
        //     ERC721Token(erc721).transferFrom(
        //         address(this),
        //         _tokenSeller,
        //         _tokenId
        //     );
        // } else {
        //     IERC1155Token(erc1155).safeTransferFrom(
        //         address(this),
        //         _tokenSeller,
        //         _tokenId,
        //         auction[_tokenType][_tokenId][_tokenSeller].quantity,
        //         "tokens transfered"
        //     );
        // }

        for (
            uint256 index = 0;
            index < bidder[_tokenType][_tokenId][_tokenSeller].length;
            index++
        ) {
            payable(
                bidder[_tokenType][_tokenId][_tokenSeller][index].bidderAddr
            ).transfer(
                    bidder[_tokenType][_tokenId][_tokenSeller][index].priceBid
                );
        }

        delete auction[_tokenType][_tokenId][_tokenSeller];

        emit AuctionEnded(_tokenSeller, _tokenId);
    }

    function claimToken(
        uint256 _tokenId,
        address _tokenSeller,
        uint256 _tokenType
    ) external {
        require(
            _tokenType == 0 || _tokenType == 1,
            "TokenMarketPlace: Invalid token type"
        );
        require(
            msg.sender ==
                auction[_tokenType][_tokenId][_tokenSeller].highestBidder,
            "TokenMarketPlace: You're not the highest bidder"
        );

        require(
            block.timestamp >=
                auction[_tokenType][_tokenId][_tokenSeller].endTime,
            "TokenMarketPlace: Auction has not ended yet"
        );

        if (_tokenType == 0) {
            ERC721Token(erc721).transferFrom(
                _tokenSeller,
                msg.sender,
                _tokenId
            );
        } else {
            IERC1155Token(erc1155).safeTransferFrom(
                _tokenSeller,
                msg.sender,
                _tokenId,
                auction[_tokenType][_tokenId][_tokenSeller].quantity,
                "tokens transferd"
            );
        }

        payable(_tokenSeller).transfer(
            auction[_tokenType][_tokenId][_tokenSeller].highestBid
        );

        for (
            uint256 index = 0;
            index < bidder[_tokenType][_tokenId][_tokenSeller].length;
            index++
        ) {
            if (
                bidder[_tokenType][_tokenId][_tokenSeller][index].bidderAddr !=
                msg.sender
            ) {
                payable(
                    bidder[_tokenType][_tokenId][_tokenSeller][index].bidderAddr
                ).transfer(
                        bidder[_tokenType][_tokenId][_tokenSeller][index]
                            .priceBid
                    );
            }
        }
        delete auction[_tokenType][_tokenId][_tokenSeller];

        emit TokenClaimed(
            msg.sender,
            _tokenId,
            _tokenSeller,
            auction[_tokenType][_tokenId][_tokenSeller].highestBid
        );
    }

    function cancelBid(
        uint256 _tokenId,
        address _tokenSeller,
        uint256 _tokenType
    ) external {
        require(
            _tokenType == 0 || _tokenType == 1,
            "TokenMarketPlace: Invalid token type"
        );
        require(
            bidderAmounts[_tokenType][_tokenSeller][msg.sender] > 0,
            "TokenMarketPlace: You haven't bid yet"
        );
        payable(msg.sender).transfer(
            bidderAmounts[_tokenType][_tokenSeller][msg.sender]
        );

        for (
            uint256 index = 0;
            index < bidder[_tokenType][_tokenId][_tokenSeller].length;
            index++
        ) {
            if (
                msg.sender ==
                bidder[_tokenType][_tokenId][_tokenSeller][index].bidderAddr
            ) {
                for (
                    uint256 indexs = 0;
                    indexs <
                    bidder[_tokenType][_tokenId][_tokenSeller].length - 1;
                    indexs++
                ) {
                    bidder[_tokenType][_tokenId][_tokenSeller][indexs] = bidder[
                        _tokenType
                    ][_tokenId][_tokenSeller][indexs + 1];
                }
                bidder[_tokenType][_tokenId][_tokenSeller].pop();
            }
        }

        emit BidCancelation(msg.sender, _tokenId, _tokenSeller);
    }
}


// File contracts/ERC20.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface Token {
    function balanceOf(address _account) external view returns (uint256);

    function transfer(address _to, uint256 _tokens) external returns (bool);

    function approve(address _from, uint256 _tokens) external returns (bool);

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokens
    ) external returns (bool);

    function allowance(
        address _owner,
        address _from
    ) external view returns (uint256);

    function mint(uint256 _tokens) external;

    function burn(uint256 _tokens) external;
}

contract ERC20 is Token {
    string public name = "saken";
    string public symbol = "skn";
    uint8 public decimals = 18;
    uint256 public totalSupply = 50000000000000000000;
    uint256 public MAXSupply = 100000000000000000000;

    address public owner;

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private tokenAllowance;

    event Transfer(address senders, address receivers, uint256 amount);
    event Approval(address owner, address tokenUser, uint256 amount);

    constructor() {
        owner = msg.sender;
        balances[owner] = totalSupply;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "ERC20: Only Owner can access");
        _;
    }

    function balanceOf(address _account) external view returns (uint256) {
        return balances[_account];
    }

    function transfer(address _to, uint256 _tokens) external returns (bool) {
        require(balances[msg.sender] >= _tokens, "ERC20: Not enough tokens");
        balances[msg.sender] -= _tokens;
        balances[_to] += _tokens;
        emit Transfer(msg.sender, _to, _tokens);
        return true;
    }

    function approve(address _from, uint256 _tokens) external returns (bool) {
        require(
            balances[_from] >= _tokens,
            "ERC20: insuficient balance for approval"
        );

        tokenAllowance[msg.sender][_from] = _tokens;
        emit Approval(msg.sender, _from, _tokens);

        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokens
    ) external returns (bool) {
        require(
            tokenAllowance[_from][msg.sender] >= _tokens,
            "ERC20: Not Allowed"
        );
        require(
            balances[_from] > 0 && balances[_from] >= _tokens,
            "ERC20: Not enough tokens!"
        );
        balances[_from] -= _tokens;
        balances[_to] += _tokens;
        tokenAllowance[_from][msg.sender] -= _tokens;
        emit Transfer(_from, _to, _tokens);
        return true;
    }

    function allowance(
        address _owner,
        address _spender
    ) external view returns (uint256) {
        return tokenAllowance[_owner][_spender];
    }

    function mint(uint256 _tokens) public onlyOwner {
        require(
            _tokens <= MAXSupply - totalSupply && _tokens > 0,
            "ERC20: Reached MAX supply"
        );

        totalSupply += _tokens;
        balances[owner] += _tokens;
        balances[address(this)] += _tokens;
        emit Transfer(address(0), owner, _tokens);
    }

    function burn(uint256 _tokens) external onlyOwner {
        require(_tokens <= totalSupply, "ERC20: Not enough tokens");
        totalSupply -= _tokens;
        balances[owner] -= _tokens;
        balances[address(this)] -= _tokens;

        emit Transfer(owner, address(0), _tokens);
    }
}


// File contracts/Lock.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Lock {
    uint public unlockTime;
    address payable public owner;

    event Withdrawal(uint amount, uint when);

    constructor(uint _unlockTime) payable {
        require(
            block.timestamp < _unlockTime,
            "Unlock time should be in the future"
        );

        unlockTime = _unlockTime;
        owner = payable(msg.sender);
    }

    function withdraw() public {
        // Uncomment this line, and the import of "hardhat/console.sol", to print a log in your terminal
        // console.log("Unlock time is %o and block timestamp is %o", unlockTime, block.timestamp);

        require(block.timestamp >= unlockTime, "You can't withdraw yet");
        require(msg.sender == owner, "You aren't the owner");

        emit Withdrawal(address(this).balance, block.timestamp);

        owner.transfer(address(this).balance);
    }
}
