import Web3 from 'web3'
import json from '../../build/contracts/Roulette.json'

let getContract = new Promise(function (resolve, reject) {
    let address = '0x833967a3e68ed4403e398a2497eb5abbcd6a514b'
    let web3 = new Web3(window.web3.currentProvider)
    let casinoContract = web3.eth.contract(json['abi'])
    let casinoContractInstance = casinoContract.at(address)
    resolve(casinoContractInstance)
})

export default getContract
