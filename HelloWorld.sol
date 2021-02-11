pragma solidity ^0.6.0;

contract A {
    address addressB;
    
    //1. cannot simply set new variable as in JS, so need a function to set
    function setAddressB(address _addressB) external {
        addressB = _addressB;
    }
    
    //2. once address B is set, can call function to execute contract B
    function callHelloWorld() external view returns (string memory) {
        B b = B(addressB);
        return b.helloWorld();
    }
    
}

contract B {
    function helloWorld() external pure returns(string memory) {
        return 'HelloWorld';
    }
}
