import Vue from 'vue'
import Vuex from 'vuex'
import state from './state'
import getWeb3 from '../util/getWeb3'
import pollWeb3 from '../util/pollWeb3'
import getContract from '../util/getContract'

Vue.use(Vuex)
export const store = new Vuex.Store({
    strict: true,
    state,
    mutations: {
        registerWeb3Instance(state, payload) {
            let result = payload
            let web3Copy = state.web3
            web3Copy.coinbase = result.coinbase
            web3Copy.networkId = result.networkId
            web3Copy.balance = parseInt(result.balance, 10)
            web3Copy.isInjected = result.injectedWeb3
            web3Copy.web3Instance = result.web3
            state.web3 = web3Copy
            pollWeb3()
        },
        pollWeb3Instance(state, payload) {
            state.web3.coinbase = payload.coinbase
            state.web3.balance = parseInt(payload.balance, 10)
        },
        registerContractInstance(state, payload) {
            state.contractInstance = () => payload
        },
        minimumMint(state, payload) {
            state.contract.minimumMint = payload
        },
        minimumBet(state, payload) {
            state.contract.minimumBet = payload
        },
        maximumBet(state, payload) {
            state.contract.maximumBet = payload
        },
        pushBet(state, payload) {
            var temp = []
            temp.push(payload.number)
            temp.push(payload.amount)
            temp.push(payload.factor)
            state.rouletteComponent.bets.push(temp)
        },
        addAmount(state, payload) {
            state.rouletteComponent.totalBet += payload;
        },
        playedCount(state, payload) {
            state.rouletteComponent.playedCount += payload;
        },
        wonCount(state, payload) {
            state.rouletteComponent.wonCount += payload;
        }
    },
    actions: {
        registerWeb3({commit}) {
            getWeb3.then(result => {
                commit('registerWeb3Instance', result)
            }).catch(e => console.log(e))
        },
        pollWeb3({commit}, payload) {
            commit('pollWeb3Instance', payload)
        },
        getContractInstance({commit}) {
            getContract.then(result => {
                commit('registerContractInstance', result)
            }).catch(e => console.log(e))
        },
        setMinimumMint({commit}, payload) {
            commit('minimumMint', payload)
        },
        setMinimumBet({commit}, payload) {
            commit('minimumBet', payload)
        },
        setMaximumBet({commit}, payload) {
            commit('maximumBet', payload)
        },
        setBet({commit}, payload) {
            commit('pushBet', payload)
        },
        addBetAmount({commit}, payload) {
            commit('addAmount', payload)
        },
        addPlayed({commit}, payload) {
            commit('playedCount', payload)
        },
        addWon({commit}, payload) {
            commit('wonCount', payload)
        }
    }
})

export default store
