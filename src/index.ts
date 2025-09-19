import express from 'express'
import dotenv from 'dotenv'
import axios from 'axios'
import { PrismaClient } from '@prisma/client';
import cors from 'cors';


const prisma = new PrismaClient()
dotenv.config()


const app = express()
app.use(express.json())
app.use(cors());

// Test route
app.get('/', (req, res) => res.send('Server is working!'))

// ✅ POST route to receive treatment requests
app.post('/api/treatment/submit', async (req, res) => {
  try {
    const { fullName, email, phone, city, symptoms, zip } = req.body;

    // Step 1: Find or create User
    let user = await prisma.user.findUnique({ where: { email } });
    if (!user) {
      user = await prisma.user.create({
        data: { email, password: 'placeholder', role: 'PATIENT' }
      });
    }

    // Step 2: Find or create Patient
    let patient = await prisma.patient.findUnique({ where: { userId: user.id } });
    if (!patient) {
      patient = await prisma.patient.create({
        data: { user: { connect: { id: user.id } }, zip }
      });
    }

    // Step 3: Create TreatmentRequest linked to patient
    const newRequest = await prisma.treatmentRequest.create({
      data: {
        patient: { connect: { id: patient.id } },
        fullName,
        email,
        phone,
        city,
        symptoms
      }
    });
    console.log('New treatment request:', newRequest);

    res.json({
      message: 'Request submitted successfully',
      data: newRequest
    });

  } catch (error: any) {
    console.error('Error in /api/treatment/submit:', error);
    res.status(500).json({ message: 'Something went wrong', error: error.message, stack: error.stack });
  }
});

// ✅ GET route to fetch mock pharmacies
app.get('/api/mock/pharmacies', async (req, res) => {
  try {
    const response = await axios.get('http://localhost:4000/pharmacies')
    res.json({
      message: 'Mock pharmacies fetched successfully',
      data: response.data
    })
  } catch (error) {
    console.error('Error fetching mock pharmacies:', error)
    res.status(500).json({ message: 'Failed to fetch mock pharmacies' })
  }
});

const PORT = process.env.PORT || 3001
app.listen(PORT, () => console.log(`🚀 Server running on http://localhost:${PORT}`))