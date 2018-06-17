<template>

    <b-row>
        <b-col class="mt-4" cols="3">

            <br><br><br><br><br><br><br>
            <b-row class="center pull-right" style="margin: 0;">
                <a v-on:click="play" v-bind:style="activeClass"><img id="wheel" width="400"
                                                                     height="400"
                                                                     src="../assets/roulette_wheel.png"/></a>

            </b-row>
            <div v-if="winEvent != null" style="font-size: 100px">
                {{ winEvent.winningNumber }}
            </div>
            <div v-if="winEvent != null">
                {{ lastNumbers }}
            </div>
        </b-col>
        <b-col class="mt-4 mb-5">
            <b-col>
                <b-row class="mb-3">
                    <b-col class="col-md-6">
                        <div class="pull-left">
                            Contract Balance: {{ balance }}
                            <b-button style="height: 2.5em" variant="success" v-on:click="update">
                                Update
                            </b-button>
                            <b-button style="height: 2.5em" variant="danger" v-on:click="kill">
                                Kill
                            </b-button>
                        </div>
                    </b-col>
                    <b-col class="col-md-6">
                        <div class="pull-left">
                            Deposit into contract: <input v-model="mint" placeholder="Minimum mint Ether">

                            <b-button style="height: 2.5em" variant="success" v-on:click="depositContract">
                                Deposit
                            </b-button>
                        </div>
                    </b-col>
                </b-row>
                <b-row>
                    <b-col>
                        <h1 class="pull-left">
                            <b-badge style="width: auto; align-content: center" variant="success">Welcome to the new
                                World
                                of Roulette
                            </b-badge>
                        </h1>
                    </b-col>
                </b-row>
                <b-row class="mb-3">
                    <b-col>
                        <div class="pull-left">
                            Amount to bet: <input v-model="amount" placeholder="Minimum amount Ether"> (Total Min in
                            Ether:
                            {{
                            minimum }} ({{ minimumUSD }} $), Total Max in Ether:
                            {{ maximum }} ({{ maximumUSD }} $))
                        </div>
                    </b-col>
                </b-row>
                <b-row>
                    <b-button style="width: 60em" variant="success"
                              v-on:click="clickNumber([0], 17)">
                        0
                    </b-button>
                </b-row>
                <b-row>
                    <b-col class="ml-0" cols="10.9">
                        <div>
    <span v-for="n in 36" v-if="n % 3 == 0">
    <b-button v-if="n % 2 == 0" variant="dark"
              v-on:click="clickNumber([n], Fields.FULLNUMBER)">
    {{ n }}
    </b-button>
    <b-button v-else variant="danger"
              v-on:click="clickNumber([n], Fields.FULLNUMBER)">
    {{ n }}
    </b-button>
    </span>
                            <span>
    <b-button variant="success"
              v-on:click="clickNumber(Fields.NUMBER3TO36, Fields.COLUMNS)">
    2:1
    </b-button>
    </span>
                        </div>
                        <div>
    <span v-for="n in 36" v-if="(n + 1) % 3 == 0">
    <b-button v-if="n % 2 == 0" variant="dark"
              v-on:click="clickNumber([n], Fields.FULLNUMBER)">
    {{n}}
    </b-button>
    <b-button v-else variant="danger"
              v-on:click="clickNumber([n], Fields.FULLNUMBER)">
    {{n}}
    </b-button>
    </span>
                            <span>
    <b-button variant="success"
              v-on:click="clickNumber(Fields.NUMBER2TO35, Fields.COLUMNS)">
    2:1
    </b-button>
    </span>
                        </div>
                        <div>
    <span v-for="n in 36" v-if="(n + 2) % 3 == 0">
    <b-button v-if="n % 2 == 0" variant="dark"
              v-on:click="clickNumber([n], Fields.FULLNUMBER)">
    {{n}}
    </b-button>
    <b-button v-else variant="danger"
              v-on:click="clickNumber([n], Fields.FULLNUMBER)">
    {{n}}
    </b-button>
    </span>
                            <span>
    <b-button variant="success"
              v-on:click="clickNumber(Fields.NUMBER1TO34, Fields.COLUMNS)">
    2:1
    </b-button>
    </span>
                        </div>
                    </b-col>
                </b-row>
                <b-row>
                    <b-button style="width: 20em" variant="success"
                              v-on:click="clickNumber(Fields.FIRSTDOZEN, Fields.DOZENS)">
                        1st 12
                    </b-button>
                    <b-button style="width: 20em" variant="success"
                              v-on:click="clickNumber(Fields.SECONDDOZEN, Fields.DOZENS)">
                        2nd 12
                    </b-button>
                    <b-button style="width: 20em" variant="success"
                              v-on:click="clickNumber(Fields.THIRDDOZEN, Fields.DOZENS)">
                        3rd 12
                    </b-button>
                </b-row>
                <b-row>
                    <b-button style="width: 10em" variant="success"
                              v-on:click="clickNumber(Fields.FIRSTHALF, Fields.HALFS)">
                        1 to 18
                    </b-button>
                    <b-button style="width: 10em" variant="success"
                              v-on:click="clickNumber(Fields.EVEN, Fields.ODDEVEN)">
                        EVEN
                    </b-button>
                    <b-button style="width: 10em" variant="danger"
                              v-on:click="clickNumber(Fields.RED, Fields.REDBLACK)">
                        RED
                    </b-button>
                    <b-button style="width: 10em" variant="dark"
                              v-on:click="clickNumber(Fields.BLACK, Fields.REDBLACK)">
                        BLACK
                    </b-button>
                    <b-button style="width: 10em" variant="success"
                              v-on:click="clickNumber(Fields.ODD, Fields.ODDEVEN)">
                        ODD
                    </b-button>
                    <b-button style="width: 10em" variant="success"
                              v-on:click="clickNumber(Fields.SECONDHALF, Fields.HALFS)">
                        19 to 36
                    </b-button>
                </b-row>
                <b-row>
                    <h1>
                        <b-badge style="width: 32em" variant="dark">
                            Betting: {{ totalBet }} Winnings: {{ totalWon }}
                        </b-badge>
                    </h1>
                </b-row>
                <b-row>
                    <h4>
                        Bets: {{ bets }}
                    </h4>
                </b-row>
                <b-row>
                    <b-button style="width: 30em;" variant="danger" v-on:click="removeBets">
                        <h3>Remove bets</h3>
                    </b-button>
                    <b-button style="width: 30em;" variant="warning" v-on:click="play">
                        <h1>Play</h1>
                    </b-button>
                </b-row>
            </b-col>
        </b-col>
    </b-row>

</template>

<script>
    import Col from "bootstrap-vue/es/components/layout/col";
    import Fields from '../util/constants/fields'

    export default {
        components: {Col},
        name: 'roulette',
        data() {
            return {
                mint: this.$store.state.contract.minimumMint,
                minimum: this.$store.state.contract.minimumBet,
                maximum: this.$store.state.contract.maximumBet,
                minimumUSD: this.$store.state.contract.minimumBet,
                maximumUSD: this.$store.state.contract.maximumBet,
                amount: this.$store.state.rouletteComponent.amount,
                bets: this.$store.state.rouletteComponent.bets,
                balance: this.$store.state.rouletteComponent.balance,
                winEvent: this.$store.state.rouletteComponent.winEvent,
                totalWon: this.$store.state.rouletteComponent.totalWon,
                totalBet: this.$store.state.rouletteComponent.totalBet,
                playedCount: this.$store.state.rouletteComponent.playedCount,
                wonCount: this.$store.state.rouletteComponent.wonCount,
                activeClass: '',
                Fields: Fields,
                lastNumbers: [],
                exchange: $.getJSON('https://api.coinmarketcap.com/v1/ticker/ethereum/')
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
                        this.minimumUSD = JSON.parse(this.exchange.responseText)[0].price_usd * this.minimum
                        this.amount = this.amount ? this.amount : this.minimum
                    }
                })
                this.$store.state.contractInstance().maximumBet((err, result) => {
                    if (!err && result != null) {
                        this.$store.dispatch('setMaximumBet', parseFloat(web3.fromWei(result, 'ether')))
                        this.maximum = this.$store.state.contract.maximumBet
                        this.maximumUSD = JSON.parse(this.exchange.responseText)[0].price_usd * this.maximum
                    }
                })
                this.$store.state.contractInstance().checkContractBalance((err, result) => {
                    if (!err && result != null) {
                        this.balance = parseFloat(web3.fromWei(result, 'ether'))
                    }
                })
                this.$store.dispatch('setBetAmount', 0)
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
                                this.balance = parseFloat(web3.fromWei(result.args._balance, 'ether'))
                            }
                        })
                    }
                })
            },

            clickNumber(numbers, factor) {
                if (this.amount <= 0) {
                    return
                }

                let num = this.checkSetNumbers(numbers);
                if (num > -1) {
                    this.bets.splice(num, 1)
                    this.$store.dispatch('setBetAmount', web3.fromWei(Math.round(web3.toWei(+this.totalBet - +this.$store.state.rouletteComponent.bets[num][1], 'ether')), 'ether'))
                    this.$store.dispatch('removeBet', num)
                    this.totalBet = this.$store.state.rouletteComponent.totalBet
                    return;
                }

                var number = [];
                numbers.forEach(function (element) {
                    number.push(element)
                })
                this.$store.dispatch('setBet', {
                    number: number,
                    amount: this.amount,
                    factor: factor
                })
                this.$store.dispatch('setBetAmount', web3.fromWei(Math.round(web3.toWei(+this.totalBet + +this.amount, 'ether')), 'ether'))
                this.totalBet = this.$store.state.rouletteComponent.totalBet
                let bet = []
                this.$store.state.rouletteComponent.bets.forEach(function (element) {
                    bet.push(element[0])
                });
                this.bets = bet
            },

            play() {
                if (this.totalBet < this.minimum || this.totalBet == 0 || this.maximum < this.totalBet) {
                    return;
                }

                if (this.bets.length <= 0) {
                    return;
                }

                this.activeClass = this.active()
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
                        this.activeClass = this.fadeOut()
                        console.log(err)
                    } else {
                        let Won = this.$store.state.contractInstance().Won()
                        Won.watch((err, result) => {
                            if (err) {
                                console.log('could not get event Won()')
                            } else {
                                if (this.winEvent != null) {
                                    if (this.winEvent.blockHash != result.blockHash) {
                                        this.winEvent = result
                                        this.winEvent.blockHash = result.blockHash
                                        this.winEvent.totalAmount = parseFloat(web3.fromWei(result.args._amount, 'ether'))
                                        this.winEvent.winningNumber = parseInt(result.args._winningNumber)
                                        this.winEvent.betNumber = result.args._betNumber

                                        this.totalWon += this.winEvent.totalAmount;
                                        this.$store.dispatch('addWon', 1)
                                        this.wonCount = this.$store.state.rouletteComponent.wonCount
                                        this.activeClass = this.fadeOut()
                                        this.lastNumbers = this.winEvent.betNumber
                                        this.removeBets()
                                    }
                                } else {
                                    this.winEvent = result
                                    this.winEvent.blockHash = result.blockHash
                                    this.winEvent.totalAmount = parseFloat(web3.fromWei(result.args._amount, 'ether'))
                                    this.winEvent.winningNumber = parseInt(result.args._winningNumber)
                                    this.winEvent.betNumber = result.args._betNumber

                                    this.totalWon += this.winEvent.totalAmount;
                                    this.$store.dispatch('addWon', 1)
                                    this.wonCount = this.$store.state.rouletteComponent.wonCount
                                    this.activeClass = this.fadeOut()
                                    this.lastNumbers = this.winEvent.betNumber
                                    this.removeBets()
                                }
                            }
                        })
                        let Balance = this.$store.state.contractInstance().Balance()
                        Balance.watch((err, result) => {
                            if (err) {
                                console.log('could not get event Balance()')
                            } else {
                                this.balance = parseFloat(web3.fromWei(result.args._balance, 'ether'))
                                console.log(this.balance)
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
            },

            removeBets() {
                this.bets = []
                this.$store.dispatch('clearBet')
                this.totalBet = 0;
                this.$store.dispatch('setBetAmount', this.totalBet);
                if (this.activeClass == this.active()) {
                    this.activeClass = this.fadeOut()
                }
            },

            checkSetNumbers(numbers) {
                for (let i = 0; i < this.bets.length; i++) {
                    for (let j = 0; j < this.bets[i].length; j++) {
                        if (j < numbers.length) {
                            if (this.bets[i][j] != numbers[j]) {
                                break;
                            } else {
                                if (this.bets[i][j].length == numbers[j].length) {
                                    return i;
                                }
                            }
                        } else {
                            break;
                        }
                    }
                }

                return -1;
            },

            active() {
                return '-webkit-transform: rotate(1000000000000000000000000000deg); -webkit-transition: -webkit-transform 1000000000000000000s ease-out;'
            },

            fadeOut() {
                return '-webkit-transform: rotate(600deg); -webkit-transition: -webkit-transform 2s ease-out;'
            }
        },
        beforeCreate() {
            this.$store.dispatch('getContractInstance')
        }
    }
</script>
