pragma solidity ^0.4.18;

contract ItemsSystem is AccessControl {

	struct Item {
		uint id;
		string name;
		uint attirbuteId1;
		uint attribute1Bonus;
		uint attirbuteId2;
		uint attribute2Bonus;

	}

	mapping (uint => Challenge) public items;

	// Create a new Item, important to have Unique ID
	function createItem(uint _id, string _name, uint _attirbuteId1, uint _attribute1Bonus, uint _attirbuteId2, uint _attribute2Bonus) onlyCOO {

		Item memory _item = Item({
			id: _id,
            name: _name,
            attirbuteId1: _attirbuteId1,
            attribute1Bonus: _attribute1Bonus,
            attirbuteId2: _attirbuteId2,
            attribute2Bonus: _attribute2Bonus
        });

        items[_id] = _item;
	}

	// Edit a Item, important to have Unique ID
	function editItem(uint _id, string _name, uint _attirbuteId1, uint _attribute1Bonus, uint _attirbuteId2, uint _attribute2Bonus) external onlyCOO {

		Item storage _item = items[_id];
		_item.name = _name;
		_item.attirbuteId1 = _attirbuteId1;
		_item.attribute1Bonus = _attribute1Bonus;
		_item.attirbuteId2 = _attirbuteId2;
		_item.attribute2Bonus = _attribute2Bonus;
	}

}