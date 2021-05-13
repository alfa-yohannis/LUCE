pragma solidity ^0.4.25;

contract Testing{
 
   struct Test{
        address address1;
        bool setinput;
    }
   mapping (address => Test) test;

    function giveTest( 
        address _address1, 
        bool _setinput)public {
            test[_address1].setinput = _setinput; 
    }
}