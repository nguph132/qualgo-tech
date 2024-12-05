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

# Expose the backend port
EXPOSE 3000

# Start the backend application
CMD ["node", "index.js"]