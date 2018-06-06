# Roulette-Ethereum-dApp

> A Vue.js Roulette dApp

## Anleitung zur Installation
``` bash
# php storm plugin (nice to have)
install stylus assist in preferencis -> plugins

# install dependencies
npm install

#install truffle in project (-D) and globally (-g)
npm i -D -g truffle 
```

1. Projekt clonen
2. Metamask Account einrichten
3. Browserplugin für Metamask installieren
4. https://remix.ethereum.org
5. Roulette.sol kopieren und in die Remix IDE kopieren
6. Compiler-Version der Remix IDE auf 0.4.24 setzen
7. Contract deployen
8. Contract Address kopieren und in getContract.js einfügen


``` bash
# run project on localhost:8080
npm run dev

# build for production with minification
npm run build

# build for production and view the bundle analyzer report
npm run build --report

#compile solidity files
truffle compile
```

9. index.html im Browser aufrufen

## Sonstiges

``` bash
# "npm run dev" error handling
npm install --save bignumber.js

# "truffle compile" error handling (truffle compile error parsing expected identifier, got LParen)
npm uninstall -g truffle
npm uninstall -g solc
npm install -g truffle

# run tests
npm run unit
npm run e2e
npm test
