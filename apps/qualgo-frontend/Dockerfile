# Use Node.js official image as the base image
FROM node:23

# Set the working directory
WORKDIR /app

# Create a non-root user
RUN groupadd -g 10000 app && useradd -r -u 10000 -g app app
RUN chown -R app:app /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install --production

# Copy application code
COPY . .

# Switch to the non-root user
USER app

# Expose the frontend port
EXPOSE 3000

# Define the environment variable for the backend API URL
ENV BACKEND_API_URL=http://backend-service:3000

# Start the frontend application
CMD ["node", "index.js"]