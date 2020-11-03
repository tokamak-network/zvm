#! /bin/bash

function help () {
    echo "Commands"
    echo "1. Setup phase 1:          $ ./zk-vm.sh phase1"
    echo "2. Setup phase 2:          $ ./zk-vm.sh phase2 [circuit name]"
    echo "3. Debug with the witness: $ ./zk-vm.sh debug [circuit name] [input json file path]"
    echo "4. Generate a proof:       $ ./zk-vm.sh generate-proof [proof file name] [public file name]"
    echo "5. Verify a proof:         $ ./zk-vm.sh verify-proof [public file path] [proof file path]"
} 

# phase 1 setup
# > ./zk-vm.sh phase1
if [ "$1" == "phase1" -a $# -eq 1 ]
then
    snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
    snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v -e="some random text" # You can enter your random text.
    snarkjs powersoftau contribute pot12_0001.ptau pot12_0002.ptau --name="Second contribution" -v -e="some random text"
    snarkjs powersoftau verify pot12_0002.ptau
    snarkjs powersoftau beacon pot12_0002.ptau pot12_beacon.ptau 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon"
    snarkjs powersoftau prepare phase2 pot12_beacon.ptau pot12_final.ptau -v

# phase 2 setup
# > ./zk-vm.sh phase2 [circuit name]
elif [ "$1" == "phase2" -a $# -eq 2 ]
then
    if [ -e circuits/$2.circom ]
    then 
        snarkjs powersoftau verify pot12_final.ptau
        circom circuits/$2.circom --r1cs --wasm --sym -v
        snarkjs r1cs info $2.r1cs
        snarkjs r1cs export json $2.r1cs $2.r1cs.json
        snarkjs zkey new $2.r1cs pot12_final.ptau circuit_0000.zkey
        snarkjs zkey contribute circuit_0000.zkey circuit_0001.zkey --name="1st Contributor Name" -v -e="first random entropy" # You can enter your random text.
        snarkjs zkey contribute circuit_0001.zkey circuit_0002.zkey --name="Second contribution Name" -v -e="Another random entropy"
        snarkjs zkey verify $2.r1cs pot12_final.ptau circuit_0002.zkey
        snarkjs zkey beacon circuit_0002.zkey circuit_final.zkey 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon phase2"
        snarkjs zkey verify $2.r1cs pot12_final.ptau circuit_final.zkey
        snarkjs zkey export verificationkey circuit_final.zkey verification_key.json
    else 
        echo "The circuit does not exist."
        help
    fi

# debug
# ./zk-vm.sh debug [circuit name] [input json file]
elif [ "$1" == "debug" -a $# -eq 3 ]
then
    if [ -e circuits/$2.circom -a -e $3 ]
    then 
        snarkjs wtns calculate $2.wasm $3 witness.wtns
        snarkjs wtns debug $2.wasm $3 witness.wtns $2.sym --trigger --get --set
    else
        echo "The passed files are not found."
        help
    fi

# generate proof
# ./zk-vm.sh generate-proof [proof file name] [public file name]
elif [ "$1" == "generate-proof" -a $# -eq 3 ]
then 
    snarkjs groth16 prove circuit_final.zkey witness.wtns $2.json $3.json

# verify proof
# ./zk-vm.sh verify-proof [public file path] [proof file path]
elif [ "$1" == "verify-proof" -a $# -eq 3 ]
then

    if [ -e $2  -a -e $3 ]
    then 
        snarkjs groth16 verify verification_key.json $2 $3

    else
        echo "proof file or public file are not found."
    fi

# help
elif [ "$1" == "help" ]
then 
    help

else 
    help
fi