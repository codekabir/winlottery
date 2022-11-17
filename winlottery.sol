// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract lottery{
    address public manager;
    address payable[] public players;

    //those who start/deploy this contract that will be the manager
    constructor(){
        manager=msg.sender;
    }

     //manager cant participate in lottery
     //participant would be pay first to enter in lottery minimum amount shoud 1 eth; 
    function enter() payable public{
        require(msg.sender != manager,"manager can not enter");
        require(existalready()== false,"player already entered");
        require(msg.value >= 1 ether,"minimum amount must be payed");
        players.push(payable(msg.sender));
    }


    //one participant can enter one time checl function
     function existalready()view private returns(bool){
        for(uint i=0; i<players.length;i++){
            if(players[i]==msg.sender)
            return true;
        }
        return false;
     }

   //hare we janerate rendomly winner by using random function
    function random()view private returns(uint){
       return uint (sha256(abi.encodePacked(block.difficulty,block.number,block.timestamp,players)));

    }

    //only manager can pic the winner randomly
    function picwinner() public{
        require(msg.sender==manager,"only manager can pic the winner");
       uint index =random()%players.length; //winner index
       address contractaddress = address(this);
       players[index].transfer(contractaddress.balance);
       players=new address payable[](0);

    }
    function getplayers() view public returns (address payable[] memory){
        return players;
    }
}
