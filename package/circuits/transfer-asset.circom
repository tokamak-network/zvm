
template Transfer(){

    // in <- from, from_balance, to, to_balance, amount
    signal private input from;
    signal private input from_balance;
    signal private input to;
    signal private input to_balance;
    signal private input amount;
    
    // out -> from_new_balance, to_new_balance
    signal output from_new_balance;
    signal output to_new_balance;

    // Check from's balance
    assert(from_balance - amount >= 0);

    from_new_balance <== from_balance - amount;
    to_new_balance <== to_balance + amount;
}

component main = Transfer();