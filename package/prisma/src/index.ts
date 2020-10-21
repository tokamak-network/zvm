import { 
  PrismaClient,
  PrismaClientOptions,
 } from '@prisma/client'
import path from 'path'
import fs from 'fs'
import { v4 } from 'uuid'
import AsyncLock from 'async-lock'

export interface MockupDB {
  db: DB
  terminate: () => Promise<void>
}

enum Lock {
  EXCLUSIVE = 'exclusive',
}

export class DB {
  lock: AsyncLock

  constructor(option?: PrismaClientOptions) {
    const client = new PrismaClient(option);

    this.prisma = (client as unknown) as PrismaClient
    this.lock = new AsyncLock()
  }

  prisma: PrismaClient

  async read<T>(query: (prisma: PrismaClient) => Promise<T>): Promise<T> {
    let result: T | undefined
    await this.lock.acquire([Lock.EXCLUSIVE], async () => {
      result = await query(this.prisma)
    })
    if (result === undefined) throw Error('Failed to write data from db')
    return result
  }

  async write<T>(query: (prisma: PrismaClient) => Promise<T>): Promise<T> {
    let result: T | undefined
    await this.lock.acquire([Lock.EXCLUSIVE], async () => {
      result = await query(this.prisma)
    })
    if (result === undefined) throw Error('Failed to write data from db')
    return result
  }

  static async mockup(name?: string): Promise<MockupDB> {
    const dbName = name || `mockup-${v4()}.db`
    const dbPath = path.join(path.resolve('.'), dbName)
    const dirPath = path.join(dbPath, '../')
    fs.mkdirSync(dirPath, { recursive: true })
    const predefined = `${path.join(path.resolve(__dirname), '../mockup.db')}`
    await fs.promises.copyFile(predefined, dbPath)
    const db = new DB({
      datasources: {
        sqlite: { url: `file://${dbPath}` },
      },
    })
    const terminate = async () => {
      fs.unlinkSync(dbPath)
      await db.prisma.disconnect()
    }
    return { db, terminate }
  }
}