#! /bin/bash
circom src/basic-operations.circom --r1cs --wasm --sym -v
snarkjs r1cs info basic-operations.r1cs
snarkjs r1cs export json basic-operations.r1cs basic-operations.r1cs.json
# cat basic-operations.r1cs.json
snarkjs zkey new basic-operations.r1cs pot12_final.ptau circuit_0000.zkey
snarkjs zkey contribute circuit_0000.zkey circuit_0001.zkey --name="1st Contributor Name" -v -e="first random entropy"
snarkjs zkey contribute circuit_0001.zkey circuit_0002.zkey --name="Second contribution Name" -v -e="Another random entropy"
snarkjs zkey verify basic-operations.r1cs pot12_final.ptau circuit_0002.zkey
snarkjs zkey beacon circuit_0002.zkey circuit_final.zkey 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon phase2"
snarkjs zkey verify basic-operations.r1cs pot12_final.ptau circuit_final.zkey
snarkjs zkey export verificationkey circuit_final.zkey verification_key.json
snarkjs wtns calculate basic-operations.wasm src/input.json witness.wtns
snarkjs wtns debug basic-operations.wasm src/input.json witness.wtns basic-operations.sym --trigger --get --set