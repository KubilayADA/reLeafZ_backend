import express from 'express';
import { faker } from '@faker-js/faker';
import bcrypt from 'bcrypt';

const app = express();

app.get('/api/mock/users', async (req, res) => {
  try {
    const users: any[] = [];

    // 3 PHARMACY
    for (let i = 1; i <= 3; i++) {
      const hashedPassword = await bcrypt.hash(`pharmacy${i}`, 10);
      users.push({
        id: i,
        email: faker.internet.email(),
        password: hashedPassword,
        role: 'PHARMACY',
      });
    }

    // 2 DOCTOR
    for (let i = 1; i <= 2; i++) {
      const hashedPassword = await bcrypt.hash(`doctor${i}`, 10);
      users.push({
        id: 3 + i,
        email: faker.internet.email(),
        password: hashedPassword,
        role: 'DOCTOR',
      });
    }

    // 45 PATIENT
    for (let i = 1; i <= 45; i++) {
      const hashedPassword = await bcrypt.hash(`patient${i}`, 10);
      users.push({
        id: 5 + i,
        email: faker.internet.email(),
        password: hashedPassword,
        role: 'PATIENT',
      });
    }

    res.json(users);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Failed to generate mock users' });
  }
});

const PORT = 4000; // Change from 3001 to 4000
app.listen(PORT, () => console.log(`🚀 Mock API running on http://localhost:${PORT}`));