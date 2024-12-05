require('dotenv').config();
const express = require('express');
const mysql = require('mysql2');

const app = express();
const port = 3000;

// MySQL connection
const db = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
});

db.connect(err => {
    if (err) throw err;
    console.log('Connected to MySQL');
});

// API endpoint to get all students
app.get('/students', (req, res) => {
    console.log(`[${new Date().toISOString()}] Accessed /students from IP: ${req.ip}`);

    db.query('SELECT * FROM students', (err, results) => {
        if (err) {
            console.error(`[${new Date().toISOString()}] Error fetching students:`, err);
            res.status(500).send('Error retrieving students');
            return;
        }

        console.log(`[${new Date().toISOString()}] Successfully fetched ${results.length} students`);
        res.json(results);
    });
});

// Health check endpoint
app.get('/health', (req, res) => {
    // Respond with a success status to indicate the backend is healthy
    res.status(200).json({ status: 'healthy', uptime: process.uptime() });
});

app.listen(port, () => {
    console.log(`Backend API is running on http://localhost:${port}`);
});