const util = require("./util.js");

const Beasts = artifacts.require("./Beasts.sol");
const SaleClockAuction = artifacts.require("./auction/SaleClockAuction.sol");
const SiringClockAuction = artifacts.require("./auction/SiringClockAuction.sol");

// https://github.com/dapperlabs/cryptokitties-bounty/blob/master/test/kitty-core.test.js

contract('Beast', async (accounts) => {
    before(() => util.measureGas(accounts));
    after(() => util.measureGas(accounts));

    let beasts, saleAuction, siringAuction;;

    const ceo = accounts[0];
    const coo = accounts[1];
    const cfo = accounts[2];
    const user1 = accounts[3];
    const user2 = accounts[4];
    const user3 = accounts[5];

    async function deployContract() {
        beasts = await Beasts.new();
        saleAuction = await SaleClockAuction.new(beasts.address, 900);
        siringAuction = await SiringClockAuction.new(beasts.address, 900);
        await beasts.setSaleAuctionAddress(saleAuction.address, { from: ceo });
        await beasts.setSiringAuctionAddress(siringAuction.address, { from: ceo });
    }

    describe("Contracts Ownership", async () => {

        before(async function () {
            await deployContract();
        });

        it("CEO, CFO and COO must be settled with the deployer address", async () => {
            assert.equal(await beasts.ceoAddress(), ceo);
            assert.equal(await beasts.cfoAddress(), ceo);
            assert.equal(await beasts.cooAddress(), ceo);
        })

        it("Initial beasts must be assigned to CEO address", async () => {
            assert.equal(await beasts.ownerOf(0), await beasts.ceoAddress());
            assert.equal(await beasts.ownerOf(1), await beasts.ceoAddress());
            assert.equal(await beasts.ownerOf(2), await beasts.ceoAddress());
        })

        it("Must create a promo beast and assign to a specific address", async () => {
            await beasts.createPromoBeast(1000, user3);
            assert.equal(await beasts.balanceOf(user3), 1);
            assert.equal(await beasts.ownerOf(3), user3);
        })

        it("CEO, CFO and COO can be edited", async () => {

            await beasts.setCOO(coo);
            await beasts.setCFO(cfo);
            await beasts.setCEO(user1);
            assert.equal(await beasts.ceoAddress(), user1);
            assert.equal(await beasts.cfoAddress(), cfo);
            assert.equal(await beasts.cooAddress(), coo);
        })
    })

    describe("Auction wrapper", function () {

        const beastId1 = 3,
            beastId2 = 4,
            beastId3 = 5;

        before(async function () {
            await deployContract();

            await beasts.createPromoBeast(1000, user1);
            await beasts.createPromoBeast(1000, user1);
            await beasts.createPromoBeast(1000, user1);

            await beasts.transfer(user2, beastId2, { from: user1 });
            await beasts.transfer(user2, beastId3, { from: user1 });
        });

        it("non-CEO should fail to set auction addresses", async function () {
            await util.expectThrow(
                beasts.setSaleAuctionAddress(saleAuction.address, { from: coo })
            );
            await util.expectThrow(
                beasts.setSiringAuctionAddress(siringAuction.address, { from: coo })
            );
        });

        it("CEO should be able to set auction addresses", async function () {
            await beasts.setSaleAuctionAddress(saleAuction.address, { from: ceo });
            await beasts.setSiringAuctionAddress(siringAuction.address, { from: ceo });
        });


        it("should fail to create sale auction if not cat owner", async function () {
            await util.expectThrow(
                beasts.createSaleAuction(beastId1, 100, 200, 60, { from: coo })
            );
        });

        it("should be able to create sale auction", async function () {

            await beasts.createSaleAuction(beastId1, 300000000000000000, 300000000000000000, 7200, { from: user1 });
            const kitty1Owner = await beasts.ownerOf(beastId1);
            assert.equal(kitty1Owner, saleAuction.address);
        });

        it("should fail to breed if sire is on sale auction", async function () {
            await util.expectThrow(
                beasts.breedWithAuto(beastId2, beastId1, { from: user2 })
            );
        });

        it("should be able to bid on sale auction", async function () {
            const cooBal1 = await web3.eth.getBalance(user2);

            await saleAuction.bid(beastId1, { from: user2, value: 400000000000000000 });

            const cooBal2 = await web3.eth.getBalance(user2);
            const kitty1Owner = await beasts.ownerOf(beastId1);
            assert.equal(kitty1Owner, user2);
            // Transfer the kitty back to coo for the rest of the tests
            await beasts.transfer(user1, beastId1, { from: user2 });
        });

    });
})