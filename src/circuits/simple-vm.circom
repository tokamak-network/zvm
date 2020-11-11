// https://github.com/crytic/evm-opcodes


// 0x02	MUL	Multiplication operation	-	5
// 0x03	SUB	Subtraction operation	-	3
// 0x04	DIV	Integer division operation	-	5
// 0x05	SDIV	Signed integer division operation (truncated)	-	5
// 0x06	MOD	Modulo remainder operation	-	5
// 0x07	SMOD	Signed modulo remainder operation	-	5
// 0x08	ADDMOD	Modulo addition operation	-	8
// 0x09	MULMOD	Modulo multiplication operation	-	8
// 0x0a	EXP	Exponential operation	-	10*
// 0x0b	SIGNEXTEND	Extend length of two s complement signed integer	-	5
// 0x10	LT	Less-than comparison	-	3
// 0x11	GT	Greater-than comparison	-	3
// 0x12	SLT	Signed less-than comparison	-	3
// 0x13	SGT	Signed greater-than comparison	-	3
// 0x14	EQ	Equality comparison	-	3
// 0x15	ISZERO	Simple not operator	-	3


template SimpleVM(input_size){

    signal private input code[input_size];
    signal output out;

    var stack[8] = [0,0,0,0,0,0,0,0];
    var stack_pointer = -1;
    var memory[8] = [0,0,0,0,0,0,0,0];
    var pc = 0;
    var op;

    while(pc < input_size){
        
        op = code[pc]; // Extract op code from the code
        pc = pc + 1

        // 0x00	STOP	Halts execution	-	0
        if(op == 0){ 
            pc = input_size
        }
        // 0x01	ADD	Addition operation	-	3
        if(op == 1){
            // TODO: check out of index
            stack[stack_pointer - 1] = stack[stack_pointer - 1] + stack[stack_pointer];
            stack_pointer = stack_pointer - 1;
        }

        // 0x60 PUSH
        if(op == 96){
            // TODO: check out of index
            stack[stack_pointer + 1] = code[pc];
            stack_pointer = stack_pointer + 1;
            pc = pc + 1;
        }
    }

    // log(stack_pointer); // 실행되기 전 값으로 컴파일하고 에러 반환함. 

    out <-- stack[0];
}
component main = SimpleVM(8);

