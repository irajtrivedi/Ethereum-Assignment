// Created by Raj Trivedi on 26-08-2019
// In this Contract the returning bytes has to be converted to String while displaying on any GUI
pragma solidity >= 0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;

contract ProductSmartBytes {

    uint prodCount = 0;
    struct Product {
        address Owner;
        bytes32 Id;
        bytes32 Name;
        bytes32 Color;
        uint Status;
    }

    event ProductCreated(
        string Id,
        string Name,
        string Color
    );

    event OwnerChanged(
        string Id,
        address NewOwner
    );

    mapping(uint => Product) products; //Mapping key to Product
    string[] productidList;


    function addProduct(string memory _id, string memory _name, string memory  _color) public payable {
        products[prodCount] = Product(msg.sender, convertToBytes32(_id), convertToBytes32(_name), convertToBytes32(_color), 0);
        productidList.push(_id);
        // Event returns values in String so that same can be captured in GUI. We need not have to convert in Web3.js
        emit ProductCreated(_id, _name, _color);
        prodCount += 1;
    }

    function changeProductOwner(string memory _productid, address _newOwner) public payable checkOwner(_productid){
        products[getIndex(_productid)].Owner = _newOwner;
        emit OwnerChanged(_productid, _newOwner);
    }

    function getProductById(string memory _id) public view returns (Product memory){
        for(uint i = 0 ; i<productidList.length ; i++){
            if(products[i].Id == convertToBytes32(_id)){
                Product memory _dummy;
                _dummy.Owner = products[i].Owner;
                _dummy.Id = products[i].Id;
                _dummy.Name = products[i].Name;
                _dummy.Color = products[i].Color;
                _dummy.Status = products[i].Status;
                return _dummy;
            }
        }
    }

    function getProductsCount() public view returns (uint productCount){
        return productidList.length;
    }

    function getProductByPos(uint _ind)public view returns (Product memory){
        return products[_ind];
    }

    // Helper Functions and Modifiers defined below

    function getIndex(string memory _productid) private view returns(uint){
        uint i;
        for (i = 0; i<productidList.length; i++){
            if(products[i].Id == convertToBytes32(_productid)){
                return i;
            }
        }
    }

    function convertToBytes32(string memory source) private pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }
        assembly {
            result := mload(add(source, 32))
        }
    }

    modifier checkOwner(string memory _productid){
        require(products[getIndex(_productid)].Owner == msg.sender, "Only owners can change the Owner of a Product!");
        _;
    }

    function bytes32ToString(bytes32 x) private pure returns (string memory) {
        bytes memory bytesString = new bytes(32);
        uint charCount = 0;
        for (uint j = 0; j < 32; j++) {
            byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
            if (char != 0) {
                bytesString[charCount] = char;
                charCount++;
            }
        }
        bytes memory bytesStringTrimmed = new bytes(charCount);
        for (uint j = 0; j < charCount; j++) {
            bytesStringTrimmed[j] = bytesString[j];
        }
        return string(bytesStringTrimmed);
    }
}

// Dummy Products
// "A01","iPhone","Black"
// "A02","One Plus","Red"
// "A03","Apple Watch","White"