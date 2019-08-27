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
        bytes32 Id,
        bytes32 Name,
        bytes32 Color,
        uint Status 
    );
    
    event OwnerChanged(
        string Id,
        address NewOwner 
    );
    
    mapping(uint => Product) products; //Mapping key to Product
    string[] productidList;
    
    
    function addProduct(string memory _id, string memory _name, string memory  _color) payable public {
        products[prodCount] = Product(msg.sender, convertToBytes32(_id), convertToBytes32(_name), convertToBytes32(_color), 0);
        productidList.push(_id);
        prodCount += 1;
    }
    
    function changeProductOwner(string memory _productid, address _newOwner) payable public checkOwner(_productid){
        products[getIndex(_productid)].Owner = _newOwner;
        emit OwnerChanged(_productid, _newOwner);
    }
    
    function getProductById(string memory _id) public returns (Product memory){
        for(uint i=0;i<productidList.length;i++){
            if(products[i].Id == convertToBytes32(_id)){
                Product memory _dummy;
                _dummy.Owner = products[i].Owner;
                _dummy.Id = products[i].Id;
                _dummy.Name = products[i].Name;
                _dummy.Color = products[i].Color;
                _dummy.Status = products[i].Status;
                emit ProductCreated(products[i].Id, products[i].Name, products[i].Color, products[i].Status);
                //return products[i];
            }
        }
    }
    
    function getProductsCount() public view returns (uint productCount){
        return productidList.length;
    }
    
    function getProductByPos(uint _ind)view public returns (Product memory){
        return products[_ind];
    }
    
    // Helper Functions and Modifiers defined below
    
    function getIndex(string memory _productid) private returns(uint){
        uint i;
        for (i = 0; i<productidList.length; i++){
            if(products[i].Id == convertToBytes32(_productid)){
                return i;
            }
        }
    }
    
    function convertToBytes32(string memory source) view private returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }
        assembly {
            result := mload(add(source, 32))
        }
    }
    
    modifier checkOwner(string memory _productid){
        require(products[getIndex(_productid)].Owner == msg.sender);
        _;
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