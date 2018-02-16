# Unis vs Dinos

Contracts relationship
![Alt text](contracts_rel.jpg?raw=true "Contracts relationship")

Simple reference to use truffle and testrpc
https://blog.zeppelin.solutions/the-hitchhikers-guide-to-smart-contracts-in-ethereum-848f08001f05

1. testrpc ( local ethereum blockchain )

// Install and start testrpc
$ npm install -g ethereumjs-testrpc
$ testrpc

2. Truffle

// Install truffle
$ npm install -g truffle

// Clone this proyect
$ git clone ...

// Compile contracts
$ truffle compile

// Migrate contracts to testrpc using the develop network (see truffle.js config file)
$ truffle migrate

3. Test on rpc

// command to start the truffle console
> truffle console

// create the reference to contract
truffle(development)> var bm = BeastMinting.at(BeastMinting.address);

// create a new promo Beast
truffle(development)> bm.createPromoBeast(12345, "0x3fe29b33ce525dab676918cd726d1c4f37c7777d");

// Print the data of the 1st event ( Birth ) after the creation of a promo Beast
truffle(development)> bm.createPromoBeast(12345, "0x3fe29b33ce525dab676918cd726d1c4f37c7777d").then(function(ret){console.log(ret.logs[0].args.owner);console.log(ret.logs[0].args.beastId);console.log(ret.logs[0].args.genes);}); 
