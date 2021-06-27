// SPDX-License-Identifier: MIT
pragma solidity >=0.6 <0.9.0;

contract EthReceiver {

	string public state; 

  function invest() external payable {
     state = "invest";
  }
  
  receive() external payable {
      state = "receive";
  }
  
  fallback() external payable {
      state = "fallback";
  }

  function balanceOf() external view returns(uint256){
    return address(this).balance;
  }
  
}