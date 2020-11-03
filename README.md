# zk-vm
Zero Knowledge based Virtual Machine in Circom language

# Quick Start
You can simply do following things with [zk-vm.sh](https://github.com/Onther-Tech/zk-vm/blob/main/src/zk-vm.sh)

```
$ cd src
$ ./zk-vm.sh [Optional Keywords]
```

1. Building trusted setups
2. Compile Circom circuits
3. Debug
4. Generate and verify a proof

```
Commands
1. Setup phase 1:          $ ./zk-vm.sh phase1
2. Setup phase 2:          $ ./zk-vm.sh phase2 [circuit name]
3. Debug with the witness: $ ./zk-vm.sh debug [circuit name] [input json file path]
4. Generate a proof:       $ ./zk-vm.sh generate-proof [proof file name] [public file name]
5. Verify a proof:         $ ./zk-vm.sh verify-proof [public file path] [proof file path]
```

Please check [snarkjs](https://github.com/iden3/snarkjs) and [circom](https://github.com/iden3/circom) if you need how it works.