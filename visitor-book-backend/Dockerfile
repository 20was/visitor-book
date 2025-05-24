FROM node:20-alpine

WORKDIR /app

# Install wait-for-it script
RUN apk add --no-cache bash

# Copy package files and install dependencies
COPY package*.json ./
RUN npm ci

# Copy the rest of the application code
COPY . .

# Build TypeScript code
RUN npm run build

# Expose the port the app runs on
EXPOSE 3001

# Command to run the application
CMD ["npm", "run", "dev"]