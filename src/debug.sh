#! /bin/bash

if [ $# -ne 2 ];
then 
    echo "Please check the required parameters"
    echo "$> ./compile.sh [circom file name] [input json file]"
    exit 1
fi

echo debug $1 with input file $2

snarkjs wtns calculate $1.wasm $2 witness.wtns
snarkjs wtns debug $1.wasm $2 witness.wtns $1.sym --trigger --get --set

echo Done