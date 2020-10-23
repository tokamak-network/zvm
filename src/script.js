// import { PrismaClient } from '@prisma/client'
const { PrismaClient } = require('@prisma/client')

const prisma = new PrismaClient()

// A `main` function so that you can use async/await
async function main() {
  // console.log(prisma)
  // await create()
  // await del()
  // const a = await getBalance(0);
  // console.log(a)
  console.log(await getBalance(0))
  // const allUsers = await prisma.keystore.findMany({
    
  // })
  // await readUser();

  // const keys = await prisma.keystore.findMany();

  // console.dir(keys, { depth: null })
  
  // use `console.dir` to print nested objects
}

async function readUser () {
  const allUsers = await prisma.keystore.findMany();
  // console.log(allUsers, { depth: null });
  return allUsers;
}

async function create() {
  const post = await prisma.keystore.create({
    data: {
      address: '0xa1df2b32',
      balance: 5
    },
  })
  return post
}

async function getBalance (index) {
  // console.log(index)
  const get = await prisma.keystore.findOne({
    where: {
      id: index
    }
  })

  return get
}

async function delKeys () {
  const post = await prisma.keystore.del
}

async function updateBalance (index, balance) {
  const update = await prisma.user.update({
    where: { id: index },
    data: { balance: balance }
  })

  return update
}

module.exports = { readUser, getBalance, updateBalance }

main()
  .catch(e => {
    throw e
  })
  .finally(async () => {
    await prisma.$disconnect()
  })
