import Web3 from 'web3'
import json from '../../build/contracts/Roulette.json'

let getContract = new Promise(function (resolve, reject) {
    let address = '0xdbab6799cf5636c6c31a9ffa755d877635a1c679'
    let web3 = new Web3(window.web3.currentProvider)
    let casinoContract = web3.eth.contract(json['abi'])
    let casinoContractInstance = casinoContract.at(address)
    resolve(casinoContractInstance)
})

export default getContract
