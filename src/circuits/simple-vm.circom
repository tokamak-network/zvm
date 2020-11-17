// EVM opcode list reference: https://github.com/crytic/evm-opcodes

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
function and(left_operand, right_operand){
    return left_operand & right_operand;
}
function or(left_operand, right_operand){
    return left_operand | right_operand;
}
function xor(left_operand, right_operand){
    return left_operand ^ right_operand;
}
function not(left_operand){
    return ~left_operand;
}
function shl(left_operand, right_operand){
    return left_operand << right_operand;
}
function shr(left_operand, right_operand){
    return left_operand >> right_operand;
}
function sar(left_operand, right_operand){
    // [NOTE] Limited function in the finite field, Z/pZ (p = 21888242871839275222246405745257275088548364400416034343698204186575808495617)
    // Reference: https://stackoverflow.com/questions/25206670/how-to-implement-arithmetic-right-shift-from-logical-shift
    return (left_operand >> right_operand) | (-(left_operand >> 253) << (254 - right_operand));
}
function sha253(left_operand, right_operand){
    // WIP
    return 0;
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

    // Signal Definitions
    signal private input code[input_size];
    signal output out;

    // Stack initialization
    var STACK_SIZE = 8;
    var stack[STACK_SIZE] = [0,0,0,0,0,0,0,0];
    var stack_pointer = -1;

    // Memory initialization
    var MEM_SIZE = 8;
    var memory[MEM_SIZE] = [0,0,0,0,0,0,0,0];
    var mem_length = 0;

    // Program counter initialization
    var pc = 0;

    // Opcode variable
    var op;

    while(pc < input_size){
        
        op = code[pc]; // Extract op code from the code
        pc = pc + 1

        // 0x00	STOP; Halts execution
        if(op == 0x0){ 
            pc = input_size
        }
        // 0x01	ADD; Addition operation
        if(op == 0x1){
            stack[stack_pointer - 1] = add(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;
        }
        // 0x02	MUL; Multiplication operation
        if(op == 0x2){
            stack[stack_pointer - 1] = mul(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;
        }
        // 0x03	SUB; Subtraction operation
        if(op == 0x3){
            stack[stack_pointer - 1] = sub(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;
        }
        // 0x04	DIV; Integer division operation
        if(op == 0x4){
            stack[stack_pointer - 1] = stack[stack_pointer - 1] == 0 ? 0 : div(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;
        }
        // 0x05 SDIV; Signed integer division operation (truncated)
        // 0x06 MOD; Modulo remainder operation
        if(op == 0x6){
            stack[stack_pointer - 1] = mod(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;            
        }
        // [TODO] 0x07 SMOD; Signed modulo remainder operation
        // 0x08 ADDMOD; Modulo addition operation
        if(op == 0x8){
            stack[stack_pointer - 2] = addmod(stack[stack_pointer], stack[stack_pointer - 1], stack[stack_pointer - 2]);
            stack_pointer = stack_pointer - 2;             
        }
        // 0x09 MULMOD; Modulo multiplication operation
        if(op == 0x9){
            stack[stack_pointer - 2] = mulmod(stack[stack_pointer], stack[stack_pointer - 1], stack[stack_pointer - 2]);
            stack_pointer = stack_pointer - 2;      
        }
        // 0x0a EXP; Exponential operation
        if(op == 0xa){
            stack[stack_pointer - 1] = exp(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;            
        }
        // [TODO] 0x0b SIGNEXTEND; Extend length of two's complement signed integer
        // 0x0c GCD; Greatest common divisor operation - Only referenced in simple-vm
        if(op == 0xc){
            stack[stack_pointer - 1] = gcd(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;            
        }
        // 0x0d LCM; Least common multiple operation - Only referenced in simple-vm
        if(op == 0xd){
            stack[stack_pointer - 1] = lcm(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;       
        }
        // 0x0e COMBINATION; Combination operation (nCr) - Only referenced in simple-vm
        if(op == 0xe){
            stack[stack_pointer - 1] = stack[stack_pointer] >= stack[stack_pointer - 1] ? comb(stack[stack_pointer], stack[stack_pointer - 1]) : 0;
            stack_pointer = stack_pointer - 1;            
        }
        // 0x0f FACTORIAL; Factorial operation (n!) - Only referenced in simple-vm
        if(op == 0xf){
            stack[stack_pointer] = stack[stack_pointer] >= 0 ? factorial(stack[stack_pointer]): 0;          
        }
        // 0x10 LT; Less-than comparison
        if(op == 0x10){
            stack[stack_pointer - 1] = lt(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;   
        }
        // 0x11 GT;	Greater-than comparison
        if(op == 0x11){
            stack[stack_pointer - 1] = gt(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;   
        }
        // [TODO] 0x12	SLT; Signed less-than comparison
        // [TODO] 0x13	SGT; Signed greater-than comparison
        // 0x14	EQ;	Equality comparison
        if(op == 0x14){
            stack[stack_pointer - 1] = eq(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;   
        }
        // 0x15	ISZERO;	Simple not operator
        if(op == 0x15){
            stack[stack_pointer] = iszero(stack[stack_pointer]);
        }
        // 0x16	AND; Bitwise AND operation
        if(op == 0x16){
            stack[stack_pointer - 1] = and(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;  
        }
        // 0x17	OR; Bitwise OR operation
        if(op == 0x17){
            stack[stack_pointer - 1] = or(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;             
        }
        // 0x18	XOR; Bitwise XOR operation
        if(op == 0x18){
            stack[stack_pointer - 1] = xor(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;             
        }        
        // 0x19	NOT; Bitwise NOT operation
        if(op == 0x19){
            stack[stack_pointer] = not(stack[stack_pointer]);            
        }   
        // [TODO] 0x1a	BYTE; Retrieve single byte from word
        // 0x1b	SHL; Shift Left
        if(op == 0x1b){
            stack[stack_pointer - 1] = shl(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;             
        }     
        // 0x1c	SHR; Logical Shift Right
        if(op == 0x1c){
            stack[stack_pointer - 1] = shr(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;             
        }     
        // 0x1d	SAR; Arithmetic Shift Right
        if(op == 0x1d){
            stack[stack_pointer - 1] = sar(stack[stack_pointer], stack[stack_pointer - 1]);
            stack_pointer = stack_pointer - 1;             
        }     

        // [TODO] 0x20	KECCAK256; Compute Keccak-256 hash

        // 0x21 - 0x2f	Unused	

        // [TODO] 0x30	ADDRESS; Get address of currently executing account
        // [TODO] 0x31	BALANCE; Get balance of the given account
        // [TODO] 0x32	ORIGIN;	Get execution origination address 
        // [TODO] 0x33	CALLER; Get caller address 
        // [TODO] 0x34	CALLVALUE; Get deposited value by the instruction/transaction responsible for this execution 
        // [TODO] 0x35	CALLDATALOAD; Get input data of current environment
        // [TODO] 0x36	CALLDATASIZE; Get size of input data in current environment
        // [TODO] 0x37	CALLDATACOPY; Copy input data in current environment to memory 
        // [TODO] 0x38	CODESIZE; Get size of code running in current environment 
        // [TODO] 0x39	CODECOPY; Copy code running in current environment to memory
        // [TODO] 0x3a	GASPRICE; Get price of gas in current environment 
        // [TODO] 0x3b	EXTCODESIZE; Get size of an account's code
        // [TODO] 0x3c	EXTCODECOPY; Copy an account's code to memory
        // [TODO] 0x3d	RETURNDATASIZE; Pushes the size of the return data buffer onto the stack
        // [TODO] 0x3e	RETURNDATACOPY; Copies data from the return data buffer to memory
        // [TODO] 0x3f	EXTCODEHASH; Returns the keccak256 hash of a contract's code
        // [TODO] 0x40	BLOCKHASH; Get the hash of one of the 256 most recent complete blocks 0
        // [TODO] 0x41	COINBASE; Get the block's beneficiary address 
        // [TODO] 0x42	TIMESTAMP; Get the block's timestamp 
        // [TODO] 0x43	NUMBER; Get the block's number 
        // [TODO] 0x44	DIFFICULTY; Get the block's difficulty 
        // [TODO] 0x45	GASLIMIT; Get the block's gas limit 
        // [TODO] 0x46	CHAINID; Returns the current chain’s EIP-155 unique identifier

        // 0x47 - 0x4f	Unused

        // 0x50	POP; Remove word from stack 
        if(op == 0x50){
            stack_pointer = stack_pointer - 1;
        }
        // 0x51	MLOAD; Load word from memory
        if(op == 0x51){
            // [NOTE] It is referenced by index of unsigned int array
            if(stack_pointer >= 0){
                var mem_index = stack[stack_pointer];
                stack[stack_pointer] = (stack[stack_pointer] <= MEM_SIZE) ? memory[mem_index] : 0;  
            }
        }
        // 0x52	MSTORE; Save word to memory
        if(op == 0x52){
            var mem_index = stack[stack_pointer];
            memory[mem_index] = stack[stack_pointer - 1];
            stack_pointer = stack_pointer - 2;
            mem_length = mem_length + 1;
        }
        // [TODO] 0x53	MSTORE8; Save byte to memory 
        // [TODO] 0x54	SLOAD; Load word from storage
        // [TODO] 0x55	SSTORE; Save word to storage
        // 0x56	JUMP; Alter the program counter
        if(op == 0x56){
            pc = stack[stack_pointer] < input_size ? stack[stack_pointer] : input_size;
            stack_pointer = stack_pointer - 1;
        }
        // 0x57	JUMPI; Conditionally alter the program counter
        if(op == 0x57){
            if(stack[stack_pointer - 1]){
                pc = stack[stack_pointer] < input_size ? stack[stack_pointer] : input_size;
                stack_pointer = stack_pointer - 2;
            }
        }
        // 0x58	GETPC; Get the value of the program counter prior to the increment 
        if(op == 0x58){
            if(stack_pointer + 1 < STACK_SIZE){
                stack[stack_pointer + 1] = pc - 1;
                stack_pointer = stack_pointer + 1; 
            }
        }
        // 0x59	MSIZE; Get the size of active memory in bytes 
        if(op == 0x59){
            if(stack_pointer + 1 < STACK_SIZE){
                stack[stack_pointer + 1] = mem_length;
                stack_pointer = stack_pointer + 1; 
            }
        }
        // [TODO] 0x5a	GAS; Get the amount of available gas, including the corresponding reduction the amount of available gas 
        // 0x5b	JUMPDEST; Mark a valid destination for jumps

        // 0x5c - 0x5f	Unused

        // 0x60 PUSH; Place one uint item on stack
        if(op == 0x60){
            stack[stack_pointer + 1] = code[pc];
            stack_pointer = stack_pointer + 1;
            pc = pc + 1;
        }
        // [TODO] 0x60	PUSH1; Place 1 byte item on stack 
        // ...
        // [TODO] 0x7f	PUSH32; Place 32-byte (full word) item on stack 

        // 0x80	DUP1; Duplicate 1st stack item 
        // ...
        // 0x8f	DUP16; Duplicate 16th stack item 
        if(op >= 0x80 && op < 0x90){
            if(stack_pointer + 1 < STACK_SIZE){
                stack[stack_pointer + 1] = (stack_pointer >= op - 0x80) ? stack[stack_pointer - op + 0x80] : 0;
                stack_pointer = stack_pointer + 1;
            }
        }

        // 0x90	SWAP1; Exchange 1st and 2nd stack items 
        // ...
        // 0x9f	SWAP16; Exchange 1st and 17th stack items 
        if(op >= 0x90 && op < 0xa0){
            if(op - 0x8f <= stack_pointer){
                var temp;
                temp = stack[stack_pointer];
                stack[stack_pointer] = stack[stack_pointer - op + 0x8f];
                stack[stack_pointer - op + 0x8f] = temp;
            }
        }

        // [TODO] 0xa0	LOG0; Append log record with no topics
        // [TODO] 0xa1	LOG1; Append log record with one topic
        // [TODO] 0xa2	LOG2; Append log record with two topics
        // [TODO] 0xa3	LOG3; Append log record with three topics
        // [TODO] 0xa4	LOG4; Append log record with four topics

        // 0xa5 - 0xaf	Unused	

        // https://github.com/ethereum/EIPs/issues/615
        // [TODO] 0xb0	JUMPTO; Tentative libevmasm has different numbers
        // [TODO] 0xb1	JUMPIF; Tentative 
        // [TODO] 0xb2	JUMPSUB; Tentative 
        // [TODO] 0xb4	JUMPSUBV; Tentative 
        // [TODO] 0xb5	BEGINSUB; Tentative 
        // [TODO] 0xb6	BEGINDATA; Tentative 
        // [TODO] 0xb8	RETURNSUB; Tentative 
        // [TODO] 0xb9	PUTLOCAL; Tentative 
        // [TODO] 0xba	GETLOCAL; Tentative 

        // 0xbb - 0xef	Unused

        // [TODO] 0xf0	CREATE;	Create a new account with associated code
        // [TODO] 0xf1	CALL; Message-call into an account
        // [TODO] 0xf2	CALLCODE; Message-call into this account with alternative account's code
        // [TODO] 0xf3	RETURN;	Halt execution returning output data
        // [TODO] 0xf4	DELEGATECALL; Message-call into this account with an alternative account's code, but persisting into this account with an alternative account's code
        // [TODO] 0xf5	CREATE2; Create a new account and set creation address to sha3(sender + sha3(init code)) % 2**160

        // 0xf6 - 0xf9	Unused	

        // [TODO] 0xfa	STATICCALL;	Similar to CALL, but does not modify state

        // 0xfb	Unused
        
        // [TODO] 0xfc	TXEXECGAS; Not in yellow paper FIXME
        // [TODO] 0xfd	REVERT; Stop execution and revert state changes, without consuming all provided gas and providing a reason
        // [TODO] 0xfe	INVALID; Designated invalid instruction
        // [TODO] 0xff	SELFDESTRUCT; Halt execution and register account for later deletion


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