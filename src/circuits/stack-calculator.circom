function add(left_operand, right_operand){
    return left_operand + right_operand;
}

function sub(left_operand, right_operand){
    return left_operand - right_operand;
}

function mul(left_operand, right_operand){
    return left_operand * right_operand;
}

function div(left_operand, right_operand){
    assert(right_operand != 0);
    return (left_operand - left_operand % right_operand) / right_operand;
}

template stackCalculator(num_operands){
    signal private input operands[num_operands];
    signal private input operators[num_operands];
    signal output out;

    // Assertion; Check input signals
    var length = 0;
    var i;
    var MAX_OPCODE = 3;

    assert(operators[num_operands - 1] == 0);

    for(i = num_operands - 1; i > 0; i = i - 1){
        if(operands[i] == 0 && operands[i - 1] == 0 && operators[i - 1] == 0){
            length = length + 1;
        }
        assert(operators[i - 1] <= MAX_OPCODE);
    }

    length = num_operands - length - 1;

    // Calculate the top index
    var peek;
    peek = length - 1;

    var left;
    var right;
    var op;

    // Pop
    left = operands[peek];
    peek = peek - 1;

    // Calculate the series of op codes
    while(peek >= 0){
        right = operands[peek];
        op = operators[peek];
        peek = peek - 1;

        if(op == 0) left = add(left, right);
        if(op == 1) left = sub(left, right);         
        if(op == 2) left = mul(left, right);
        if(op == 3) left = (left - left % right) / right; // div(left, right);
        
    }
    log(left);
    out <== left;
}

component main = stackCalculator(10);