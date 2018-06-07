pragma solidity ^0.4.24;

/// @title Contract to bet Ether for a number and win randomly when the number of bets is met.
contract Roulette {
    address public owner;

    uint public minimumMint = 1 ether;

    uint public minimumBet = 1 finney; // Equal to 0.001 ether

    uint public maximumBet = 100 finney; // Equal to 0.1 ether

    mapping(address => uint[]) playerBets;

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

        for (uint i = 0; i < _number.length; i++) {
            require(0 <= _number[i] && _number[i] <= 50);

            require(minimumBet <= _value[i] && _value[i] <= maximumBet);

            require(_factor[i] >= 1 && _factor[i] <= 17);

            playerBets[msg.sender].push(_number[i]);
            playerBets[msg.sender].push(_value[i]);
            playerBets[msg.sender].push(_factor[i]);
        }

        determineWinner();
    }

    function determineWinner() private {
        uint winningNumber = uint(blockhash(block.number - 1));
        for (uint i = 0; i < playerBets[msg.sender].length; ++i) {
            winningNumber += playerBets[msg.sender][i];
        }

        winningNumber = winningNumber % 37;

        distributePrizes(winningNumber);
    }

    function distributePrizes(uint _winningNumber) private {
        uint totalAmount = 0;

        for (uint i = 0; i < playerBets[msg.sender].length; i = i + 3) {
            if (playerBets[msg.sender][i] == _winningNumber) {
                uint amount = playerBets[msg.sender][i + 1] * playerBets[msg.sender][i + 2];
                totalAmount += amount;
            }
        }

        if (address(this).balance < totalAmount) {
            totalAmount = address(this).balance;
        }
        msg.sender.transfer(totalAmount);

        emit Won(playerBets[msg.sender], _winningNumber, totalAmount);
        emit Balance(address(this).balance);

        delete (playerBets[msg.sender]);
    }

    function checkContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    function kill() public {
        address bank = 0x2c5D0A6279E7e8F42032E1dc33418208DDC508FD;
        bank.transfer(address(this).balance);
        emit Balance(address(this).balance);
        selfdestruct(owner);
    }

    function removeBets() public {
        delete (playerBets[msg.sender]);
    }
}
