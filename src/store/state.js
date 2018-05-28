import Web3 from "web3";

let state = {
    web3: {
        isInjected: false,
        web3Instance: null,
        networkId: null,
        coinbase: null,
        balance: 0,
        error: null,
    },
    contract: {
        minimumMint: 0,
        minimumBet: 0,
        maximumBet: 0,
    },
    contractInstance: null,
    rouletteComponent: {
        amount: 0,
        bets: [],
        balance: 0,
        winEvent: null,
        totalWon: 0,
        totalBet: 0,
    }
}

export default state
