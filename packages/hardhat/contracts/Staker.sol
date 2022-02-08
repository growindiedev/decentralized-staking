pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  ExampleExternalContract public exampleExternalContract;
  mapping( address => uint256) public balances;
  bool public openForWithdraw;
  uint256 public constant threshold = 1 ether;
  uint256 public deadline = block.timestamp + 50 seconds;
  event Stake(address staker, uint256 balance);
  

  constructor(address exampleExternalContractAddress) public {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  function stake() public payable  {
    emit Stake(msg.sender, msg.value);
    balances[msg.sender] = balances[msg.sender] + msg.value;
  }

  function timeLeft() public view returns(uint256) {
    if(block.timestamp >= deadline){
      return 0;
    }
    return deadline;
  }

  function execute() public {
    //require(timeLeft() > 0 );
    if(timeLeft() > 0 && address(this).balance >= threshold){
      exampleExternalContract.complete{value: address(this).balance}();
      openForWithdraw = false;
    } else if (address(this).balance <= threshold){
      openForWithdraw = true;
    }
  }

  function withdraw(address payable gucci) public {
    require(openForWithdraw == true && address(this).balance <= threshold);
    address payable owner;
    if(balances[msg.sender] != 0){
      owner = payable(msg.sender);
    }
    bool whoop = gucci.send(balances[msg.sender]);//gucci.send(balances[gucci]);
    //openForWithdraw = false;
    //deadline == 0 ? (deadline =  block.timestamp + 50 seconds) : deadline = deadline;

  }


  

  


  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  //  ( make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )


  // After some `deadline` allow anyone to call an `execute()` function
  //  It should either call `exampleExternalContract.complete{value: address(this).balance}()` to send all the value


  // if the `threshold` was not met, allow everyone to call a `withdraw()` function


  // Add a `withdraw(address payable)` function lets users withdraw their balance


  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend


  // Add the `receive()` special function that receives eth and calls stake()


}
