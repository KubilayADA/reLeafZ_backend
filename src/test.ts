import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

async function main() {
  const all = await prisma.treatmentRequest.findMany()
  console.log('DB connected:', all)
}

main()
  .catch(e => console.error(e))
  .finally(() => prisma.$disconnect())