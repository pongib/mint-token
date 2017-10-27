pragma solidity ^0.4.15;

contract Owned {
  address public owner;

  function Owned () {
    owner = msg.sender;
  }
  
  modifier onlyOwner {
    require(msg.sender == owner);
    _; // why need to add this line?
  }

  function transferOwnership(address newOwner) onlyOwner {
    owner = newOwner;
  }
}

contract MintToken is Owned {
  // help clients like the Ethereum Wallet keep track of activities happening in the contract
  event Transfer (address indexed from, address indexed to, uint256 value);
  event FrozenFunds (address target, bool frozen);

  mapping (address => uint256) public balanceOf;
  mapping (address => bool) public frozenAccount;

  string public name;
  string public symbol;
  uint8 public decimals;
  uint256 public totalSupply;
  
  function MintToken (
    uint256 initialSupply,
    string tokenName,
    string tokenSymbol,
    uint8 decimalUnits,
    address centralMinter
    ) {  
    if (centralMinter != 0) owner = centralMinter; // set central minter as owner
    totalSupply = initialSupply; // set total supply as initial supply
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
  
  /* Internal transfer only can be called by contract itself */
  function _transfer (address _from, address _to, uint _value) internal {
    require(_to != 0x0);  // Prevent transfer to 0x0 address. Use burn() instead
    require(balanceOf[_from] >= _value); // Check if the sender has enough
    require(balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows
    // require(!frozenAccount(_from));  // Check if sender is frozen
    // require(!frozenAccount(_to));  // Check if recipient is frozen
    balanceOf[_from] -= _value; // Subtract from the sender
    balanceOf[_to] += _value;  // Add the same to the recipient
    Transfer(_from, _to, _value);
  }

  function mintToken (address target, uint256 mintedAmount) onlyOwner {
    balanceOf[target] += mintedAmount;
    totalSupply += mintedAmount;
    Transfer(0, owner, mintedAmount);
    Transfer(owner, target, mintedAmount);
  }
  
  function freezeAccount (address target, bool freeze) onlyOwner {
    frozenAccount[target] = freeze;
    FrozenFunds(target, freeze);
  }
}