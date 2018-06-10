import Web3 from 'web3'
import json from '../../build/contracts/Roulette.json'

let getContract = new Promise(function (resolve, reject) {
    let address = '0x6d103dcf4999276ea3a01dad6a87161a2a3a3d48'
    let web3 = new Web3(window.web3.currentProvider)
    let casinoContract = web3.eth.contract(json['abi'])
    let casinoContractInstance = casinoContract.at(address)
    resolve(casinoContractInstance)
})

export default getContract
