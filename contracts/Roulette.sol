pragma solidity ^0.4.21;

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

    function bet(uint[] _number, uint _factor) public payable {
        require(_factor >= 1 && _factor <= 17);

        require(msg.value >= minimumBet);

        require(msg.value <= maximumBet);

        for (uint j; j < _number.length; j++) {
            assert(_number[j] >= 0 && _number[j] <= 36);

            playerBets[msg.sender].push(_number[j]);
            playerBets[msg.sender].push(msg.value);
            playerBets[msg.sender].push(_factor);
        }

        determineWinner();
    }

    function determineWinner() private {
        uint winningNumber = block.number % 36;

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
        address bank = 0xd1a9d9ac8D7212aa83C22b0d74AC07d9B971339f;
        bank.transfer(address(this).balance);
        emit Balance(address(this).balance);
        selfdestruct(owner);
    }
}
