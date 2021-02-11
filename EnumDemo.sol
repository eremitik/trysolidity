pragma solidity ^0.6.8;

contract Enums {
    
    // Enemy monsters in a game
    enum Level {
        SPIDER,
        SNAKE,
        BAT,
        IRON
    }
    
    // Setup 'level' to check the current level gamer is on
    Level public level = Level.SPIDER;
    
    // After the level is complete, this function calls nextLevel
    function completeLevel() public returns (uint) {
        nextLevel();
        return uint(level);
    }
    
    // Adds one to the integer lookup within enum
    function nextLevel() internal {
        level = Level(uint(level)+1);
    }
    

}
