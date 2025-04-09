// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
abstract contract OwnableUpgradeable {
    function __Ownable_init() internal {}
    modifier onlyOwner() { _; }
}