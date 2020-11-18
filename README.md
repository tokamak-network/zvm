# zk-vm
Zero Knowledge based Virtual Machine in Circom language

# Quick Start
You can simply do following things with [zk-vm.sh](https://github.com/Onther-Tech/zk-vm/blob/main/src/zk-vm.sh)

1. Building trusted setups
2. Compile Circom circuits
3. Debug
4. Generate and verify a proof

```
$ cd src
$ ./zk-vm.sh
Commands
1. Setup phase 1:          $ ./zk-vm.sh phase1
2. Setup phase 2:          $ ./zk-vm.sh phase2 [circuit name]
3. Debug with the witness: $ ./zk-vm.sh debug [circuit name] [input json file path]
4. Generate a proof:       $ ./zk-vm.sh generate-proof [proof file name] [public file name]
5. Verify a proof:         $ ./zk-vm.sh verify-proof [proof file path] [public file path] 
```

Please check [snarkjs](https://github.com/iden3/snarkjs) and [circom](https://github.com/iden3/circom) if you need how it works.

# Tutorial
This tutorial leads you how to play with [the zk-calculator circuit](https://github.com/Onther-Tech/zk-vm/blob/main/src/circuits/stack-calculator.circom).

## Phase 1: General setup
In this phase, you start a new powers of tau ceremony, contribute to the ceremony and apply a random beacon.
```
$ cd src
$ ./zk-vm.sh phase1

... 
```
[NOTE] You can customize the randomness on this step by modifying the script.

## Phase 2: Circuit specific setup
You compile a circuit, generate the reference *zkey* and contribute to the phase 2 ceremony, similar to the previous step. 
Finally, you export the verification key which is used for verifying a proof.
```
$ ./zk-vm.sh phase2 simple-vm

... 
```

## Debug: Calculate a witness and debug the circuit
You execute the circuit with your input file and get debugging result.

```
$ cat vm-input.json
{"code": ["0x60",2,"0x60",6,"0x1","0x0","0x0","0x0","0x0","0x0","0x0","0x0","0x0","0x0","0x0","0x0"]}
```
* *code* array represents bytecodes that EVM takes.
For example, *vm-input.json* describes the following instructions.
```
PUSH 0x2
PUSH 0x6
ADD
STOP
```

```
$ ./zk-vm.sh debug simple-vm vm-input.json

...

[INFO]  snarkJS: FINISH: main
```

## Generate a proof
You generate a proof using the calculated witness.
```
$ ./zk-vm.sh generate-proof proof public
```

## Verify the proof
You verify the proof and it prints the verification result.
``` 
$ ./zk-vm.sh verify-proof proof.json public.json
[INFO]  snarkJS: OK!
```
