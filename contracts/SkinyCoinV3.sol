// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./openzeppelin/token/ERC20/ERC20.sol";
import "./openzeppelin/access/Ownable.sol";
import "./openzeppelin/proxy/utils/UUPSUpgradeable.sol";
import "./openzeppelin/proxy/utils/Initializable.sol";

contract SkinyCoinV3 is Initializable, ERC20, Ownable, UUPSUpgradeable {
    uint256 public devFee;      // 2%
    uint256 public farmFee;     // 1%
    uint256 public burnFee;     // 1%
    address public devWallet;
    address public farmWallet;

    mapping(address => bool) private _isExcludedFromFees;

    constructor() ERC20("SkinyCoinV3", "SKINY") {
        _disableInitializers();
    }

    function initialize(address _devWallet, address _farmWallet) public initializer {
        __ERC20_init("SkinyCoinV3", "SKINY");
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();

        devFee = 2;
        farmFee = 1;
        burnFee = 1;
        devWallet = _devWallet;
        farmWallet = _farmWallet;

        _mint(msg.sender, 1000000000 * 10 ** decimals());
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    function excludeFromFees(address account, bool excluded) external onlyOwner {
        _isExcludedFromFees[account] = excluded;
    }

    function setFees(uint256 _devFee, uint256 _farmFee, uint256 _burnFee) external onlyOwner {
        require(_devFee + _farmFee + _burnFee <= 10, "Total fee too high");
        devFee = _devFee;
        farmFee = _farmFee;
        burnFee = _burnFee;
    }

    function setWallets(address _devWallet, address _farmWallet) external onlyOwner {
        devWallet = _devWallet;
        farmWallet = _farmWallet;
    }

    function _transfer(address from, address to, uint256 amount) internal override {
        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
            super._transfer(from, to, amount);
            return;
        }

        uint256 devAmount = amount * devFee / 100;
        uint256 farmAmount = amount * farmFee / 100;
        uint256 burnAmount = amount * burnFee / 100;
        uint256 sendAmount = amount - devAmount - farmAmount - burnAmount;

        super._transfer(from, devWallet, devAmount);
        super._transfer(from, farmWallet, farmAmount);
        super._burn(from, burnAmount);
        super._transfer(from, to, sendAmount);
    }
}
