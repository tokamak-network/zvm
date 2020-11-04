// ADD: OPCODE 0
function add(left_operand, right_operand){
    return left_operand + right_operand;
}
// SUB: OPCODE 1
function sub(left_operand, right_operand){
    return left_operand - right_operand;
}
// MUL: OPCODE 2
function mul(left_operand, right_operand){
    return left_operand * right_operand;
}
// DIV: OPCODE 3
function div(left_operand, right_operand){
    return (left_operand - left_operand % right_operand) / right_operand;
}
// MOD: OPCODE 4
function mod(left_operand, right_operand){
    return left_operand % right_operand;
}
// POW: OPCODE 5
function pow(left_operand, right_operand){
    return left_operand ** right_operand;
}
// GCD: OPCODE 6
function gcd(left_operand, right_operand){
    var temp;
    while (right_operand != 0){
        temp = left_operand % right_operand;
        left_operand = right_operand;
        right_operand = temp;
    }
    return left_operand;
}
// LCM: OPCODE 7
function lcm(left_operand, right_operand){
    var gcd_value;
    gcd_value = gcd(left_operand, right_operand);
    if (gcd_value == 0) return 0;
    return div(left_operand * right_operand, gcd_value);
}
// FACTORIAL: OPCODE 8
function factorial(left_operand){
    if (left_operand == 0 || left_operand == 1) return 1;
    else return left_operand * factorial(left_operand - 1);
}
// LT: OPCODE 9
function lt(left_operand, right_operand){
    return left_operand < right_operand;
}
// LE: OPCODE 10
function le(left_operand, right_operand){
    return left_operand <= right_operand;
}
// GT: OPCODE 11
function gt(left_operand, right_operand){
    return left_operand > right_operand;
}
// GE: OPCODE 12
function ge(left_operand, right_operand){
    return left_operand >= right_operand;
}
// EQ: OPCODE 13
function eq(left_operand, right_operand){
    return left_operand == right_operand;
}
// NE: OPCODE 14
function ne(left_operand, right_operand){
    return left_operand != right_operand;
}
// ISZERO: OPCODE 15
function iszero(left_operand){
    return left_operand == 0;
}


template stackCalculator(num_operands){
    var MAX_OPCODE = 15;
    signal private input operands[num_operands];
    signal private input operators[num_operands];
    signal output out;

    // Assertion; Check input signals
    var length = 0;
    var i;

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

    // Pop; Initialize the left operand value
    left = operands[peek];
    peek = peek - 1;

    // Calculate the series of op codes
    while(peek >= 0){
        // Pop; Allocate the right operand value and the operator code
        right = operands[peek];
        op = operators[peek];
        peek = peek - 1;

        if(op == 0) left = add(left, right);
        if(op == 1) left = sub(left, right);         
        if(op == 2) left = mul(left, right);
        if(op == 3 && right != 0) {
            left = div(left, right);
        }
    }
    log(left);
    out <-- left;
}

// This circuit requires the maximum size of the input array.
// It calculates up to 10 values in the input signals.
component main = stackCalculator(10);