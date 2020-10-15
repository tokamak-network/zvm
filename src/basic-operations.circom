/*
1. 계산순서 직렬화하기 infix
2. 연산 기호를 숫자로 인코딩하기; +: 0, -: 1, *: 2, /:3
3. json으로 export 해서 private signal input으로 넣어주기
*/

// var MAX_OPCODE = 3;

/*
function calBinaryOp(val1, op, val2){
    var temp;

    temp = 0;

    if (op == 0) temp = val1 + val2;
    else if (op == 1) temp = val1 - val2;
    else if (op == 2) temp = val1 * val2;
    else if (op == 3) {
        assert(val2 != 0);
        temp = val1 / val2;
    }
    else{
        //TODO: default value??
        temp = 0;
    }

    return temp;
}
*/

template BasicCalculator(num_numbers){

    var length;
    length = 2 * num_numbers - 1; // the length of input array
    log(length);

    signal private input in[length]; // input signal array in infix format with encoded operation symbols
    signal output out;

    var result;
    result = in[0];
    log(result);


    var i;
    for (i = 1; i < length - 1; i += 2){
        // result = calBinaryOp(result, in[i], in[i + 1]);

        if (in[i] == 0) result = result + in[i + 1];
        else if (in[i] == 1) result = result - in[i + 1];
        else if (in[i] == 2) result = result * in[i + 1];
        else if (in[i] == 3) {
            assert(in[i + 1] != 0);
            result = result / in[i + 1];
        }
        else{
            //TODO: default value??
            result = 0;
        }

        log(result);  
    }
    out <== result;
}

component main = BasicCalculator(4);