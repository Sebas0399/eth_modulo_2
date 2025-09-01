# 🏦 KipuBank

## ✨ Características

- Los usuarios pueden **depositar ETH** en una bóveda personal.
- Los usuarios pueden **retirar ETH**, pero con un límite máximo de `50 ETH` por transacción.
- Existe un **límite global de depósitos (`limiteDepositos`)** definido al desplegar el contrato.
- Se registran y cuentan el número de **depósitos** y **retiros**.
- Se emiten **eventos** en cada operación exitosa.
- Se incluyen **errores personalizados** para revertir condiciones inválidas.
- Seguridad contra ataques de **reentrancy** gracias a `ReentrancyGuard` de OpenZeppelin.
- Incluye funciones de lectura (`view`) y privadas (`private`) para cumplir buenas prácticas.

---

## 📜 Requisitos

- [Remix IDE](https://remix.ethereum.org/) o un entorno local de Solidity.
- **Metamask** instalado y configurado.
- ETH de prueba en una testnet (ejemplo: **Sepolia**).

---

## 🚀 Despliegue

### 1. Usando Remix VM (local)
1. Abre [Remix](https://remix.ethereum.org/).
2. Crea un nuevo archivo en la carpeta `contracts/` llamado `KipuBank.sol`.
3. Copia el contrato en el archivo.
4. Compila usando el compilador **0.8.30**.
5. En **Deploy & Run Transactions** selecciona `Remix VM (London)`.
6. En el campo del constructor ingresa un límite global de depósitos `1 ether`, escribe `1000000000000000000`.
7. Haz clic en **Deploy**.
8. Ya podrás interactuar con el contrato desde la interfaz de Remix.

### 2. Usando Metamask y una testnet (ejemplo Sepolia)
1. Abre Metamask y activa las **redes de prueba**.
2. Selecciona la red **Sepolia Test Network**.
3. Obtén ETH de prueba desde un faucet: [Sepolia Faucet](https://sepoliafaucet.com/).
4. En Remix, selecciona **Injected Provider - MetaMask** como entorno.
5. Conecta Metamask a Remix.
6. Ingresa el límite global de depósitos en el constructor `1 ether`, escribe `1000000000000000000`.
7. Haz clic en **Deploy** y confirma la transacción en Metamask.
8. Una vez desplegado, verás el contrato en Remix con tu dirección en Sepolia.

---

## 🔑 Interacción con el contrato

### 1. Depositar
- Función: `deposito()`
- Tipo: `payable`
- Instrucciones:
  1. Arriba del botón de transacción en Remix, en el campo **Value**, escribe el monto a enviar.
  2. Selecciona la unidad (`ether`).
  3. Haz clic en **deposito**.
  4. Verás un evento `DepositoExitoso`.

### 2. Retirar
- Función: `retirar(uint256 _cantidadRetiro)`
- Parámetro: cantidad a retirar (en wei).
- Ejemplo: para retirar `1 ether`, escribe `1000000000000000000`.
- Restricciones:
  - Máximo `50 ether` por transacción.
  - Debes tener suficiente saldo en tu bóveda.
- Resultado:
  - Se actualiza tu saldo interno.
  - Se transfiere ETH a tu cuenta de Metamask.
  - Se emite `RetiroExitoso`.

### 3. Consultar saldo
- Función: `verSaldo(address usuario)`
- Parámetro: dirección del usuario.
- Devuelve: saldo en wei del usuario en su bóveda.

---
