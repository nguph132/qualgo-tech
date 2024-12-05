require('dotenv').config();
const express = require('express');

const app = express();
const port = 3000;

// Get the API URL from an environment variable
const apiUrl = process.env.API_URL;

if (!apiUrl) {
    console.error('API_URL is not set. Please define it in the environment.');
    process.exit(1);
}

// Route to fetch and display students
app.get('/', async (req, res) => {
    try {
        // Fetch students from the API
        const response = await fetch(`${apiUrl}/students`);
        if (!response.ok) {
            throw new Error(`Failed to fetch data: ${response.statusText}`);
        }
        const students = await response.json();

        // Generate an HTML table with the data
        let html = `
            <html>
                <head>
                    <title>Students List</title>
                    <style>
                        body { font-family: Arial, sans-serif; margin: 20px; }
                        table { border-collapse: collapse; width: 100%; }
                        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
                        th { background-color: #f4f4f4; }
                    </style>
                </head>
                <body>
                    <h1>Students List</h1>
                    <table>
                        <tr>
                            <th>Name</th>
                            <th>Class</th>
                            <th>Date of Birth</th>
                            <th>Address</th>
                        </tr>
        `;

        students.forEach(student => {
            html += `
                <tr>
                    <td>${student.name}</td>
                    <td>${student.class}</td>
                    <td>${student.date_of_birth}</td>
                    <td>${student.address}</td>
                </tr>
            `;
        });

        html += `
                    </table>
                </body>
            </html>
        `;

        res.send(html);
    } catch (error) {
        console.error(error);
        res.status(500).send('Error fetching data from the API.');
    }
});

app.get('/health', (req, res) => {
    // Respond with a success status to indicate the frontend is healthy
    res.status(200).json({ status: 'healthy', uptime: process.uptime() });
});

app.listen(port, () => {
    console.log(`Frontend app is running at http://localhost:${port}`);
});