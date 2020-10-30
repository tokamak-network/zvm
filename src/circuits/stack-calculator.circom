
// function size(sum, max_opcode){
//     var i = 0;
//     var q = sum;
//     while (q > 0) {
//         q = division(q, max_opcode);
//         i++;
//     }
//     return i + 1;
// }

function calOperator(left_operand, right_operand, operator){
    var result;
    if (operator == 0) result = left_operand + right_operand;
    else if (operator == 1) result = left_operand - right_operand;
    else if (operator == 2) result = left_operand * right_operand;
    else if (operator == 3) {
        assert(right_operand != 0);
        result = division(left_operand, right_operand);
    }
    return result;
}

// 나머지 없게 나눠야 함.
function division(left_operand, right_operand){
    assert(right_operand != 0);
    var temp; 
    temp = left_operand % right_operand;

    var result;
    result = (left_operand - temp) / right_operand;
    return result;
}

template stackCalculator(num_operands){
    signal private input operands[num_operands];
    signal private input operator_sum;
    signal output out;
    
    var MAX_OPCODE = 4;
    var result = 0;

    // Constraint 1: operator sum으로 계산한 size와 실제 array에서 나타난 stack 사이즈가 같아야 함.
    var i;
    var count = num_operands;
    for(i = num_operands - 1; i >= 0; i--){
        if(operands[i] == 0) {
            count = count - 1;
        }
        // else break; ???
    }
    count === size(operator_sum, MAX_OPCODE);

    var peek;
    peek = count - 1;

    // 1. size function test
    // result = size(operator_sum, MAX_OPCODE);

    // 2. top function test
    //    ABSTRACT: result = top(operands);
    // result = operands[size(operator_sum, MAX_OPCODE) - 1];

    // 3. calculate operator
    // result = calOperator(1, 2, 3);

    // Calculation part
    // peek index를 이용해서 stack 처럼 계산하자.
    var temp_q = operator_sum; // quotient
    var temp_operator;

    for(i = 0; i < 1; i++){
        // Pop
        var left_operand;
        left_operand = operands[peek];
        peek = peek - 1;
        // log(left_operand);

        // Pop
        var right_operand;
        right_operand = operands[peek];
        peek = peek - 1;
        // log(right_operand);

        // Get the operator
        temp_operator = temp_q % MAX_OPCODE;
        temp_q = (temp_q - temp_operator) / MAX_OPCODE;
        // log(temp_operator);

        // Calculate
        var temp_result;
        temp_result = calOperator(left_operand, right_operand, 0); //?
        log(temp_result);

        // // Push
        // operands[peek + 1] = temp_result; // 되나?
        // peek = peek + 1;

        // log(peek);
    }

    // Pring result
    log(result);
    out <== result;

    // TODO: Constraint operand 모두 0이고, operator_sum도 0
}

component main = stackCalculator(10);