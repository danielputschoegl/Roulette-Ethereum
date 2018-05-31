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
                Amount to bet: <input v-model="amount" placeholder="Minimum amount Ether"> (Min: {{ minimum }}, Max: {{
                maximum }})
            </b-col>
        </b-row>
        <b-row>
            <b-button style="height: 15em" variant="success" v-on:click="clickNumber([0], 17)">
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
                        <b-button v-if="n % 2 == 0" variant="dark" v-on:click="clickNumber([n], 17)">
                        {{n}}
                        </b-button>
                        <b-button v-else variant="danger" v-on:click="clickNumber([n], 17)">
                            {{n}}
                        </b-button>
                    </span>
                </div>
                <div>
                    <span v-for="n in 36" v-if="(n + 2) % 3 == 0">
                        <b-button v-if="n % 2 == 0" variant="dark" v-on:click="clickNumber([n], 17)">
                        {{n}}
                        </b-button>
                        <b-button v-else variant="danger" v-on:click="clickNumber([n], 17)">
                            {{n}}
                        </b-button>
                    </span>
                </div>
            </b-col>
        </b-row>
        <b-row>
                <a href="#" v-bind:class="[activeClass]"><img id="wheel" width="400" height="400"
                                                              src="../assets/roulette_wheel.png"/></a>
            <b-col>
                <div v-if="winEvent != null" style="font-size: 100px">
                    {{ winEvent._winningNumber }}
                </div>
            </b-col>
        </b-row>
        <b-row class="mb-3 mt-5">
            <b-col>
                <div>
                    Already Bet: {{ totalBet }}
                </div>
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
    import Col from "bootstrap-vue/es/components/layout/col";

    export default {
        components: {Col},
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
                totalBet: this.$store.state.rouletteComponent.totalBet,
                playedCount: this.$store.state.rouletteComponent.playedCount,
                wonCount: this.$store.state.rouletteComponent.wonCount,
                activeClass: ''
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
                                console.log('could not get event Balance()')
                            } else {
                                console.log('balance')
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
                    amount: this.amount,
                    factor: factor
                })
                this.$store.dispatch('addBetAmount', this.amount)
                this.totalBet = this.$store.state.rouletteComponent.totalBet;
            },

            play() {
                this.activeClass = 'active'
                this.$store.dispatch('addPlayed', 1)
                this.playedCount = this.$store.state.rouletteComponent.playedCount
                var bets = this.$store.state.rouletteComponent.bets
                var number = []
                var amount = []
                var factor = []

                for (var i = 0; i < bets.length; i++) {
                    for (var j = 0; j < bets[i][0].length; j++) {
                        number.push(bets[i][0][j])
                        amount.push(parseInt(this.$store.state.web3.web3Instance().toWei(bets[i][1], 'ether')))
                        factor.push(bets[i][2])
                    }
                }

                this.$store.state.contractInstance().bet(number, amount, factor, {
                    gas: 300000,
                    value: this.$store.state.web3.web3Instance().toWei(this.totalBet, 'ether'),
                    from: this.$store.state.web3.coinbase
                }, (err, result) => {
                    if (err) {
                        console.log(err)
                    } else {
                        let Won = this.$store.state.contractInstance().Won()
                        Won.watch((err, result) => {
                            if (err) {
                                console.log('could not get event Won()')
                            } else {
                                if (this.wonCount < this.playedCount) {
                                    this.winEvent = result.args
                                    this.winEvent._totalAmount = parseFloat(web3.fromWei(result.args._amount, 'ether'))
                                    this.winEvent._winningNumber = parseInt(result.args._winningNumber)
                                    this.winEvent._betNumber = result.args._betNumber
                                    console.log("winEvent: " + this.winEvent._winningNumber)
                                    this.totalWon += this.winEvent._totalAmount;
                                    this.$store.dispatch('addWon', 1)
                                    this.wonCount = this.$store.state.rouletteComponent.wonCount
                                }
                            }
                        })
                        let Balance = this.$store.state.contractInstance().Balance()
                        Balance.watch((err, result) => {
                            if (err) {
                                console.log('could not get event Balance()')
                            } else {
                                this.balance = parseFloat(web3.fromWei(result.args._balance, 'ether'))
                            }
                        })

                    }
                    this.activeClass = 'fadeOut'
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
