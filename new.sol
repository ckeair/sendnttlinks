//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";


contract Onboard is ERC1155, Ownable {

    
    string public name;
    string public symbol;
    mapping (uint256 => string) private tokenURI;
    mapping(address => mapping (uint256 => uint256))  public supplyBalance;


    constructor() ERC1155("") {
        name = "onboard";
        symbol = "onboard";

    }

    function mintNtt(address _adr, uint256 tokenid ) external { // removed onlyOwner for demo
            require(supplyBalance[_adr][tokenid] < 1, "Already owns Quiz1 NFT");
            _mint(_adr, tokenid, 1, "");
            supplyBalance[msg.sender][tokenid] += 1;
    }

    function burnToken(address _adr, uint256 _id) external onlyOwner {
            _burn(_adr, _id, 1);
            supplyBalance[msg.sender][_id] -= 1;
    }


 function setURI(uint _id, string memory _uri) external onlyOwner {
    tokenURI[_id] = _uri;
    emit URI(_uri, _id);
  }

  function uri(uint _id) public override view returns (string memory) {
    return tokenURI[_id];
  }

    
    
    //Make Nontranferable
    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual override {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
        // Ignore transfers during minting
        if (from == address(0)) {
            return;
        }
        require(
            to == address(0),
            "no transfer "
        );
    }


}
