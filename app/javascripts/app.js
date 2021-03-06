// Import the page's CSS. Webpack will know what to do with it.
import '../stylesheets/app.css'

// Import libraries we need.
import { default as Web3 } from 'web3'
import { default as contract } from 'truffle-contract'

import mintTokenArtifacts from '../../build/contracts/MintToken.json'

var MintToken = contract(mintTokenArtifacts)
let userAddress = null

window.getUserBalance = function () {
  userAddress = $('#userAddress').val()
  MintToken.deployed().then(function (contractInstance) {
    contractInstance.getUserBalance.call(userAddress)
      .then((result) => {
        $('#userBalance').html(result.toString())
      })
  })
}

window.transfer = function () {
  const toAddress = $('#toAddress').val()
  const amount = $('#amount').val()
  MintToken.deployed().then(function (contractInstance) {
    console.log('address', toAddress)
    console.log('amount', amount)
    contractInstance.transfer(toAddress, amount, { gas: 150000, from: web3.eth.accounts[0] })
      .then((result) => {
        return contractInstance.getUserBalance.call(userAddress)        
      })
      .then((result) => {
        $('#userBalance').html(result.toString())
      })
  })
}

window.sendEthToContract = () => {
  const ethToSend = web3.toWei($('#ethToSend').val(), 'ether')
  const fromAddress = $('#fromAddress').val()
  console.log('eth', ethToSend, 'from address ', fromAddress)
  return MintToken.deployed().then((contractInstance) => {    
    return contractInstance.sendEthToContract({ value: ethToSend, from: fromAddress })
  })
  .then((result) => {
    return getContractBalance()
  })
}

window.sendEthFromContract = () => {
  const ethToWithdraw = web3.toWei($('#ethToWithdraw').val(), 'ether')
  const withdrawToAddress = $('#withdrawToAddress').val()
  console.log('withdraw', ethToWithdraw, 'wei to address', withdrawToAddress)
  return MintToken.deployed().then((contractInstance) => {    
    return contractInstance.sendEthFromContract(withdrawToAddress, ethToWithdraw, { from: web3.eth.accounts[0] })
  })
  .then((result) => {
    return getContractBalance()
  })
}

function getContractBalance () {
  return MintToken.deployed().then((contractInstance) => {
    web3.eth.getBalance(contractInstance.address, function (error, result) {
      if (error) console.error(error)
      console.log(result.toString())
      if (result.toString() === '0') $('#contractBalance').html(web3.fromWei(0))
      else $('#contractBalance').html(web3.fromWei(result.toString()))
    })
  })
}

$(document).ready(function () {
  if (typeof web3 !== 'undefined') {
    console.warn('Using web3 detected from external source like Metamask')
    // Use Mist/MetaMask's provider
    window.web3 = new Web3(web3.currentProvider)
  } else {
    console.warn("No web3 detected. Falling back to http://localhost:8545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask")
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    window.web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'))
  }
  $('#userBalance').html(0)

  MintToken.setProvider(web3.currentProvider)
  getContractBalance()
})
