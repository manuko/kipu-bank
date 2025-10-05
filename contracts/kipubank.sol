
/* SPDX-License-Identifier: MIT  */
pragma solidity ^0.8.24;

/* KipuBank */
contract KipuBank {
    /* error moto cero */
    
    error ZeroAmount();
    /* se pasa del cap */
    error CapExceeded(uint256 requested, uint256 remaining);
    /* excede el limite por retiro */
    error WithdrawLimitExceeded(uint256 amount, uint256 limit);
    /* no hay suficiente balance */
    error InsufficientBalance(uint256 have, uint256 need);
    /* en caso de un fallo en la transferencia */
    error EtherTransferFailed();
    /* error reentry */
    error Reentry();
    /* no permitir envios directos */
    error DirectEtherNotAllowed();

    /* constantes  inmutables */
   
    string public constant NAME = "KipuBank";
    /* tope global en wei */
    uint256 public immutable bankCap;
    /* limite por retiro  en wei */
    uint256 public immutable withdrawLimit;

    
    /* total depositado */
    uint256 public totalBalance;
    /* depositos */
    uint256 public totalDeposits;
    /* retiros */
    uint256 public totalWithdrawals;
    /* saldo por cada usuario */
    mapping(address => uint256) private _balances;
    /* guarda anti reentrada */
    bool private _entered;

    
    /* el deposito esta ok */
    event Deposited(address indexed user, uint256 amount);
    /* el retiro está ok */
    event Withdrawn(address indexed user, uint256 amount);

    /*  cap y limite */
    constructor(uint256 _bankCap, uint256 _withdrawLimit) {
        if (_bankCap == 0 || _withdrawLimit == 0) revert ZeroAmount();
        bankCap = _bankCap;
        withdrawLimit = _withdrawLimit;
    }

    /* evitar "reentradas" */
    modifier nonReentrant() {
        if (_entered) revert Reentry();
        _entered = true;
        _;
        _entered = false;
    }

    /* depositar ETH en la cuenta */
    function deposit() external payable {
        uint256 amount = msg.value;
        if (amount == 0) revert ZeroAmount();

        uint256 remaining = bankCap - totalBalance; /* chequeo  detope */
        if (amount > remaining) revert CapExceeded(amount, remaining);

        _bump(msg.sender, amount); 
        totalDeposits++;

        emit Deposited(msg.sender, amount);
    }

    /* retira ETH (hasa el limite transaccion) */
    function withdraw(uint256 amount) external nonReentrant {
        if (amount == 0) revert ZeroAmount();
        if (amount > withdrawLimit) revert WithdrawLimitExceeded(amount, withdrawLimit);

        uint256 bal = _balances[msg.sender];
        if (bal < amount) revert InsufficientBalance(bal, amount);

        _balances[msg.sender] = bal - amount;
        totalBalance -= amount;
        totalWithdrawals++;

        _send(payable(msg.sender), amount);

        emit Withdrawn(msg.sender, amount);
    }

    /* saldo de la direccion */
    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    /* lo que queda restante para depositar */
    function remainingCapacity() external view returns (uint256) {
        return bankCap - totalBalance;
    }

   

    /* sumar al balance interno y total */
    function _bump(address account, uint256 amount) private {
        _balances[account] += amount;
        totalBalance += amount;
    }

    /* transferencia via call */
    function _send(address payable to, uint256 amount) private {
        (bool ok, ) = to.call{value: amount}("");
        if (!ok) revert EtherTransferFailed();
    }

    /* bloquear envios directos  */
    receive() external payable { revert DirectEtherNotAllowed(); }

    /* bloquear llamadas "raras" */
    fallback() external payable { revert DirectEtherNotAllowed(); }
}
