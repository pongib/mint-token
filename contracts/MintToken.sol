pragma solidity ^0.4.15;

contract MintToken {
  mapping (address => uint256) public balanceOf;
  
  function MintToken (uint256 initialSupply) {
    balanceOf[msg.sender] = initialSupply; // Give the creator all initial tokens
  }

  function transfer (address _to, uint256 _value) {
    require(balanceOf[msg.sender] >= _value);  // Check if the sender has enough
    require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
    balanceOf[msg.sender] -= _value;  // Subtract from the sender
    balanceOf[_to] += _value;  // Add the same to the recipient
  }

  function getUserBalance(address _address) constant returns (uint256) {
    return balanceOf[_address];
  }
}