KipuBank

1) Descripción  
Un proyecto de banco en ethereum en el que depositás y retirás (con límite fijo por transacción)
Hay un "tope global" (bankCap) y guarda saldo por dirección

2) Despliegue  
- Crear .env`: SEPOLIA_RPC_URL=<rpc> y PRIVATE_KEY=0x<pk> 
- Compilar: npx hardhat compile 
- Deploy: node scripts/deploy.mjs

3) Cómo interactuar con el contrato  
- En Etherscan -- Contract  
- deposit() con value en ETH (por ejemplo 0.001)  
- withdraw(amount) en wei (por ejemplo: 0.0005 ETH = 500000000000000)  
- para hacer consultas: balanceOf(addr), remainingCapacity()

4) Direccion del contrato desplegado
Contrato: 0x1719dC0E3259bB25c5837f733a5D7ebbD017D220
Etherscan: https://sepolia.etherscan.io/address/0x1719dC0E3259bB25c5837f733a5D7ebbD017D220
