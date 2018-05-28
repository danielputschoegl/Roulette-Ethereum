<template>
    <b-container class="bv-example-row">
        <b-row class="mb-3">
            <b-col>
                Contract Balance: {{ balance }}
                <b-button style="height: 2.5em" variant="success" v-on:click="update">
                    Update
                </b-button>
                <b-button style="height: 2.5em" variant="danger" v-on:click="kill">
                    Kill
                </b-button>
            </b-col>
        </b-row>
        <b-row>
            <b-col>
                <h1>
                    <b-badge variant="success">Welcome to the new World of Roulette</b-badge>
                </h1>
            </b-col>
        </b-row>
        <b-row class="mb-3">
            <b-col>
                Deposit into contract: <input v-model="mint" placeholder="Minimum mint Ether">

                <b-button style="height: 2.5em" variant="success" v-on:click="depositContract">
                    Deposit
                </b-button>
            </b-col>
        </b-row>
        <b-row class="mb-3">
            <b-col>
                Amount to bet: <input v-model="amount" placeholder="Minimum amount Ether"> (Min: {{
                this.$store.state.contract.minimumBet }}, Max: {{ maximum }})
            </b-col>
        </b-row>
        <b-row>
            <b-button style="height: 15em" variant="success" v-on:click="clickNumber">
                {{0}}
            </b-button>
            <b-col class="ml-0" cols="10.9">
                <div>
                    <span v-for="n in 36" v-if="n % 3 == 0">
                        <b-button v-if="n % 2 == 0" variant="dark" v-on:click="clickNumber([n], 17)">
                        {{ n }}
                        </b-button>
                        <b-button v-else variant="danger" v-on:click="clickNumber([n], 17)">
                            {{ n }}
                        </b-button>
                    </span>
                </div>
                <div>
                    <span v-for="n in 36" v-if="(n + 1) % 3 == 0">
                        <b-button v-if="n % 2 == 0" variant="dark" v-on:click="clickNumber">
                        {{n}}
                        </b-button>
                        <b-button v-else variant="danger" v-on:click="clickNumber">
                            {{n}}
                        </b-button>
                    </span>
                </div>
                <div>
                    <span v-for="n in 36" v-if="(n + 2) % 3 == 0">
                        <b-button v-if="n % 2 == 0" variant="dark" v-on:click="clickNumber">
                        {{n}}
                        </b-button>
                        <b-button v-else variant="danger" v-on:click="clickNumber">
                            {{n}}
                        </b-button>
                    </span>
                </div>
            </b-col>
        </b-row>
        <b-row class="mb-3 mt-5">
            <b-col>
                <b-button style="width: 10em;" variant="success" v-on:click="play">
                    Play
                </b-button>
                <div>
                    Total Won: {{ totalWon }}
                </div>
                <div v-if="winEvent != null">
                    {{ winEvent._betNumber }} {{ winEvent._totalAmount }} {{ winEvent._winningNumber }}
                </div>
            </b-col>
        </b-row>
    </b-container>
</template>

<script>
    export default {
        name: 'roulette',
        data() {
            return {
                mint: this.$store.state.contract.minimumMint,
                minimum: this.$store.state.contract.minimumBet,
                maximum: this.$store.state.contract.maximumBet,
                amount: this.$store.state.rouletteComponent.amount,
                bets: this.$store.state.rouletteComponent.bets,
                balance: this.$store.state.rouletteComponent.balance,
                winEvent: this.$store.state.rouletteComponent.winEvent,
                totalWon: this.$store.state.rouletteComponent.totalWon,
            }
        },
        methods: {
            update() {
                this.$store.state.contractInstance().minimumMint((err, result) => {
                    if (!err && result != null) {
                        this.$store.dispatch('setMinimumMint', parseFloat(web3.fromWei(result, 'ether')))
                        this.mint = this.$store.state.contract.minimumMint
                    }
                })
                this.$store.state.contractInstance().minimumBet((err, result) => {
                    if (!err && result != null) {
                        this.$store.dispatch('setMinimumBet', parseFloat(web3.fromWei(result, 'ether')))
                        this.minimum = this.$store.state.contract.minimumBet
                        this.amount = this.amount ? this.amount : this.minimum
                    }
                })
                this.$store.state.contractInstance().maximumBet((err, result) => {
                    if (!err && result != null) {
                        this.$store.dispatch('setMaximumBet', parseFloat(web3.fromWei(result, 'ether')))
                        this.maximum = this.$store.state.contract.maximumBet
                    }
                })
                this.$store.state.contractInstance().checkContractBalance((err, result) => {
                    if (!err && result != null) {
                        this.balance = parseFloat(web3.fromWei(result, 'ether'))
                    }
                })
            },

            depositContract() {
                this.$store.state.contractInstance().mint({
                    gas: 300000,
                    value: this.$store.state.web3.web3Instance().toWei(this.mint, 'ether'),
                    from: this.$store.state.web3.coinbase
                }, (err, result) => {
                    if (err) {
                        console.log(err)
                    } else {
                        let Balance = this.$store.state.contractInstance().Balance()
                        Balance.watch((err, result) => {
                            if (err) {
                                console.log('could not get event Won()')
                            } else {
                                this.balance = parseFloat(web3.fromWei(result.args._balance, 'ether'))
                            }
                        })
                    }
                })
            },

            clickNumber(numbers, factor) {
                var number = [];
                numbers.forEach(function (element) {
                    number.push(element)
                })

                this.$store.dispatch('setBet', {
                    number: number,
                    factor: factor
                })
                this.$store.state.contractInstance().playerBets((err, result) => {
                    if (!err && result != null) {
                        console.log(result)
                    }
                })

                var bets = this.$store.state.rouletteComponent.bets

                for (var i = 0; i < bets.length; i++) {
                    for (var k = 0; k < bets[i][0].length; k++) {
                        console.log(bets[i][0][k])
                        console.log(bets[i][1])
                    }
                }
            },

            play() {
                this.$store.state.contractInstance().determineWinner({
                    gas: 300000,
                    value: 0,
                    from: this.$store.state.web3.coinbase
                }, (err, result) => {
                    if (err) {
                        console.log(err)
                        this.pending = false
                    } else {
                        let Won = this.$store.state.contractInstance().Won()
                        Won.watch((err, result) => {
                            if (err) {
                                console.log('could not get event Won()')
                            } else {
                                this.winEvent = result.args
                                this.winEvent._totalAmount = parseFloat(web3.fromWei(result.args._amount, 'ether'))
                                this.winEvent._winningNumber = result.args._winningNumber
                                this.winEvent._betNumber = result.args._betNumber
                                this.totalWon += this.winEvent._totalAmount;
                            }
                        })
                        let Balance = this.$store.state.contractInstance().Balance()
                        Balance.watch((err, result) => {
                            if (err) {
                                console.log('could not get event Won()')
                            } else {
                                this.balance = parseFloat(web3.fromWei(result.args._balance, 'ether'))
                            }
                        })
                    }
                })
            },

            kill() {
                this.winEvent = null
                this.$store.state.contractInstance().kill({
                    from: this.$store.state.web3.coinbase
                }, (err, result) => {
                    if (err) {
                        console.log(err)
                    } else {
                        this.update()
                    }
                })
            }
        },
        beforeCreate() {
            this.$store.dispatch('getContractInstance')
        }
    }
</script>
