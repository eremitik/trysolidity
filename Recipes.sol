pragma solidity ^0.6.0;

//Combine multiple contract tx into one contract
contract Utils {
    function groupExecute(uint argA, uint argB) external {
        ContractA(0x....).foo(argA);
        ContractB(0x....).bar(argB);
    }
}

contract ContractA {
    function foo(uint arg) external {
        //do something
    }
}

contract ContractB {
    function bar(uint arg) external {
        //do something else
    }
}


//Factory-Child pattern                                                
contract Factory {                               
    Child[] public children;                     
    event ChildCreated(                          
        uint date,                               
        uint data,                               
        address childAddress                 
    );                                            
    function createChild(uint _data) external {  
        Child child = Child(_data);          
        children.push(child);                    
        emit ChildCreated(                       
            now,                                 
            _data,                               
            address(child)                       
        );                                       
    }                                            
}                                                
                                                 
contract Child {                                 
    uint data;                                   
    constructor(uint _data) public {             
        data = _data;                            
    }                                            
}                                                



// When you want to re-order an array
contract Reorder {
    
    string[] public data;
    
    constructor() public {
        data.push("John");
        data.push("Bruce");
        data.push("Tom");
        data.push("Bart");
        data.push("Cherry");
    }
    
    function removeNoOrder(uint index) external {
        data[index] = data[data.length-1];
        data.pop();
    }
    
    function removeInOrder(uint index) external {
        for(uint i=index; i<data.length-1; i++){
            data[i] = data[i+1];
        }
        data.pop();
    }
}
