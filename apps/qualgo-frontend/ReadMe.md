# Qualgo Frontend Services

This repository includes the code and configuration for the **Qualgo Frontend**

The **Frontend** service is a web application built using Node.js and Express.js. It communicates with the backend API to fetch data and displays it in a user-friendly interface.

## Features:
- Displays a list of students in a table format.
- Communicates with the backend API to fetch data dynamically.
- Can be deployed to Kubernetes with Helm.

## Backend Configuration:

The database connection details are configured using environment variables in the backend service:
- `API_URL`: The URL where the backend API is exposed.