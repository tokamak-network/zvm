template BasicCalculator(num_numbers){

    signal private input in[num_numbers + 1]; // input signal array in infix format with encoded operation symbols
    signal output out;

    var MAX_OPCODE;
    MAX_OPCODE = 4;

    var operator_sum;
    operator_sum = in[num_numbers]
    // log(operator_sum)

    var result;
    result = in[0];

    var i;
    var operator;

    for (i = 1; i < num_numbers; i++){

        operator = operator_sum % MAX_OPCODE
        if (operator_sum < MAX_OPCODE){
            operator_sum = 0
        }
        else{
            operator_sum = (operator_sum -operator) / MAX_OPCODE 
        }

        log(operator)
        log(operator_sum)

        if (operator == 0) result = result + in[i];
        else if (operator == 1) result = result - in[i];
        else if (operator == 2) result = result * in[i];
        else if (operator == 3) {
            assert(in[i] != 0);
            result = result / in[i];
        }
        else{
            //TODO: default value??
            result = 0;
        }

        log(result);  
    }
    out <== result;
}

component main = BasicCalculator(3);