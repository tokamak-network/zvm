// Input file will be generated by "../cli/input-generator.py"
// [NOTE] This calculator will takes operators along with the input order, not operator's proirities 

// num_numbers: the number of values that this circuit is wanted to take
template SimpleCalculator(num_numbers){

    signal private input in[num_numbers + 1]; // input signal array in infix format with encoded operation symbols
    signal output out;

    var MAX_OPCODE;
    MAX_OPCODE = 4;

    var operator_sum;
    operator_sum = in[num_numbers]

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
        if (operator == 0) result = result + in[i];
        else if (operator == 1) result = result - in[i];
        else if (operator == 2) result = result * in[i];
        else if (operator == 3) {
            assert(in[i] != 0);
            result = result / in[i];
        }
        else{
            result = 0;
        }
    }
    out <== result;
}

component main = SimpleCalculator(3);