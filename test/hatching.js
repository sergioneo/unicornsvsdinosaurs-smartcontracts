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
                eggFactory.createEggScheme(1, 200, 4, 36030996042219520, 10000000000000000, 1500000000000000, true, false, { from: user1 })
            );
        })

        it("CEO can create an egg schemes", async () => {
            await eggFactory.createEggScheme(1, 200, 4, 36030996042219520, 10000000000000000, 1500000000000000, true, false, { from: ceo });
            await eggFactory.createEggScheme(2, 200, 4, 36030996042219520, 10000000000000000, 1500000000000000, true, false, { from: ceo });

            const eggsIds = await eggFactory.listEggsIds();
            assert.equal(eggsIds[0], 1);
            assert.equal(eggsIds[1], 2);
        })
    })
})