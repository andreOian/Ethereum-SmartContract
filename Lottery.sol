pragma solidity ^0.4.24;

contract Lottery {
    address[] public players; // dynamic with players addresses
    address public manager;
    
    constructor() public {
        manager = msg.sender;
    }
    
    // this fallback payble functionwill be automatically called when somebody sends ether to our contract address
    function () payable public {
        require(msg.value >= 0.01 ether);
        players.push(msg.sender); // add the address of the account that sends ether to players array
    }
    
    function get_balance() public view returns(uint) {
        require(msg.sender == manager);
        return address(this).balance; // return contract balance
    }
    
    function random() public view returns(uint256) {
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }
    
    function selectWinner() public {
        require(msg.sender == manager);
        
        uint256 r = random();
        
        address winner;
        
        uint index = r % players.length;
        winner = players[index];
        
        // transfer contract balanca to the winner address
        winner.transfer(address(this).balance);
        
        players = new address[](0); // resetting the players dynamic array
    }
    
}