pragma solidity ^0.4.15;

contract MintToken {
  // help clients like the Ethereum Wallet keep track of activities happening in the contract
  event Transfer (address indexed from, address indexed to, uint256 value);

  mapping (address => uint256) public balanceOf;
  string public name;
  string public symbol;
  uint8 public decimals;
  
  
  
  function MintToken (uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits) {
    balanceOf[msg.sender] = initialSupply; // Give the creator all initial tokens
    name = tokenName; // Set the name for display purpose
    symbol = tokenSymbol; // Set the symbol for display purpose
    decimals = decimalUnits; // Amount of decimals for display purposes
  }

  function transfer (address _to, uint256 _value) {
    require(balanceOf[msg.sender] >= _value);  // Check if the sender has enough
    require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
    balanceOf[msg.sender] -= _value;  // Subtract from the sender
    balanceOf[_to] += _value;  // Add the same to the recipient
    Transfer(msg.sender, _to, _value); // Notify anyone listing that this transfer took place
  }

  function getUserBalance(address _address) constant returns (uint256) {
    return balanceOf[_address];
  }
  
  function sendEthToContract() payable {}

  function sendEthFromContract(address _to, uint256 _value) {
    _to.transfer(_value);
  }
}