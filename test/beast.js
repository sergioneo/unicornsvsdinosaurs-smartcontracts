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

    it("Bestia inicial (Teseract) debe ser asignada al CEO", async () => {
        assert.equal(await beasts.ownerOf(0), await beasts.ceoAddress());
    })

    it("Se debe crear una bestia Promo y asignar a una cuenta", async () => {
        await beasts.createPromoBeast(1000, accounts[1]);
        assert.equal(await beasts.balanceOf(accounts[1]), 1);
        assert.equal(await beasts.ownerOf(1), accounts[1]);
    })
})