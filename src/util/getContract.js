import Web3 from 'web3'
import json from '../../build/contracts/Roulette.json'

let getContract = new Promise(function (resolve, reject) {
    let address = '0x63edb8119a314c409483d84f64c591415d6e1e51'
    let web3 = new Web3(window.web3.currentProvider)
    let casinoContract = web3.eth.contract(json['abi'])
    let casinoContractInstance = casinoContract.at(address)
    resolve(casinoContractInstance)
})

export default getContract
