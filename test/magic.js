const util = require("./util.js");

const Beasts = artifacts.require("./Beasts.sol");
const GeneMagic = artifacts.require("./GeneMagic.sol");

contract("Genes", async (accounts) => {
    before(() => util.measureGas(accounts));
    after(() => util.measureGas(accounts));

    let beasts, geneMagic;

    const ceo = accounts[0];
    const coo = accounts[1];
    const cfo = accounts[2];
    const user1 = accounts[3];
    const user2 = accounts[4];
    const unused = accounts[5];

    async function deployContract() {

        geneMagic = await GeneMagic.new();
        beasts = await Beasts.new();

        await geneMagic.setBeastContract(ceo, { from: ceo });
        await geneMagic.resetDinosGenes({ from: ceo });
        await geneMagic.resetUnisGenes({ from: ceo });
        await geneMagic.resetCommonGenes({ from: ceo });
    }

    describe("Magic Usage", async () => {

        before(async function () {
            await deployContract();
        });

        it("Non CEO user must fail on edit magic address", async () => {
            await util.expectThrow(
                beasts.setGeneMagicAddress(unused, { from: user1 })
            );
        })

        it("CEO can edit magic address", async () => {
            await beasts.setGeneMagicAddress(geneMagic.address, { from: ceo });
            const currentGeneMagicAddress = await beasts.geneMagic();
            assert.equal(geneMagic.address, currentGeneMagicAddress);
        })

        it("Non CEO user must fail on sets of variables", async () => {
            await util.expectThrow(
                geneMagic.set_arr_u_type([0, 5, 4, 3, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], { from: user1 })
            );
        })

        it("CEO can set variables", async () => {
            await geneMagic.set_arr_u_type([0, 5, 4, 3, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], { from: ceo });
        })

        it("Beast Contract can create a random gene", async () => {
            const genes = await geneMagic.createGenes(1, "180148383141330944", { from: ceo });
            console.log("genes =>", genes);
            assert.equal(genes, 0);
        })

        it("CEO can create genes", async () => {
            const genes = await geneMagic.mixGenes(1, 181307339299784772, 469537716561876003, 5, { from: ceo });
            console.log("genes => ", genes);
            assert.equal(genes, 0);
        })
    })
})
