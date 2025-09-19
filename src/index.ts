import express from 'express'
import dotenv from 'dotenv'
import axios from 'axios'
import { PrismaClient } from './generated/prisma'


const prisma = new PrismaClient()
dotenv.config()


const app = express()
app.use(express.json())

// Test route
app.get('/', (req, res) => res.send('Server is working!'))

// ✅ POST route to receive treatment requests
app.post('/api/treatment/submit', async (req, res) => {
  try {
    const { fullName, email, phone, city, symptoms } = req.body

    // Save to database
    const newRequest = await prisma.treatmentRequest.create({
      data: { fullName, email, phone, city, symptoms }
    })

    console.log('New request received:', newRequest)

    res.json({
      message: 'Request submitted successfully',
      data: newRequest
    })
  } catch (error) {
    console.error(error)
    res.status(500).json({ message: 'Something went wrong' })
  }
})
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
})
const PORT = process.env.PORT || 3001
app.listen(PORT, () => console.log(`🚀 Server running on http://localhost:${PORT}`))