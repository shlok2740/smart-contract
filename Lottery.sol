// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

contract Lottery {
    address public owner;
    address payable[] public players;
    uint public lotteryId;
    mapping(uint => address payable) public lotteryHistory;

    constructor() {
        owner = msg.sender;
        lotteryId = 1;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function getWinnerByLottery(uint lottery) public view returns (address payable) {
        return lotteryHistory[lottery];
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    function enter() payable public {
        require(msg.value > .01 ether);
        players.push(payable(msg.sender));
    }

    function getRandomNumber() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(owner,block.timestamp)));
    }

    function pickWinner() public onlyOwner {
        uint index = getRandomNumber() % players.length ;
        players[index].transfer(address(this).balance);
        
        lotteryHistory[lotteryId]=players[index];
        lotteryId++;
        
        players = new address payable[](0) ;
    }


}
