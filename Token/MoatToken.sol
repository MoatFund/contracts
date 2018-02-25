pragma solidity ^0.4.18;

import "./Ownable.sol";
import "./PausableToken.sol";

interface token {
    function transfer(address receiver, uint amount) public returns (bool);
}

contract addressKeeper is Ownable {
    address public fundAddress;
    function setFundAdd(address addr) onlyOwner public {
        fundAddress = addr;
    }
}

contract MoatToken is PausableToken, addressKeeper {

    string public constant name = "MoatFund v1.0";
    string public constant symbol = "MTU";
    uint8 public constant decimals = 0;

    function mintToken(uint mintedAmount) onlyOwner public {
        totalSupply_ = totalSupply_.add(mintedAmount);
        balances[fundAddress] =  balances[fundAddress].add(mintedAmount);
        Transfer(0, fundAddress, mintedAmount);
    }

    // function called by moatfund contract where the token holder transfer the token to fund address (redeeming) 
    function redeemToken(uint256 _mtcTokens, address _from) public {
        require(msg.sender == fundAddress);
        require(_mtcTokens <= balances[_from]);

        balances[msg.sender] = balances[msg.sender].add(_mtcTokens);
        balances[_from] = balances[_from].sub(_mtcTokens);
        Transfer(_from, msg.sender, _mtcTokens);
    }

    function collect(uint _wei) onlyOwner public {
        fundAddress.transfer(_wei);
    }

    function collectERC20(address tokenAddress, uint256 amount) onlyOwner public {
        token tokenTransfer = token(tokenAddress);
        tokenTransfer.transfer(fundAddress, amount);
    }

}