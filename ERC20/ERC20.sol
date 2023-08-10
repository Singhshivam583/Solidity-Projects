// SPDX-License-Identifier: GPL
pragma solidity ^0.8.0;

// contract Token {

//     function MaxElement (int[10] memory arr) public pure returns(int){
//         int max=arr[0];
//         for(uint i=0)
//     }

// }
interface ERC20Interface{
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Block is ERC20Interface{

    string public name="Block";
    string public symbol="BLK";
    uint public decimal=0;
    uint public override totalSupply;
    address public founder;
    mapping (address=>uint) public balances;
    mapping(address => mapping(address=>uint)) allowed;

    constructor(){
        totalSupply=1000;
        founder=msg.sender;
        balances[founder]=totalSupply;     
    }

    function balanceOf(address tokenOwner) external view override returns (uint balance){
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) external returns (bool success){
        require(balances[msg.sender]>tokens,"You don't have Enough Balance");
        balances[to]+=tokens; 
        balances[msg.sender]-=tokens;
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function allowance(address tokenOwner, address spender) external view override  returns (uint remaining){
        return allowed[tokenOwner][spender];
    }

    function approve(address spender, uint tokens) external override  returns (bool success){
        require(balances[msg.sender]>=tokens,"You have insufficient balance");
        require(tokens>0,"zero number of tokens can't be approved");
        allowed[msg.sender][spender]=tokens;
        emit Approval(msg.sender,spender,tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) external returns (bool success){
        require(allowed[from][to]>=tokens,"You are not approved for thos much of tokens ");
        require(balances[from]>=tokens,"You have insufficient balance");
        balances[from]-=tokens;
        balances[to]+=tokens;
        return true;
    }  
}
