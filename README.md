KipuBank

1) Descripción  
Entrega para el curso de eth-kipu, de un proyecto de banco en ethereum en el que depositás y retirás (con un límite fijo por transacción)
Hay un "tope global" (bankCap) y se guarda saldo por dirección

2) Instrucciones de despliegue  
- Crear .env`: SEPOLIA_RPC_URL=<rpc> y PRIVATE_KEY=0x<pk> 
- Compilar: npx hardhat compile 
- Deploy: node scripts/deploy.mjs

3) Cómo interactuar con el contrato  
- En Etherscan -- Contract  
- deposit() con value en ETH (por ejemplo 0.001)  
- withdraw(amount) en wei (por ejemplo: 0.0005 ETH = 500000000000000)  
- para hacer consultas: balanceOf(addr), remainingCapacity()

--------------------
Dirección del contrato y código verificado en etherscan.
- Contrato: 0x1719dC0E3259bB25c5837f733a5D7ebbD017D220
- Etherscan: https://sepolia.etherscan.io/address/0x1719dC0E3259bB25c5837f733a5D7ebbD017D220
