// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Coin {
    // Public variables of the token
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    uint256 public maxSupply;
    
    // Owner of the contract
    address public owner;

    // Mapping with all balances
    mapping (address => uint256) public balanceOf;

    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Mint(address indexed to, uint256 value);

    // Modifier to restrict functions to owner only
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    // Constructor
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        maxSupply = 100 * 10 ** uint256(decimals); // Set max supply to 100 coins
        totalSupply = 0; // Initial total supply is 0
        owner = msg.sender;
    }

    // Internal transfer function
    function _transfer(address _from, address _to, uint256 _value) internal {
        require(_to != address(0), "Invalid address");
        uint256 fromBalance = balanceOf[_from];
        require(fromBalance >= _value, "Insufficient balance");
        unchecked {
            balanceOf[_from] = fromBalance - _value;
            balanceOf[_to] += _value;
        }
        emit Transfer(_from, _to, _value);
    }

    // External transfer function
    function transfer(address _to, uint256 _value) external returns (bool success) {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    // Mint new tokens
    function mint(address _to, uint256 _value) external onlyOwner returns (bool success) {
        require(totalSupply + _value <= maxSupply, "Exceeds max supply");
        totalSupply += _value;
        balanceOf[_to] += _value;
        emit Mint(_to, _value);
        return true;
    }
}
