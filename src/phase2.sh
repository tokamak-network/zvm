#! /bin/bash

if [ $# -ne 1 ];
then 
    echo "Please check the required parameters"
    echo "$> ./compile.sh [circom file name]"
    exit 1
fi

echo compile $1

snarkjs powersoftau verify pot12_final.ptau

circom circuits/$1.circom --r1cs --wasm --sym -v
snarkjs r1cs info $1.r1cs
snarkjs r1cs export json $1.r1cs $1.r1cs.json
# cat $1.r1cs.json
snarkjs zkey new $1.r1cs pot12_final.ptau circuit_0000.zkey
snarkjs zkey contribute circuit_0000.zkey circuit_0001.zkey --name="1st Contributor Name" -v -e="first random entropy"
snarkjs zkey contribute circuit_0001.zkey circuit_0002.zkey --name="Second contribution Name" -v -e="Another random entropy"
snarkjs zkey verify $1.r1cs pot12_final.ptau circuit_0002.zkey
snarkjs zkey beacon circuit_0002.zkey circuit_final.zkey 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon phase2"
snarkjs zkey verify $1.r1cs pot12_final.ptau circuit_final.zkey
snarkjs zkey export verificationkey circuit_final.zkey verification_key.json
# 여기까지는 미리 사용자 로컬 환경에 존재해야 함.

echo Done