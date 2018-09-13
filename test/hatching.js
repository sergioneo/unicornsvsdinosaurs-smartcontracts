const util = require("./util.js");

const Beasts = artifacts.require("./Beasts.sol");
const EggFactory = artifacts.require("./EggFactory.sol");
const SplitPayment = artifacts.require("./SplitPayment.sol");

contract("Hatch", async (accounts) => {
    before(() => util.measureGas(accounts));
    after(() => util.measureGas(accounts));

    let beasts, eggFactory, splitPayment;

    const ceo = accounts[0];
    const coo = accounts[1];
    const cfo = accounts[2];
    const user1 = accounts[3];
    const user2 = accounts[4];
    const investor1 = accounts[5];
    const investor2 = accounts[6];

    async function deployContract() {

        splitPayment = await SplitPayment.new([investor1, ceo], [50, 50]);
        eggFactory = await EggFactory.new(splitPayment.address, { from: ceo });
        beasts = await Beasts.new();

        await beasts.setEggFactoryAddress(eggFactory.address, { from: ceo });
    }

    describe("Egg Market", async () => {

        before(async function () {
            await deployContract();
        });

        it("Non CEO user must fail on create egg scheme", async () => {
            await util.expectThrow(
                eggFactory.createEggScheme(1, 200, 4, 36028797018963968, 10000000000000000, 1500000000000000, true, false, { from: user1 })
            );
        })

        it("CEO can create an egg schemes", async () => {
            await eggFactory.createEggScheme(1, 200, 4, 36028797018963968, 10000000000000000, 1500000000000000, true, false, { from: ceo });
            await eggFactory.createEggScheme(2, 200, 4, 0, 10000000000000000, 1500000000000000, true, false, { from: ceo });

            const eggsIds = await eggFactory.listEggsIds();
            assert.equal(eggsIds[0], 1);
            assert.equal(eggsIds[1], 2);
        })

        it("User can buy 1 egg", async () => {
            const currentPrice = await eggFactory.currentEggPrice(1);

            await eggFactory.buyEgg(1, 1, { from: user1, value: currentPrice });
            const eggsOwned = await eggFactory.eggsOwned(user1, 1);
            assert.equal(eggsOwned, 1);
        })

        it("User fail on buy for invalid paid amount", async () => {
            await util.expectThrow(
                eggFactory.buyEgg(1, 1, { from: user1, value: 0 })
            );
        })

        it("User can buy 2 consecutives eggs with price increase", async () => {
            let currentPrice = await eggFactory.currentEggPrice(1);
            await eggFactory.buyEgg(1, 1, { from: user1, value: currentPrice });
            currentPrice = await eggFactory.currentEggPrice(1);
            await eggFactory.buyEgg(1, 1, { from: user1, value: currentPrice });
            const eggsOwned = await eggFactory.eggsOwned(user1, 1);
            assert.equal(eggsOwned, 3);
        })

        it("User can buy max amount of eggs respecting the price with no increase", async () => {
            const currentPrice = await eggFactory.currentEggPrice(1);
            const egg = await eggFactory.eggs(1);

            await eggFactory.buyEgg(1, egg[4], { from: user1, value: currentPrice * egg[4] });
            const eggsOwned = await eggFactory.eggsOwned(user1, 1);
            assert.equal(eggsOwned, 7);
        })

        it("User fail at buy more than max", async () => {
            await util.expectThrow(
                eggFactory.buyEgg(1, 10, { from: user1, value: 20500000000000000 })
            );
        })

        /*
        it("User fail at open egg if egg hasn't the state of can be opened", async () => {
            await util.expectThrow(
                await beasts.hatchEgg(1, 1, { from: user1 })
            );
        })
        

        it("User fail at set egg state to can be opened", async () => {
            await util.expectThrow(
                eggFactory.setOpenStatusEgg(1, true, { from: user1 })
            );
        })

        it("CEO can set egg state to can be opened", async () => {
            await eggFactory.setOpenStatusEgg(1, true, { from: ceo });
            const egg = await eggFactory.eggs(1);
            assert.equal(egg[8], true);
        })
        */

        it("User fail at open egg because try to open more of what he have", async () => {
            await util.expectThrow(
                beasts.hatchEgg(1, 10, { from: user1 })
            );
        })

        it("User can open 1 egg", async () => {
            await beasts.hatchEgg(1, 1, { from: user1 });
            assert.equal(await beasts.balanceOf(user1), 1);
        })

        it("User can open all eggs", async () => {
            await beasts.hatchEgg(1, 6, { from: user1 });
            const beastsEggsOwned = await beasts.eggsOwned(user1, 1);
            const eggFactoryEggsOwned = await eggFactory.eggsOwned(user1, 1);
            const balanceOf = await beasts.balanceOf(user1);

            assert.equal(beastsEggsOwned.toNumber(), eggFactoryEggsOwned.toNumber());
            assert.equal(balanceOf.toNumber(), eggFactoryEggsOwned.toNumber());
        })

        it("User fail at open egg because no have more eggs", async () => {
            await util.expectThrow(
                beasts.hatchEgg(1, 1, { from: user1 })
            );
        })
    })
})