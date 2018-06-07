import Web3 from 'web3'
import json from '../../build/contracts/Roulette.json'

let getContract = new Promise(function (resolve, reject) {
    let address = '0x32c6d385448b21fd49c0a6f4e7546dfdf6115bbd'
    let web3 = new Web3(window.web3.currentProvider)
    let casinoContract = web3.eth.contract(json['abi'])
    let casinoContractInstance = casinoContract.at(address)
    resolve(casinoContractInstance)
})

export default getContract
