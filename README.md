# Unis vs Dinos

## Contracts relationship
![Alt text](contracts_rel.jpg?raw=true "Contracts relationship")


## Simple reference to use truffle and testrpc
[The Hitchhiker’s Guide to Smart Contracts in Ethereum](https://blog.zeppelin.solutions/the-hitchhikers-guide-to-smart-contracts-in-ethereum-848f08001f05)

## Simple reference to debug with truffle

## Test
### 1. testrpc ( local ethereum blockchain )

Install and start testrpc
```
$ npm install -g ethereumjs-testrpc
$ testrpc
```

### 2. Truffle
#### *Note: All the values are in wei, you can use this to transform to wei [ETH Calculator](https://etherconverter.online/)

Install truffle
```
$ npm install -g truffle
```

Clone this proyect
```
$ git clone ...
```

Open truffle console develop in proyect directory
```
$ truffle develop
```

In console, migrate the contracts
```
truffle(develop)> migrate --reset
```

List the address of this local test blockchain
```
var accounts;
truffle(develop)> web3.eth.getAccounts(function(err,res) { accounts = res; });
truffle(develop)> var account1 = accounts[0];
truffle(develop)> var account2 = accounts[1];
```

Set the address of Auction contract
```
truffle(develop)> Legends.deployed().then(function(instance){return instance.setSaleAuctionAddress(SaleClockAuction.address);});
```

Buy a Legend gen0 with Random Attrs ( like a loot box )
```
truffle(develop)> Legends.deployed().then(function(instance){return instance.buyRandomLegend({value:300000000000000000});});
```

Put a legend in auction
```
truffle(develop)> Legends.deployed().then(function(instance){return instance.legendToMarket(2, 300000000000000000, 300000000000000000);});
```

Get the detail of an auction
```
truffle(develop)> SaleClockAuction.deployed().then(function(instance){return instance.getAuction(2);});
```

Bid ( buy ) a Legend from in auction
```
truffle(develop)> SaleClockAuction.deployed().then(function(instance){return instance.bid(2, {value:300000000000000000, from: account2});});
```

List number of Legends of each account
```
truffle(develop)> Legends.deployed().then(function(instance){return instance.balanceOf(account1);});
truffle(develop)> Legends.deployed().then(function(instance){return instance.balanceOf(account2);});
```

List id of Legends owned by an address
```
truffle(develop)> Legends.deployed().then(function(instance){return instance.tokensOfOwner(account1);});
truffle(develop)> Legends.deployed().then(function(instance){return instance.tokensOfOwner(account2);});
```
