// Created by Raj Trivedi on 26-08-2019
// This will return String as output on every View Call made to the contract
pragma solidity >= 0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;

contract ProductSmartString {

    uint prodCount = 0;
    struct Product {
        address Owner;
        string Id;
        string Name;
        string Color; uint Status;
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
        products[prodCount] = Product(msg.sender, _id, _name, _color, 0);
        productidList.push(_id);
        emit ProductCreated(_id, _name, _color);
        prodCount += 1;
    }

    function changeProductOwner(string memory _productid, address _newOwner) public payable checkOwner(_productid){
        products[getIndex(_productid)].Owner = _newOwner;
        emit OwnerChanged(_productid, _newOwner);
    }

    function getProductById(string memory _id) public view returns(Product memory){
        for(uint i = 0 ; i<productidList.length ; i++){
            if(convertToBytes32(products[i].Id) == convertToBytes32(_id)){
                Product memory _dummy;
                _dummy.Owner = products[i].Owner;
                _dummy.Id = products[i].Id;
                _dummy.Name = products[i].Name;
                _dummy.Color = products[i].Color;
                _dummy.Status = products[i].Status;
                return _dummy;
                //return products[i];
            }
        }
    }

    function getProductsCount() public view returns (uint productCount){
        return productidList.length;
    }

    function getProductByPos(uint _ind) public view returns (Product memory){
        return products[_ind];
    }


    // Helper Functions and Modifiers defined below

    modifier checkOwner(string memory _productid){
        require(products[getIndex(_productid)].Owner == msg.sender, "Only owners can change the Owner of a Product!");
        _;
    }

    function getIndex(string memory _productid) private view returns(uint){
        uint i;
        for (i = 0; i<productidList.length; i++){
            if(convertToBytes32(products[i].Id) == convertToBytes32(_productid)){
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

    //function convertToString(bytes32 memory _byt)public returns(string memory){
    //    string memory converted = string(_byt);
    //    return converted;
    //}
}

// Dummy Products
// "A01","iPhone","Black"
// "A02","One Plus","Red"
// "A03","Apple Watch","White"