# Guide
You can test the circuit by passing an input file in json format (.json).

## What does the input file consist of?
The input json file contain an array named `code`. Each item of the array represents a single opcode of EVM or an operand; it can be either decimal or hexadecimal number.

```
component main = VM(16);
```

You can find this line at the `src/circuits/vm.circom`. `VM(16)` shows that the input array size is sixteen as a fixed value, so `code` array should be padded by `0x0` to have sixteen elements in it. You need to start over from phase 2 setup to compile the modified circuit.

## Input scenarios
There are a few input scenarios with different operations for your better understanding.

```
// LOG FLAG; False as default
var LOG_FLAG = 0;
```
Please switch `LOG_FLAG` to 1 for logging in `src/circuits/vm.circom` if you need.


The log output looks like this:
```
N-1th element of the stack
N-2th element of the stack

...

0th element of the stack
10000000000
7th element of the memory

...

0th element of the memory
```
[NOTE] `10000000000` represents just a separator of log output since circom does not support string type.

### Arithmetic operations
```
000 PUSH 0x2
002 PUSH 0x3
004 ADD
005 STOP
```
```
$ cat vm-input.json
{"code": ["0x60","0x2","0x60","0x3","0x1","0x0","0x0","0x0","0x0","0x0","0x0","0x0","0x0","0x0","0x0","0x0"]}
```
These instructions are converted into `code` array like this.

```
$ cd src
$ ./zk-vm.sh debug vm vm-input.json

...

[INFO]  snarkJS: START: main
[INFO]  snarkJS: GET main.code[0] --> 96
[INFO]  snarkJS: GET main.code[1] --> 2
2
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[2] --> 96
[INFO]  snarkJS: GET main.code[3] --> 3
3
2
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[4] --> 1
5
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[5] --> 0
5
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: FINISH: main
```
It prints the stack and memory. There are 2, 3 on the stack after the second loop and only 5 (= 2 + 3) exists on the stack at the end of loops. Try the other arithmetic operations if you want.

### Comparison & Bitwise logic operations
```
000 PUSH 0x10
002 PUSH 0x3
004 PUSH 0x2
006 SHL
007 EQ
008 STOP
```
```
$ cat vm-input.json
{"code": ["0x60","0x10","0x60","0x3","0x60","0x2","0x1b","0x14","0x0","0x0","0x0","0x0","0x0","0x0","0x0","0x0"]}
```
This `code` array makes the circuit work like the instructions. 

```
$ ./zk-vm.sh debug vm vm-input.json

[INFO]  snarkJS: START: main
[INFO]  snarkJS: GET main.code[0] --> 96
[INFO]  snarkJS: GET main.code[1] --> 16
16
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[2] --> 96
[INFO]  snarkJS: GET main.code[3] --> 3
3
16
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[4] --> 96
[INFO]  snarkJS: GET main.code[5] --> 2
2
3
16
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[6] --> 27
16
16
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[7] --> 20
1
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[8] --> 0
1
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: FINISH: main
```

The circuit can be used for comparion and bitwise logic operations as you have seen in the case.

### Stack & Memory operations
```
000 PUSH 0x2
002 PUSH 0x3
004 PUSH 0x7
006 MSTORE
007 POP
008 PUSH 0x7
010 MLOAD
011 STOP
```
```
$ cat vm-input.json
{"code": ["0x60","0x2","0x60","0x3","0x60","0x7","0x52","0x50","0x60","0x7","0x51","0x0","0x0","0x0","0x0","0x0"]}
```
```
$ ./zk-vm.sh debug vm vm-input.json

... 


[INFO]  snarkJS: START: main
[INFO]  snarkJS: GET main.code[0] --> 96
[INFO]  snarkJS: GET main.code[1] --> 2
2
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[2] --> 96
[INFO]  snarkJS: GET main.code[3] --> 3
3
2
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[4] --> 96
[INFO]  snarkJS: GET main.code[5] --> 7
7
3
2
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[6] --> 82
2
10000000000
3
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[7] --> 80
10000000000
3
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[8] --> 96
[INFO]  snarkJS: GET main.code[9] --> 7
7
10000000000
3
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[10] --> 81
3
10000000000
3
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[11] --> 0
3
10000000000
3
0
0
0
0
0
0
0
[INFO]  snarkJS: FINISH: main
```

The circuit also works for setting and getting values on the stack and memory.


### Flow operations
```
000 PUSH 0x0
002 ISZERO
003 PUSH 0x7
005 JUMPI
006 STOP
007 JUMPDEST
008 PUSH 0x2
010 PUSH 0x3
012 ADD
013 STOP
```
```
$ cat vm-input.json
{"code": ["0x60","0x0","0x15","0x60","0x7","0x57","0x0","0x5b","0x60","0x2","0x60","0x3","0x1","0x0","0x0","0x0"]}
```
```
$ ./zk-vm.sh debug vm vm-input.json

... 

[INFO]  snarkJS: START: main
[INFO]  snarkJS: GET main.code[0] --> 96
[INFO]  snarkJS: GET main.code[1] --> 0
0
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[2] --> 21
1
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[3] --> 96
[INFO]  snarkJS: GET main.code[4] --> 7
7
1
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[5] --> 87
[INFO]  snarkJS: GET main.code[7] --> 91
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[8] --> 96
[INFO]  snarkJS: GET main.code[9] --> 2
2
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[10] --> 96
[INFO]  snarkJS: GET main.code[11] --> 3
3
2
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[12] --> 1
5
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[13] --> 0
5
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: FINISH: main
```

### Duplication operations
```
000 PUSH 0x1
002 PUSH 0x2
004 PUSH 0x3
006 DUP2
007 DUP4
008 STOP
```
```
$ cat vm-input.json
{"code": ["0x60","0x1","0x60","0x2","0x60","0x3","0x81","0x83","0x0","0x0","0x0","0x0","0x0","0x0","0x0","0x0"]}
```
```
$ ./zk-vm.sh debug vm vm-input.json

... 

[INFO]  snarkJS: START: main
[INFO]  snarkJS: GET main.code[0] --> 96
[INFO]  snarkJS: GET main.code[1] --> 1
1
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[2] --> 96
[INFO]  snarkJS: GET main.code[3] --> 2
2
1
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[4] --> 96
[INFO]  snarkJS: GET main.code[5] --> 3
3
2
1
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[6] --> 129
2
3
2
1
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[7] --> 131
1
2
3
2
1
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[8] --> 0
1
2
3
2
1
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: FINISH: main
```


### Exchange operations
```
000 PUSH 0x1
002 PUSH 0x2
004 PUSH 0x3
006 SWAP2
007 STOP
```
```
$ cat vm-input.json
{"code": ["0x60","0x1","0x60","0x2","0x60","0x3","0x91","0x0","0x0","0x0","0x0","0x0","0x0","0x0","0x0","0x0"]}
```
```
$ ./zk-vm.sh debug vm vm-input.json

...

[INFO]  snarkJS: START: main
[INFO]  snarkJS: GET main.code[0] --> 96
[INFO]  snarkJS: GET main.code[1] --> 1
1
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[2] --> 96
[INFO]  snarkJS: GET main.code[3] --> 2
2
1
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[4] --> 96
[INFO]  snarkJS: GET main.code[5] --> 3
3
2
1
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[6] --> 145
1
2
3
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: GET main.code[7] --> 0
1
2
3
10000000000
0
0
0
0
0
0
0
0
[INFO]  snarkJS: FINISH: main
```
