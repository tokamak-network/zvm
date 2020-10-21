import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

// A `main` function so that you can use async/await
async function main() {
  await create()
  // await del()
  const allUsers = await prisma.user.findMany({
    include: { keys: true },
  })

  const keys = await prisma.keystore.findMany();

  console.dir(keys, { depth: null })
  
  // use `console.dir` to print nested objects
  console.dir(allUsers, { depth: null })
}

async function create() {
  const post = await prisma.keystore.create({
    data: {
      address: '0xa1df2b32',
      balance: 3,
      owner: {
        connect: {
          name: 'onther',
        },
      },
    },
  })
}

// async function del() {
//   await prisma.keystore.delete({
//     where: {id:2}
//   })
// }

main()
  .catch(e => {
    throw e
  })
  .finally(async () => {
    await prisma.$disconnect()
  })
