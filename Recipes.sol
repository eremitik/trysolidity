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



// Using array vs. mapping. In this case, saves gas. Not ideal for unique ids however, i.e. adding in address to struct
contract Collections {
    
    struct User {
        uint id;
        string name;
    }
    
    // User[] users;
    mapping(uint => User) users;
    uint nextUserId;
}



// Returning arrays as a 'print', two methods
contract Collections {
    struct User {
        address userAddress;
        uint balance;
    }
    User[] users;
    
    function getUsers1() external returns(address[] memory, uint[] memory) {
        address[] memory userAddresses = new address[](users.length);
        uint[] memory balances = new uint[](users.length);
        
        for(uint i=0; i<users.length; i++){
            userAddresses[i] = users[i].userAddress;
            balances[i] = users[i].balance;
        }
        return (userAddresses, balances);
    }
    
    // this function version requires 'pragma experimental ABIEncoderV2'
    function getUsers2() external returns(address[] memory, uint[] memory) {
        return users;
    }
}



// Generate random numbers, safely
contract Oracle {
    
    address admin;
    uint public rand;

    constructor() public {
        admin = msg.sender
    }
    
    function feedRandomness(uint _rand) external {
        require(msg.sender == admin);
        rand = _rand;
    }
}

contract RandomNum {
    
    Oracle oracle;
    
    constructor(address oracleAddress) public {
        oracle = Oracle(oracleAddress);
    }
    
    // oracle.rand() adds a level of safety to prevent reliance on miner's control of block.difficulty
    function randModulus(uint mod) external view returns(uint) {
        
        // calculate hash
        return uint(keccak256(abi.encodePacked(
            oracle.rand(),
            now, 
            block.difficulty, 
            msg.sender
            ))) % mod;
    }
}



// Manipulating strings
// In general, avoid these as it takes up resources; use bytes instead if necessary
contract StringManipulation {
    
    function length(string calldata str) external pure returns(uint) {
        return bytes(str).length;
    }
    
    function concatenate(string calldata a, string calldata b) external pure returns(string memory) {
        return string(abi.encodePacked(a, b));
    }
    
    function reverse(string calldata _str) external pure returns(string memory) {
        bytes memory str = bytes(_str);
        string memory tmp = new string(str.length);
        bytes memory _reverse = bytes(tmp);
        
        for(uint i=0; i<str.length; i++){
            _reverse[str.length-i-1] = str[i];
        }
        return string(_reverse);
    }
    
    function compare(string calldata a, string calldata b) external pure returns(bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }
}



// Centralised mgmt of contract addresses
import "./Token.sol";

contract Registry {
    
    mapping(string => address) public tokens;
    address admin;
    
    constructor() public {
        admin = msg.sender;
    }
    
    function updateToken(string calldata id, address tokenAddress) external {
        require(msg.sender == admin);
        tokens[id] = tokenAddress;
    }
}

contract A {
    
    Registry token;
    address admin;
    
    constructor() public {
        admin = msg.sender;
    }
    
    function updateRegistry(address registryAddress) external {
        require(msg.sender == admin);
        registry = Registry(registryAddress);
    }
    
    function foo() external {
        Token token = Token(registry.tokens("ABC"));
        token.transfer(100, msg.sender);
    }
}



// Faucet functionality
// When in truffle, replace the below url with npm package
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    
    constructor(string memory name, string memory symbol) ERC20(name, symbol) public {} 
    
    function mint(address recipient, uint amount) external {
        _mint(receipient, amount);
    }
}



// Wrapped Ether token
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract WETH is ERC20 {
    
    constructor() ERC20("Wrapped Ether", "WETH") public {}
    
    function mint() external payable {
        _mint(msg.sender, msg.value);
    }
    
    function burn(uint amount) external {
        msg.sender.transfer(amount);
        _burn(msg.sender, amount);
    }
}



// Make smart contract updatable with adapter pattern
import './Adapter.sol';
import './Token.sol';

contract MyContract {
    Adapter adapter;
    Token token;
    
    constructor(address tokenAddress) public {
        token = Token(tokenAdress);
    }
    
    // Business logic in Adapter.sol, so can keep updating exchanges, logic, etc.
    function updateAdapter(address adapterAddress) external {
        adapter = Adapter(adapterAddress);
    }
    
    function invest(uint amount) external {
        token.approve(address(adapter), amount);
        address bestExchange = adapter.getBestExchangeFor(address(token));
        adapter.invest(amount, address(token), bestExchange);
    }
}



// DRY code
contract MyContract {
    
    function A() external onlyAdmin() {
        // msg.sender.send(100);
        // balances[msg.sender] -= 100;
        // require(msg.sender == admin);
        _transferEther();
    }
    
    function B() external onlyAdmin() {
        // msg.sender.send(100);
        // balances[msg.sender] -= 100;
        // require(msg.sender == admin);
        _transferEther();
    }
    
    function _transferEther() internal {
        msg.sender.send(100);
        balances[msg.sender] -= 100;
    }
    
    modified onlyAdmin() {
        require(msg.sender == admin);
        _;
    }
}



// Calc percentages
contract MyContract {
    
    // fee is 185bps
    function calculateFee(uint amount) external pure returns(uint) {
        // return (amount / 10000) * 185; 
        require((amount / 10000) * 10000 == amount, 'too small');
        return amount * 185 / 10000;
    }
}



// Circuit breaker, unsafe method (best way to to breakout the isActive bool into a separate contract)
// 'Pausible' in OpenZeppelin is a better solution
contract MyContract {
    
    bool isActive = true;
    address admin;
    
    constructor() public {
        admin = msg.sender;
    }
    
    function toggleCircuitBreaker() external {
        require(admin == msg.sender);
        isActive = !isActive;
    }
    
    function withdraw() external contractIsActive() {
        
    }
    
    receive() external payable contractIsActive {
        
    }
    
    modifier contractIsActive() {
        require(isActive == true);
        _;
    }
}
