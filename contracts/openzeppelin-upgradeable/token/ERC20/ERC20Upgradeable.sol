// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
abstract contract ERC20Upgradeable {
    function __ERC20_init(string memory, string memory) internal {}
    function decimals() public pure returns (uint8) { return 18; }
    function _mint(address, uint256) internal {}
    function _transfer(address, address, uint256) internal {}
    function _burn(address, uint256) internal {}
}