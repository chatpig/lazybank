// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
contract freeMint is ERC721 {
    address private _owner;
    uint public totalSupply;
    bool public isClosed;
    uint public pigFee;
    struct Pig {
        uint pigId;
        string name;
        string image;
    }
    mapping(uint => Pig) pigs;
    modifier ownerOnly() {
        require(msg.sender == _owner);
        _;
    }
    constructor() ERC721("container", "gguf")
    {
        _owner = msg.sender;
    }
    function changeOwner(address newOwner) public ownerOnly {
        _owner = newOwner;
    }
    function owner() public view returns(address) {
        return _owner;
    }
    function setPigFee(uint _cost) public ownerOnly {
        pigFee = _cost;
    }
    function redeem(address _to, uint _amount) public ownerOnly {
        (bool success, ) = _to.call{value: _amount}("");
        require(success);
    }
    function closeShop(bool _close) public ownerOnly {
        isClosed = _close;
    }
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
    function getPig(uint _id) public view returns (Pig memory) {
        return pigs[_id];
    }
    function modifyPig(uint _id, string memory _name, string memory _image) public payable {
        require(ERC721.ownerOf(_id) == msg.sender);
        require(msg.value >= pigFee);
        pigs[_id].name = _name;
        pigs[_id].image = _image;
    }
    function mint(string memory _name, string memory _image) public {
        require(!isClosed);
        totalSupply++;
        pigs[totalSupply] = Pig(totalSupply, _name, _image);
        _safeMint(msg.sender, totalSupply);
    }
    function tokenURI(uint _id) override(ERC721) public view returns (string memory) {
        string memory json = Base64.encode(
            bytes(string(
                abi.encodePacked(
                    '{'
                    '"name": "', pigs[_id].name, '",',
                    '"image": "', pigs[_id].image, '"',
                    '}'
                )
            ))
        );
        return string(abi.encodePacked('data:application/json;base64,', json));
    }
}
