# Qualgo Application Services

This repository includes the code and configuration for the **Qualgo Application**

The **Backend** service is responsible for managing the business logic, handling database interactions, and providing an API for the frontend to consume. It is built using Node.js and connects to a MySQL database.

## Features:
- Exposes REST API endpoints `/students`
- Connects to a MySQL database to store and manage data.
- Can be deployed to Kubernetes with Helm.

## Database Configuration:
The database connection details are configured using environment variables in the backend service:
- `DB_HOST`: The database host (e.g., AWS RDS, local MySQL).
- `DB_USER`: The database username.
- `DB_PASSWORD`: The database password.
- `DB_NAME`: The database name used by the application.