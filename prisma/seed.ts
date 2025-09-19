import { PrismaClient, Prisma } from '@prisma/client';
import axios from 'axios';
import bcrypt from 'bcrypt';
import { faker } from '@faker-js/faker';

const prisma = new PrismaClient();

async function main() {
  console.log('Starting seed process...');

  const { data: users } = await axios.get('http://localhost:4000/api/mock/users');

  for (const u of users) {
    const hashedPassword = await bcrypt.hash(u.password, 10);

    // Create the base user first
    const createdUser = await prisma.user.create({
      data: {
        email: u.email,
        password: hashedPassword,
        role: u.role as 'PATIENT' | 'DOCTOR' | 'PHARMACY' | 'ADMIN'
      },
    });

    // Now create the related record depending on role
    if (u.role === 'PHARMACY') {
  await prisma.pharmacy.create({
    data: {
      userId: createdUser.id,
      name: `Pharmacy ${faker.person.firstName()}`,
      contact: u.email,
      zip: faker.location.zipCode('#####'),  
    },
  });
} else if (u.role === 'DOCTOR') {
  await prisma.doctor.create({
    data: {
      userId: createdUser.id,
      specialty: 'General Practitioner',
    },
  });
} else if (u.role === 'PATIENT') {
  await prisma.patient.create({
    data: {
      userId: createdUser.id,
      zip: faker.location.zipCode('#####'),
    },
  });
}}

  console.log('All mock users seeded successfully.');
}

main()
  .catch((e) => {
    console.error('Error during seeding:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });