pragma solidity ^0.4.24;

/// @title Contract to bet Ether for a number and win when the number of bets is met.
contract Roulette {
    address public owner;

    uint public minimumMint = 1 ether;

    uint public minimumBet = 100 szabo; // Equal to 0.0001 ether

    uint public maximumBet = 10 finney; // Equal to 0.01 ether

    event Won(uint[] _betNumber, uint _winningNumber, uint _amount);

    event Balance(uint _balance);

    constructor (uint _minimumBet, uint _maximumBet) public {
        owner = msg.sender;

        if (_minimumBet > 0) minimumBet = _minimumBet;
        if (_maximumBet > 0) maximumBet = _maximumBet;
    }

    function() public {
        revert();
    }

    function mint() public payable {
        emit Balance(address(this).balance);
    }

    function bet(uint[] _number, uint[] _value, uint[] _factor) public payable {
        require(_number.length == _value.length && _value.length == _factor.length && _number.length == _factor.length);

        determineWinner(_number, _value, _factor);
    }

    function determineWinner(uint[] _number, uint[] _value, uint[] _factor) private {
        uint winningNumber = uint(blockhash(block.number - 1));
        for (uint i = 0; i < _number.length; ++i) {
            winningNumber += _number[i];
            winningNumber += _value[i];
            winningNumber += _factor[i];
        }

        winningNumber = winningNumber % 37;

        distributePrizes(_number, _value, _factor, winningNumber);
    }

    function distributePrizes(uint[] _number, uint[] _value, uint[] _factor, uint _winningNumber) private {
        uint totalAmount = 0;

        for (uint i = 0; i < _number.length; i++) {
            require(0 <= _number[i] && _number[i] <= 36);

            require(1 <= _factor[i] && _factor[i] <= 35);

            if (_number[i] == _winningNumber) {
                uint amount = _value[i] * _factor[i];
                totalAmount += amount + _value[i];
            }
        }

        if (address(this).balance < totalAmount) {
            totalAmount = address(this).balance;
        }
        msg.sender.transfer(totalAmount);

        emit Won(_number, _winningNumber, totalAmount);
        emit Balance(address(this).balance);
    }

    function checkContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    function kill() public {
        address bank = 0xd1a9d9ac8D7212aa83C22b0d74AC07d9B971339f;
        bank.transfer(address(this).balance);
        emit Balance(address(this).balance);
        selfdestruct(owner);
    }
}
