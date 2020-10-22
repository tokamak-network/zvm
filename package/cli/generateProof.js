const snarkjs = require("snarkjs");
const fs = require("fs");

async function run() {

    const input = JSON.parse(fs.readFileSync(process.argv[3]));

    const { proof, publicSignals } = await snarkjs.groth16.fullProve(input, process.argv[2] + ".wasm", "circuit_final.zkey");

    fs.writeFileSync('proof.json', JSON.stringify(proof));
    fs.writeFileSync('public.json', JSON.stringify(publicSignals));

    console.log("Proof: ");
    console.log(JSON.stringify(proof, null, 1));
    console.log("Public: ");
    console.log(JSON.stringify(publicSignals, null, 1));

    const vKey = JSON.parse(fs.readFileSync("verification_key.json"));

    const res = await snarkjs.groth16.verify(vKey, publicSignals, proof);

    if (res === true) {
        console.log("Verification OK");
    } else {
        console.log("Invalid proof");
    }
}

run().then(() => {
    process.exit(0);
})
.catch( (err) =>{
    console.log(err);
    console.log("$> node generateProof.js [circuit file name] [input json file]");
});