var Beasts = artifacts.require("./Beasts.sol");

//https://github.com/dapperlabs/cryptokitties-bounty/blob/master/test/kitty-core.test.js
contract('Beast', async (accounts) => {
    let beasts;

    beforeEach(async function () {
        beasts = await Beasts.new();
    });

    it("El CEO, CFO y COO del contrato debe ser quien hace deploy", async () => {
        assert.equal(await beasts.ceoAddress(), accounts[0]);
        assert.equal(await beasts.cfoAddress(), accounts[0]);
        assert.equal(await beasts.cooAddress(), accounts[0]);
    })

    it("El CEO, CFO y COO se debe modificar", async () => {
        await beasts.setCOO(accounts[1]);
        await beasts.setCFO(accounts[1]);
        await beasts.setCEO(accounts[1]);
        assert.equal(await beasts.ceoAddress(), accounts[1]);
        assert.equal(await beasts.cfoAddress(), accounts[1]);
        assert.equal(await beasts.cooAddress(), accounts[1]);
    })


})