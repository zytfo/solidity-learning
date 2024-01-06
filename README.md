# solidity-learning

### Foundry (foundry-f23)

0. `forge init` - create a new project
1. `forge compile` - compile contract
2. `forge create SimpleStorage  --rpc-url http://127.0.0.1:7545 --interactive` - via Ganache
3. `anvil; forge create SimpleStorage --interactive` - via Anvil (anvil in another tab)
4. `forge script script/DeploySimpleStorage.s.sol` - run forge script on termoral anvil
5. `forge script script/DeploySimpleStorage.s.sol --rpc-url http://127.0.0.1:8545 --broadcast --private-key <private key from anvil>` - run forge script on existing anvil (check broadcast folder)
6. `cast --to-base 0x714c2 dec` - convert hex to dec
7. `source .env` - load env vars into shell, to use as `$PRIVATE_KEY`
8. `cast send 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "store(uint256)" 123 --rpc-url $RPC_URL --private-key $PRIVATE_KEY` - send method on deployed contract from terminal
9. `cast call 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "retrieve()"` - call method from terminal
10. `forge fmt` - format all solidity code

### foundry-fund-me-f23

1. `forge init` - init a new project
2. `forge test` - run test
3. `forge install smartcontractkit/chainlink-brownie-contracts --no-commit` - install chainlink libs
4. Add into `foundry.toml`: `remappings = ["@chainlink/contracts/=lib/chainlink-brownie-contracts/contracts/",]`
5. `forge remappings > remappings.txt` - add remappings for libs
6. `forge test -vv` - run tests with console.log
7. !!!`forge test -vvv --fork-url $SEPOLIA_RPC_URL` - run tests on forked sepolia
8. `forge coverage --fork-url $SEPOLIA_RPC_URL` - show coverage on forked sepolia
9. `chisel` - run solidity line-by-line executor
10. `forge snapshot` - get gas spend for every function
