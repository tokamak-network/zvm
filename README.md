# zk-vm
Zero Knowledge based Ethereum Virtual Machine in Circom language

## Dependencies
You need node v14, [snarkjs](https://github.com/iden3/snarkjs) and [circom](https://github.com/iden3/circom).

You can easily install snarkjs and circom by entering the following commands after node v14 is successfully installed.
```
npm install -g circom@latest
npm install -g snarkjs@latest
```
## Status
zk-vm is currently under busy construction. The circuit supports the EVM opcodes, the stack size upto eight (unsigned integers), memory size upto eight (unsigned integers) and sixteen input signal array which represents the bytecode for EVM.

### Completion
The checked opcodes have been implemented.
- [x] 0x00	STOP; Halts execution
- [x] 0x01	ADD; Addition operation
- [x] 0x02	MUL; Multiplication operation
- [x] 0x03	SUB; Subtraction operation
- [x] 0x04	DIV; Integer division operation
- [ ] 0x05  SDIV; Signed integer division operation (truncated)
- [x] 0x06  MOD; Modulo remainder operation
- [ ] 0x07  SMOD; Signed modulo remainder operation
- [x] 0x08  ADDMOD; Modulo addition operation
- [x] 0x09  MULMOD; Modulo multiplication operation
- [x] 0x0a  EXP; Exponential operation
- [ ] 0x0b  SIGNEXTEND; Extend length of two's complement signed integer
- [x] 0x0c  GCD; Greatest common divisor operation - Only referenced in simple-vm
- [x] 0x0d  LCM; Least common multiple operation - Only referenced in simple-vm
- [x] 0x0e  COMBINATION; Combination operation (nCr) - Only referenced in simple-vm
- [x] 0x0f  FACTORIAL; Factorial operation (n!) - Only referenced in simple-vm

- [x] 0x10  LT; Less-than comparison
- [x] 0x11  GT;	Greater-than comparison
- [ ] 0x12	SLT; Signed less-than comparison
- [ ] 0x13	SGT; Signed greater-than comparison
- [x] 0x14	EQ;	Equality comparison
- [x] 0x15	ISZERO;	Simple not operator
- [x] 0x16	AND; Bitwise AND operation
- [x] 0x17	OR; Bitwise OR operation
- [x] 0x18	XOR; Bitwise XOR operation
- [x] 0x19	NOT; Bitwise NOT operation
- [x] 0x1a  BYTE; Retrieve single byte from word
- [x] 0x1b	SHL; Shift Left
- [x] 0x1c	SHR; Logical Shift Right
- [x] 0x1d	SAR; Arithmetic Shift Right

- [ ] 0x20	KECCAK256; Compute Keccak-256 hash

- [ ] 0x30	ADDRESS; Get address of currently executing account
- [ ] 0x31	BALANCE; Get balance of the given account
- [ ] 0x32	ORIGIN;	Get execution origination address
- [ ] 0x33	CALLER; Get caller address 
- [ ] 0x34	CALLVALUE; Get deposited value by the instruction/transaction responsible for this execution 
- [ ] 0x35	CALLDATALOAD; Get input data of current environment
- [ ] 0x36	CALLDATASIZE; Get size of input data in current environment
- [ ] 0x37	CALLDATACOPY; Copy input data in current environment to memory
- [ ] 0x38	CODESIZE; Get size of code running in current environment 
- [ ] 0x39	CODECOPY; Copy code running in current environment to memory
- [ ] 0x3a	GASPRICE; Get price of gas in current environment 
- [ ] 0x3b	EXTCODESIZE; Get size of an account's code
- [ ] 0x3c	EXTCODECOPY; Copy an account's code to memory
- [ ] 0x3d	RETURNDATASIZE; Pushes the size of the return data buffer onto the stack
- [ ] 0x3e	RETURNDATACOPY; Copies data from the return data buffer to memory
- [ ] 0x3f	EXTCODEHASH; Returns the keccak256 hash of a contract's code

- [ ] 0x40	BLOCKHASH; Get the hash of one of the 256 most recent complete blocks 0
- [ ] 0x41	COINBASE; Get the block's beneficiary address 
- [ ] 0x42	TIMESTAMP; Get the block's timestamp 
- [ ] 0x43	NUMBER; Get the block's number 
- [ ] 0x44	DIFFICULTY; Get the block's difficulty 
- [ ] 0x45	GASLIMIT; Get the block's gas limit 
- [ ] 0x46	CHAINID; Returns the current chain’s EIP-155 unique identifier

- [x] 0x50	POP; Remove an item from stack 
- [x] 0x51	MLOAD; Load an item from memory
- [x] 0x52	MSTORE; Save an item to memory
- [ ] 0x53	MSTORE8; Save byte to memory 
- [ ] 0x54	SLOAD; Load word from storage
- [ ] 0x55	SSTORE; Save word to storage
- [x] 0x56	JUMP; Alter the program counter
- [x] 0x57	JUMPI; Conditionally alter the program counter
- [x] 0x58	GETPC; Get the value of the program counter prior to the increment 
- [x] 0x59	MSIZE; Get the size of active memory in bytes 
- [ ] 0x5a	GAS; Get the amount of available gas, including the corresponding reduction the amount of available gas
- [x] 0x5b	JUMPDEST; Mark a valid destination for jumps

- [x] 0x60 PUSH; Place one uint item on stack ([NOTE] Not n-byte item)

- [x] 0x80	DUP1; Duplicate 1st stack item 
- [x] 0x81	DUP2; Duplicate 2nd stack item 
- [x] 0x82	DUP3; Duplicate 3rd stack item 
- [x] 0x83	DUP4; Duplicate 4th stack item 
- [x] 0x84	DUP5; Duplicate 5th stack item 
- [x] 0x85	DUP6; Duplicate 6th stack item 
- [x] 0x86	DUP7; Duplicate 7th stack item 
- [x] 0x87	DUP8; Duplicate 8th stack item 
- [x] 0x88	DUP9; Duplicate 9th stack item 
- [x] 0x89	DUP10; Duplicate 10th stack item 
- [x] 0x8a	DUP11; Duplicate 11th stack item 
- [x] 0x8b	DUP12; Duplicate 12th stack item 
- [x] 0x8c	DUP13; Duplicate 13th stack item 
- [x] 0x8d	DUP14; Duplicate 14th stack item 
- [x] 0x8e	DUP15; Duplicate 15th stack item 
- [x] 0x8f	DUP16; Duplicate 16th stack item 

- [x] 0x90  SWAP1; Exchange 1st and 2nd stack items
- [x] 0x91  SWAP2; Exchange 1st and 3rd stack items
- [x] 0x92  SWAP3; Exchange 1st and 4th stack items
- [x] 0x93  SWAP4; Exchange 1st and 5th stack items
- [x] 0x94  SWAP5; Exchange 1st and 6th stack items
- [x] 0x95  SWAP6; Exchange 1st and 7th stack items
- [x] 0x96  SWAP7; Exchange 1st and 8th stack items
- [x] 0x97  SWAP8; Exchange 1st and 9th stack items
- [x] 0x98  SWAP9; Exchange 1st and 10th stack items
- [x] 0x99  SWAP10; Exchange 1st and 11th stack items
- [x] 0x9a  SWAP11; Exchange 1st and 12th stack items
- [x] 0x9b  SWAP12; Exchange 1st and 13th stack items
- [x] 0x9c  SWAP13; Exchange 1st and 14th stack items
- [x] 0x9d  SWAP14; Exchange 1st and 15th stack items
- [x] 0x9e  SWAP15; Exchange 1st and 16th stack items
- [x] 0x9f  SWAP16; Exchange 1st and 17th stack items

- [ ] 0xa0	LOG0; Append log record with no topics
- [ ] 0xa1	LOG1; Append log record with one topic
- [ ] 0xa2	LOG2; Append log record with two topics
- [ ] 0xa3	LOG3; Append log record with three topics
- [ ] 0xa4	LOG4; Append log record with four topics

- [ ] 0xb0	JUMPTO; Tentative libevmasm has different numbers
- [ ] 0xb1	JUMPIF; Tentative 
- [ ] 0xb2	JUMPSUB; Tentative 
- [ ] 0xb4	JUMPSUBV; Tentative 
- [ ] 0xb5	BEGINSUB; Tentative 
- [ ] 0xb6	BEGINDATA; Tentative 
- [ ] 0xb8	RETURNSUB; Tentative 
- [ ] 0xb9	PUTLOCAL; Tentative 
- [ ] 0xba	GETLOCAL; Tentative 

- [ ] 0xf0	CREATE;	Create a new account with associated code
- [ ] 0xf1	CALL; Message-call into an account
- [ ] 0xf2	CALLCODE; Message-call into this account with alternative account's code
- [ ] 0xf3	RETURN;	Halt execution returning output data
- [ ] 0xf4	DELEGATECALL; Message-call into this account with an alternative account's code, but persisting into this account with an alternative account's code
- [ ] 0xf5	CREATE2; Create a new account and set creation address to sha3(sender + sha3(init code)) % 2**160
- [ ] 0xfa	STATICCALL;	Similar to CALL, but does not modify state
- [ ] 0xfc	TXEXECGAS; Not in yellow paper FIXME
- [ ] 0xfd	REVERT; Stop execution and revert state changes, without consuming all provided gas and providing a reason
- [ ] 0xfe	INVALID; Designated invalid instruction
- [ ] 0xff	SELFDESTRUCT; Halt execution and register account for later deletion


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

Please check [snarkjs](https://github.com/iden3/snarkjs/blob/master/README.md) and [circom](https://github.com/iden3/circom/blob/master/README.md) if you need how it works.

# Tutorial
This tutorial leads you how to play with [zk-vm circuit](https://github.com/Onther-Tech/zk-vm/blob/main/src/circuits/vm.circom).

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
{"code": ["0x60","0x2","0x60","0x6","0x1","0x0","0x0","0x0","0x0","0x0","0x0","0x0","0x0","0x0","0x0","0x0"]}
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