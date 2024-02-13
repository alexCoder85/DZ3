// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @title INativeBank
 * @dev Interface for a native currency bank contract, providing basic banking functions.
 */
interface INativeBank {
    /**
     * Generated when the withdrawal amount exceeds the account balance.
     * @param account The address of the account that attempted to withdraw funds.
     * @param amount The amount that was attempted to be withdrawn.
     * @param balance The current balance of the account.
     */
    error WithdrawalAmountExceedsBalance(address account, uint256 amount, uint256 balance);
    /**
     * @dev Generated when, Withdrawal amount is 0.
     */
    error WithdrawalZero();
    /**
     * @dev Generated when, sending amount is 0.
     * @param account , Account  address that sends .
     */
    error SendingZeroAmount(address account);

    /**
     * @dev Generated when, checkning owner of contract.
     */
    error NotContractOwnerCall();


    /**
     * @dev Generated when calling fallback().
     * @param func, func string that saves in log.
     * @param gas,  left gas counter - gasleft().
     */
    event Log(string func, uint gas);


    /**
     * Generated when a deposit is made to an account.
     * @param account The address of the account to which the deposit was made.
     * @param amount The amount that was deposited.
     */
    event Deposit(address indexed account, uint256 amount);
    /**
     * Generated when funds are withdrawn from an account.
     * @param account The address of the account from which the withdrawal occurred.
     * @param amount The amount that was withdrawn.
     */
    event Withdrawal(address indexed account, uint256 amount);

    /**
     * Returns the account balance of any address in the hash table.
     * @param account The address of the account.
     * @return The account balance.
     */
    function balanceOf(address account) external view returns(uint256);

    /**
     * Withdraws funds from the account.
     * @param amount The amount to be withdrawn.
     */
    function withdraw(uint256 amount) external;
}
    /**
    @dev Generated when using address(0).
    */
    error ZeroAddress ();


contract Bank is INativeBank {

    address public immutable owner;
    mapping(address => uint256) public balanceOf;
    address private constant ADDR_0 =  address(0);


    constructor( address contract_owner) payable {
        owner = contract_owner;
    }


    function contractBalance() external payable returns(uint256){
        if (msg.sender != owner){
            revert NotContractOwnerCall ();
        }
        return balanceOf[owner];
    }

    function withdraw(uint256  _amount) external{
        uint256  _currentBalance= balanceOf[msg.sender];

        if (_amount==0){
            revert WithdrawalZero();
        }

        if(_currentBalance < _amount){
            revert WithdrawalAmountExceedsBalance(msg.sender, _amount, _currentBalance);
        }
        unchecked {
            balanceOf[msg.sender] -= _amount;
        }
        emit Withdrawal(msg.sender, _amount);
    }

    function deposit () public   payable{
        if (msg.value <= 0 ){
            revert SendingZeroAmount (msg.sender);
        }
        unchecked {
            balanceOf[msg.sender] += msg.value;
        }
        emit Deposit(msg.sender, msg.value);
    }

    function transfer ( address _to, uint256    _amount ) external payable{
        uint256 _currentBalance= balanceOf[msg.sender];

        if (_to==ADDR_0){
            revert ZeroAddress();
        }
        if( _amount==0){
            revert SendingZeroAmount (msg.sender);
        }
        else if(_currentBalance < _amount){
            revert WithdrawalAmountExceedsBalance(msg.sender, _amount, _currentBalance);
        }
        unchecked {
            balanceOf[msg.sender] -= _amount;
            balanceOf[_to] += _amount;
        }
    }

    fallback() external payable {
        emit Log("fallback", gasleft());
    }

    receive() external payable {
        deposit();
    }
}