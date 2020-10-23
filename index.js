const prompts = require('prompts');
prompts.override(require('yargs').argv);
const { readUser, getBalance, updateBalance } = require('./src/script.js')
const { run } = require('./src/generateProof');
 
async function main () {
  const [ keys ] = await Promise.all([readUser()])
  let choice = []
  for (const key of keys) {
    let item = {
      title: key['address'],
      description: key['balance'].toString(),
      value: key['id']
    }
    choice.push(item)
  }
  const response = await prompts([
    {
      type: 'select',
      name: 'sender account',
      message: 'Select Account',
      choices: choice
    },
    {
      type: 'select',
      name: 'receiver account',
      message: 'Secet Account',
      choices: choice
    },
    {
      type: 'number',
      name: 'balance',
      message: 'How many balance do you want send?',
    }
  ]);

  const senderIndex = await response['sender account']
  const receiverIndex = await response['receiver account']

  const [
    balance1,
    balance2
  ] = await Promise.all([
    getBalance(senderIndex),
    getBalance(receiverIndex)
  ])

  const input = {
    from: await response['sender account'],
    from_balance: balance1.balance,
    to: await response['receiver account'],
    to_balance: balance2.balance,
    amount: await response['balance']
  }
  console.log(input)

  // const a = await run()

  // const [
  //   updatedFrom,
  //   updatedTo
  // ] = await Promise.all([
  //   updateBalance(fromIndex, fromBalance),
  //   updateBalance(toIndex, toBalance)
  // ])

  

  // console.log(updatedFrom)
  // console.log(updatedTo)
};

main();