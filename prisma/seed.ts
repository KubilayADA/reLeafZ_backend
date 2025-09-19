import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcrypt';
import { faker } from '@faker-js/faker';

const prisma = new PrismaClient();

async function main() {
  console.log('Starting full mock seed process...');

  const TOTAL_USERS = 50;
  const PHARMACIES = 3;
  const DOCTORS = 2;

  for (let i = 1; i <= TOTAL_USERS; i++) {
    // Determine role
    let role: 'PHARMACY' | 'DOCTOR' | 'PATIENT';
    if (i <= PHARMACIES) role = 'PHARMACY';
    else if (i <= PHARMACIES + DOCTORS) role = 'DOCTOR';
    else role = 'PATIENT';

    // Generate basic user info
    const email = faker.internet.email();
    const password = await bcrypt.hash(faker.internet.password(), 10);

    // Create User
    const createdUser = await prisma.user.create({
      data: {
        email,
        password,
        role,
      },
    });

    // Create related entity based on role
    if (role === 'PHARMACY') {
      await prisma.pharmacy.create({
        data: {
          userId: createdUser.id,
          name: `Pharmacy ${faker.company.name()}`,
          contact: faker.internet.email(),
          zip: faker.location.zipCode('#####'),
        },
      });
    } else if (role === 'DOCTOR') {
      await prisma.doctor.create({
        data: {
          userId: createdUser.id,
          specialty: faker.helpers.arrayElement([
            'General Practitioner',
            'Cannabis Specialist',
            'Neurologist',
          ]),
        },
      });
    } else if (role === 'PATIENT') {
      const createdPatient = await prisma.patient.create({
        data: {
          userId: createdUser.id,
          zip: faker.location.zipCode('#####'),
        },
      });

      // Optionally, create 0–2 treatment requests for this patient
      const requestsCount = faker.number.int({ min: 0, max: 2 });
      for (let j = 0; j < requestsCount; j++) {
        await prisma.treatmentRequest.create({
          data: {
            patientId: createdPatient.id,
      fullName: faker.person.fullName(),
      email: faker.internet.email(),
      phone: faker.phone.number(),
      city: faker.location.city(),
      symptoms: faker.lorem.sentence(),
          },
        });
      }
    }
  }

  console.log('All mock users, doctors, pharmacies, and patients seeded successfully.');
}

main()
  .catch((e) => {
    console.error('Error during seeding:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });