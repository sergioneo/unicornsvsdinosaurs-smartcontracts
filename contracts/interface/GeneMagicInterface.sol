pragma solidity ^0.4.18;

/// @title SEKRETOOOO
contract GeneMagicInterface {

    function isGeneMagic() public pure returns (bool);
    function getBeastType(uint256 genes) public pure returns (uint8);
    function mixGenes(uint256 genesMother, uint256 genesFather) public constant returns(uint256);
}