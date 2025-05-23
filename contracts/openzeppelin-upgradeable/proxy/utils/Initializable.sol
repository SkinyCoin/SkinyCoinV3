// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
abstract contract Initializable {
    modifier initializer() { _; }
    function _disableInitializers() internal {}
}