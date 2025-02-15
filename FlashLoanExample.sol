// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@aave/core-v3/contracts/interfaces/IPool.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FlashLoanExample {
    address payable owner;
    IPool private pool;

    constructor(address _aavePool) {
        owner = payable(msg.sender);
        pool = IPool(_aavePool);
    }

    function executeFlashLoan(address asset, uint256 amount) external {
        address receiver = address(this);
        bytes memory params = ""; // Custom logic can be added
        uint16 referralCode = 0;

        pool.flashLoanSimple(receiver, asset, amount, params, referralCode);
    }

    function onFlashLoanReceived(
        address asset,
        uint256 amount,
        uint256 fee
    ) external returns (bool) {
        // Implement your logic (arbitrage, liquidation, etc.)
        
        // Repay the flash loan
        IERC20(asset).approve(address(pool), amount + fee);
        return true;
    }
}
