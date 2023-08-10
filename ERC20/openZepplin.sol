// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GLDToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("Block", "ABC") {
        _mint(msg.sender, initialSupply);
    }
    function decimals() public view virtual override returns (uint8) {
    return 1;
    }
    // total Supply=100
    // Minted tokens=100*10^-1
    //supported 1,2 ,0.1,0.5
    // not supported greater than 1 decimal points
}