// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Kipubank is ReentrancyGuard {
    // ==========================
    // VARIABLES DE ESTADO
    // ==========================
    /// @notice Bóveda personal de cada usuario, almacena cuánto ETH tiene depositado.
    mapping(address => uint256) public bovedaPersonal;
    /// @notice Límite global de depósitos permitidos en todo el contrato.
    uint256 limiteDepositos;
    /// @notice Acumulado total de depósitos en el contrato.
    uint256 totalDepositos;
    /// @notice Máximo permitido por retiro individual (50 ether).
    uint256 private constant LIMITE_RETIRO = 50 ether;
    /// @notice Contador del número de retiros realizados en el contrato.
    uint256 public cantidadRetiros;
    /// @notice Contador del número de depósitos realizados en el contrato.
    uint256 public cantidadDepositos;
    // ==========================
    // EVENTOS
    // ==========================
    event RetiroExitoso(address usuario, uint256 cantidad);
    event DepositoExitoso(address usuario, uint256 cantidad);
    // ==========================
    // ERRORES
    // ==========================
    error LimiteDinero(uint256 monto, address user, string detalle);
    error SaldoInsuficiente(uint256 monto, address user, string detalle);
    error LimiteGlobal(uint256 monto, string detalle);

    // ==========================
    // CONSTRUCTOR
    // ==========================

    /// @notice Inicializa el contrato con un límite global de depósitos.
    /// @param _limiteDepositos Monto máximo permitido en el contrato (en wei).
    constructor(uint256 _limiteDepositos) {
        limiteDepositos = _limiteDepositos;
    }

    // ==========================
    // FUNCIONES
    // ==========================
    /// @notice Permite a un usuario retirar fondos de su bóveda personal.
    /// @dev Aplica límite de retiro por transacción y valida que el usuario tenga saldo suficiente.
    /// @param _cantidadRetiro Monto a retirar.
    function retirar(uint256 _cantidadRetiro) external nonReentrant {
        if (_cantidadRetiro > LIMITE_RETIRO) {
            revert LimiteDinero(
                _cantidadRetiro,
                msg.sender,
                "no puedes retirar mas de 50"
            );
        } else if (bovedaPersonal[msg.sender] < _cantidadRetiro) {
            revert SaldoInsuficiente(
                _cantidadRetiro,
                msg.sender,
                "Slado insuficiente"
            );
        }
        bovedaPersonal[msg.sender] =
            bovedaPersonal[msg.sender] -
            _cantidadRetiro;
        cantidadRetiros++;
        payable(msg.sender).transfer(_cantidadRetiro);
        emit RetiroExitoso(msg.sender, _cantidadRetiro);
    }

    /// @notice Permite a un usuario depositar ETH en su bóveda personal.
    /// @dev Verifica que no se exceda el límite global de depósitos.
    function deposito() external payable nonReentrant {
        if (_pasoLimiteDepositos(msg.value)) {
            revert LimiteGlobal(msg.value, "Limite global alcanzado");
        }
        bovedaPersonal[msg.sender] = bovedaPersonal[msg.sender] + msg.value;
        totalDepositos += msg.value;
        cantidadDepositos++;
        emit DepositoExitoso(msg.sender, msg.value);
    }

    /// @notice Devuelve el saldo en la bóveda personal de un usuario.
    /// @param usuario Dirección del usuario.
    /// @return Saldo del usuario en wei.
    function verSaldo(address usuario) external view returns (uint256) {
        return bovedaPersonal[usuario];
    }

    /// @notice Verifica si un monto adicional cabe dentro del límite global.
    /// @dev Función de utilidad para controlar depósitos.
    /// @param monto Monto a evaluar.
    /// @return Verdadero si no se excede el límite global.
    function _pasoLimiteDepositos(uint256 monto) private view returns (bool) {
        return (totalDepositos + monto) >= limiteDepositos;
    }
}
