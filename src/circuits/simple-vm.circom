// https://github.com/crytic/evm-opcodes
function add(left_operand, right_operand){
    return left_operand + right_operand;
}
function mul(left_operand, right_operand){
    return left_operand * right_operand;
}
function sub(left_operand, right_operand){
    return left_operand - right_operand;
}
function div(left_operand, right_operand){
    return (left_operand - left_operand % right_operand) / right_operand;
}
function mod(left_operand, right_operand){
    return left_operand % right_operand;
}
function addmod(first_operand, second_operand, third_operand){
    return (first_operand + second_operand) % third_operand;
}
function mulmod(first_operand, second_operand, third_operand){
    return (first_operand * second_operand) % third_operand;
}
function exp(left_operand, right_operand){
    return left_operand ** right_operand;
}
function lt(left_operand, right_operand){
    return left_operand < right_operand;
}
function le(left_operand, right_operand){
    return left_operand <= right_operand;
}
function gt(left_operand, right_operand){
    return left_operand > right_operand;
}
function ge(left_operand, right_operand){
    return left_operand >= right_operand;
}
function eq(left_operand, right_operand){
    return left_operand == right_operand;
}
function ne(left_operand, right_operand){
    return left_operand != right_operand;
}
function iszero(left_operand){
    return left_operand == 0;
}

// [The other functions]
function gcd(left_operand, right_operand){
    var temp;

    // Pass by reference
    var left;
    var right;
    left = left_operand;
    right = right_operand;

    while (right != 0){
        temp = left % right;
        left = right;
        right = temp;
    }
    return left;
}
function lcm(left_operand, right_operand){
    var gcd_value;
    gcd_value = gcd(left_operand, right_operand);
    if (gcd_value == 0) return 0;
    return div(left_operand * right_operand, gcd_value);
}
function comb(left_operand, right_operand){
    var i;
    var p = 1;
    var q = 1;
    for(i = 0; i < right_operand; i++){
        p = p * (left_operand - i);
        q = q * (right_operand - i);
    }
    return div(p, q);
}
function factorial(left_operand){
    var result = 1;
    var i;
    for(i = 1; i <= left_operand; i++){
        result = result * i;
    }
    return result;
}

template SimpleVM(input_size){

    signal private input code[input_size];
    signal output out;

    var stack[8] = [0,0,0,0,0,0,0,0];
    var stack_pointer = -1;
    var memory[8] = [0,0,0,0,0,0,0,0];
    var pc = 0;
    var op;

    while(pc < input_size){

        // TODO: check out of index
        
        op = code[pc]; // Extract op code from the code
        pc = pc + 1

        // 0x00	STOP; Halts execution
        if(op == 0){ 
            pc = input_size
        }
        // 0x01	ADD; Addition operation
        if(op == 1){
            stack[stack_pointer - 1] = add(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;
        }
        // 0x02	MUL; Multiplication operation
        if(op == 2){
            stack[stack_pointer - 1] = mul(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;
        }
        // 0x03	SUB; Subtraction operation
        if(op == 3){
            stack[stack_pointer - 1] = sub(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;
        }
        // 0x04	DIV; Integer division operation
        if(op == 4){
            stack[stack_pointer - 1] = stack[stack_pointer - 1] == 0 ? 0 : div(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;
        }
        // 0x05 SDIV; Signed integer division operation (truncated)
        // 0x06 MOD; Modulo remainder operation
        if(op == 6){
            stack[stack_pointer - 1] = mod(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;            
        }
        // 0x07 SMOD; Signed modulo remainder operation
        // 0x08 ADDMOD; Modulo addition operation
        if(op == 8){
            stack[stack_pointer - 2] = addmod(stack[stack_pointer], stack[stack_pointer - 1], stack[stack_pointer - 2]);
            stack_pointer = stack_pointer - 2;             
        }
        // 0x09 MULMOD; Modulo multiplication operation
        if(op == 9){
            stack[stack_pointer - 2] = mulmod(stack[stack_pointer], stack[stack_pointer - 1], stack[stack_pointer - 2]);
            stack_pointer = stack_pointer - 2;      
        }
        // 0x0a EXP; Exponential operation
        if(op == 10){
            stack[stack_pointer - 1] = exp(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;            
        }
        // 0x0b SIGNEXTEND; Extend length of two's complement signed integer
        // 0x0c GCD; Greatest common divisor operation - Only referenced in simple-vm
        if(op == 12){
            stack[stack_pointer - 1] = gcd(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;            
        }
        // 0x0d LCM; Least common multiple operation - Only referenced in simple-vm
        if(op == 13){
            stack[stack_pointer - 1] = lcm(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;       
        }
        // 0x0e COMBINATION; Combination operation (nCr) - Only referenced in simple-vm
        if(op == 14){
            stack[stack_pointer - 1] = ge(stack[stack_pointer], stack[stack_pointer - 1]) ? comb(stack[stack_pointer], stack[stack_pointer - 1]) : 0;
            stack_pointer = stack_pointer - 1;            
        }

        // 0x0f FACTORIAL; Factorial operation (n!) - Only referenced in simple-vm
        if(op == 15){
            stack[stack_pointer] = factorial(stack[stack_pointer]);          
        }

        // 0x10 LT; Less-than comparison
        if(op == 16){
            stack[stack_pointer - 1] = lt(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;   
        }
        // 0x11 GT;	Greater-than comparison
        if(op == 17){
            stack[stack_pointer - 1] = gt(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;   
        }
        // 0x12	SLT; Signed less-than comparison
        // 0x13	SGT; Signed greater-than comparison
        // 0x14	EQ;	Equality comparison
        if(op == 20){
            stack[stack_pointer - 1] = eq(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;   
        }
        // 0x15	ISZERO;	Simple not operator
        if(op == 21){
            stack[stack_pointer] = iszero(stack[stack_pointer]);
        }

        // 0x60 PUSH
        if(op == 96){
            stack[stack_pointer + 1] = code[pc];
            stack_pointer = stack_pointer + 1;
            pc = pc + 1;
        }

        // 0x16	AND; Bitwise AND operation
        // 0x17	OR; Bitwise OR operation
        // 0x18	XOR; Bitwise XOR operation
        // 0x19	NOT; Bitwise NOT operation
        // 0x1a	BYTE; Retrieve single byte from word
        // 0x1b	SHL; Shift Left
        // 0x1c	SHR; Logical Shift Right
        // 0x1d	SAR; Arithmetic Shift Right
        // 0x20	KECCAK256; Compute Keccak-256 hash

        // 0x21 - 0x2f	Unused	

        // 0x30	ADDRESS; Get address of currently executing account
        // 0x31	BALANCE; Get balance of the given account
        // 0x32	ORIGIN;	Get execution origination address 
        // 0x33	CALLER; Get caller address 
        // 0x34	CALLVALUE; Get deposited value by the instruction/transaction responsible for this execution 
        // 0x35	CALLDATALOAD; Get input data of current environment
        // 0x36	CALLDATASIZE; Get size of input data in current environment
        // 0x37	CALLDATACOPY; Copy input data in current environment to memory 
        // 0x38	CODESIZE; Get size of code running in current environment 
        // 0x39	CODECOPY; Copy code running in current environment to memory
        // 0x3a	GASPRICE; Get price of gas in current environment 
        // 0x3b	EXTCODESIZE; Get size of an account's code
        // 0x3c	EXTCODECOPY; Copy an account's code to memory
        // 0x3d	RETURNDATASIZE; Pushes the size of the return data buffer onto the stack
        // 0x3e	RETURNDATACOPY; Copies data from the return data buffer to memory
        // 0x3f	EXTCODEHASH; Returns the keccak256 hash of a contract's code
        // 0x40	BLOCKHASH; Get the hash of one of the 256 most recent complete blocks 0
        // 0x41	COINBASE; Get the block's beneficiary address 
        // 0x42	TIMESTAMP; Get the block's timestamp 
        // 0x43	NUMBER; Get the block's number 
        // 0x44	DIFFICULTY; Get the block's difficulty 
        // 0x45	GASLIMIT; Get the block's gas limit 
        // 0x46	CHAINID; Returns the current chain’s EIP-155 unique identifier

        // 0x47 - 0x4f	Unused

        // 0x50	POP; Remove word from stack 
        // 0x51	MLOAD; Load word from memory
        // 0x52	MSTORE; Save word to memory
        // 0x53	MSTORE8; Save byte to memory 
        // 0x54	SLOAD; Load word from storage
        // 0x55	SSTORE; Save word to storage
        // 0x56	JUMP; Alter the program counter
        // 0x57	JUMPI; Conditionally alter the program counter
        // 0x58	GETPC; Get the value of the program counter prior to the increment 
        // 0x59	MSIZE; Get the size of active memory in bytes 
        // 0x5a	GAS; Get the amount of available gas, including the corresponding reduction the amount of available gas 
        // 0x5b	JUMPDEST; Mark a valid destination for jumps

        // 0x5c - 0x5f	Unused

        // 0x60	PUSH1; Place 1 byte item on stack 
        // 0x61	PUSH2; Place 2-byte item on stack 
        // 0x62	PUSH3; Place 3-byte item on stack 
        // 0x63	PUSH4; Place 4-byte item on stack 
        // 0x64	PUSH5; Place 5-byte item on stack 
        // 0x65	PUSH6; Place 6-byte item on stack 
        // 0x66	PUSH7; Place 7-byte item on stack 
        // 0x67	PUSH8; Place 8-byte item on stack 
        // 0x68	PUSH9; Place 9-byte item on stack 
        // 0x69	PUSH10; Place 10-byte item on stack 
        // 0x6a	PUSH11; Place 11-byte item on stack 
        // 0x6b	PUSH12; Place 12-byte item on stack 
        // 0x6c	PUSH13; Place 13-byte item on stack 
        // 0x6d	PUSH14; Place 14-byte item on stack 
        // 0x6e	PUSH15; Place 15-byte item on stack 
        // 0x6f	PUSH16; Place 16-byte item on stack 
        // 0x70	PUSH17; Place 17-byte item on stack 
        // 0x71	PUSH18; Place 18-byte item on stack 
        // 0x72	PUSH19; Place 19-byte item on stack 
        // 0x73	PUSH20; Place 20-byte item on stack 
        // 0x74	PUSH21; Place 21-byte item on stack 
        // 0x75	PUSH22; Place 22-byte item on stack 
        // 0x76	PUSH23; Place 23-byte item on stack 
        // 0x77	PUSH24; Place 24-byte item on stack 
        // 0x78	PUSH25; Place 25-byte item on stack 
        // 0x79	PUSH26; Place 26-byte item on stack 
        // 0x7a	PUSH27; Place 27-byte item on stack 
        // 0x7b	PUSH28; Place 28-byte item on stack 
        // 0x7c	PUSH29; Place 29-byte item on stack 
        // 0x7d	PUSH30; Place 30-byte item on stack 
        // 0x7e	PUSH31; Place 31-byte item on stack 
        // 0x7f	PUSH32; Place 32-byte (full word) item on stack 

        // 0x80	DUP1; Duplicate 1st stack item 
        // 0x81	DUP2; Duplicate 2nd stack item 
        // 0x82	DUP3; Duplicate 3rd stack item 
        // 0x83	DUP4; Duplicate 4th stack item 
        // 0x84	DUP5; Duplicate 5th stack item 
        // 0x85	DUP6; Duplicate 6th stack item 
        // 0x86	DUP7; Duplicate 7th stack item 
        // 0x87	DUP8; Duplicate 8th stack item 
        // 0x88	DUP9; Duplicate 9th stack item 
        // 0x89	DUP10; Duplicate 10th stack item 
        // 0x8a	DUP11; Duplicate 11th stack item 
        // 0x8b	DUP12; Duplicate 12th stack item 
        // 0x8c	DUP13; Duplicate 13th stack item 
        // 0x8d	DUP14; Duplicate 14th stack item 
        // 0x8e	DUP15; Duplicate 15th stack item 
        // 0x8f	DUP16; Duplicate 16th stack item 

        // 0x90	SWAP1; Exchange 1st and 2nd stack items 
        // 0x91	SWAP2; Exchange 1st and 3rd stack items 
        // 0x92	SWAP3; Exchange 1st and 4th stack items 
        // 0x93	SWAP4; Exchange 1st and 5th stack items 
        // 0x94	SWAP5; Exchange 1st and 6th stack items 
        // 0x95	SWAP6; Exchange 1st and 7th stack items 
        // 0x96	SWAP7; Exchange 1st and 8th stack items 
        // 0x97	SWAP8; Exchange 1st and 9th stack items 
        // 0x98	SWAP9; Exchange 1st and 10th stack items 
        // 0x99	SWAP10; Exchange 1st and 11th stack items 
        // 0x9a	SWAP11; Exchange 1st and 12th stack items 
        // 0x9b	SWAP12; Exchange 1st and 13th stack items 
        // 0x9c	SWAP13; Exchange 1st and 14th stack items 
        // 0x9d	SWAP14; Exchange 1st and 15th stack items 
        // 0x9e	SWAP15; Exchange 1st and 16th stack items 
        // 0x9f	SWAP16; Exchange 1st and 17th stack items 

        // 0xa0	LOG0; Append log record with no topics
        // 0xa1	LOG1; Append log record with one topic
        // 0xa2	LOG2; Append log record with two topics
        // 0xa3	LOG3; Append log record with three topics
        // 0xa4	LOG4; Append log record with four topics

        // 0xa5 - 0xaf	Unused	

        // 0xb0	JUMPTO; Tentative libevmasm has different numbers
        // 0xb1	JUMPIF; Tentative 
        // 0xb2	JUMPSUB; Tentative 
        // 0xb4	JUMPSUBV; Tentative 
        // 0xb5	BEGINSUB; Tentative 
        // 0xb6	BEGINDATA; Tentative 
        // 0xb8	RETURNSUB; Tentative 
        // 0xb9	PUTLOCAL; Tentative 
        // 0xba	GETLOCAL; Tentative 

        // 0xbb - 0xe0	Unused	

        // 0xe1	SLOADBYTES; Only referenced in pyethereum
        // 0xe2	SSTOREBYTES; Only referenced in pyethereum
        // 0xe3	SSIZE; Only referenced in pyethereum

        // 0xe4 - 0xef	Unused	

        // 0xf0	CREATE;	Create a new account with associated code
        // 0xf1	CALL; Message-call into an account
        // 0xf2	CALLCODE; Message-call into this account with alternative account's code
        // 0xf3	RETURN;	Halt execution returning output data
        // 0xf4	DELEGATECALL; Message-call into this account with an alternative account's code, but persisting into this account with an alternative account's code
        // 0xf5	CREATE2; Create a new account and set creation address to sha3(sender + sha3(init code)) % 2**160

        // 0xf6 - 0xf9	Unused	

        // 0xfa	STATICCALL;	Similar to CALL, but does not modify state

        // 0xfb	Unused
        
        // 0xfc	TXEXECGAS; Not in yellow paper FIXME
        // 0xfd	REVERT; Stop execution and revert state changes, without consuming all provided gas and providing a reason
        // 0xfe	INVALID; Designated invalid instruction
        // 0xff	SELFDESTRUCT; Halt execution and register account for later deletion


        log(stack[7]);
        log(stack[6]);
        log(stack[5]);
        log(stack[4]);
        log(stack[3]);
        log(stack[2]);
        log(stack[1]);
        log(stack[0]);
    }



    out <-- stack[0]; // Dummy output
}
component main = SimpleVM(8);

