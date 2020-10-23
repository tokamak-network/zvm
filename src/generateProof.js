const snarkjs = require("snarkjs");
const fs = require("fs");

async function run(circuit, input_json) {

    const { proof, publicSignals } = await snarkjs.groth16.fullProve(input_json, circuit + ".wasm", "circuit_final.zkey");

    fs.writeFileSync('proof.json', JSON.stringify(proof));
    fs.writeFileSync('public.json', JSON.stringify(publicSignals));

    return JSON.stringify(publicSignals, null, 1);
}

const input_json = {"from": 2721, "from_balance": 10, "to": 6487, "to_balance": 0, "amount": 5};

run(process.argv[2], input_json).then((result) => {
    console.log(result);
    process.exit(0);
})
.catch( (err) =>{
    console.log(err);
});