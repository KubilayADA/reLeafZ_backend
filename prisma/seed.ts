import { PrismaClient } from '../src/generated/prisma';

const prisma = new PrismaClient();

async function main() {
  console.log('Starting seed process...');

  // Create mock doctor
  await prisma.doctor.create({
    data: {
      name: 'Dr. John Doe',
      specialty: 'General Practitioner',
      email: 'johndoe@example.com',
      phone: '123-456-7890',
      address: '123 Medical St, Berlin, Germany',
    },
  });
  console.log('Doctor created.');

  // Create mock pharmacies
  await prisma.pharmacy.createMany({
    data: [
      {
        name: 'Apotheke Alfa',
        location: 'Berlin, Germany',
        contact: 'apotheke@alpha.com',
      },
      {
        name: 'Apotheke Beta',
        location: 'Berlin, Germany',
        contact: 'apotheke@beta.com',
      },
    ],
  });
  console.log('Pharmacies created.');

  console.log('Seeding finished.');
}

main()
  .catch((e) => {
    console.error('Error during seeding:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });