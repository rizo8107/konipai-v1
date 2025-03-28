# Use Node.js LTS as the base image
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Define build arguments for environment variables
ARG VITE_POCKETBASE_URL
ARG POCKETBASE_ADMIN_EMAIL
ARG POCKETBASE_ADMIN_PASSWORD
ARG VITE_RAZORPAY_KEY_ID
ARG RAZORPAY_KEY_SECRET
ARG VITE_SITE_TITLE
ARG VITE_SITE_LOGO
ARG EMAIL_HOST
ARG EMAIL_PORT
ARG EMAIL_USER
ARG EMAIL_PASSWORD
ARG EMAIL_FROM
ARG SMTP_HOST
ARG SMTP_PORT
ARG SMTP_SECURE
ARG SMTP_USER
ARG SMTP_PASSWORD
ARG VITE_GEMINI_API_KEY
ARG VITE_WHATSAPP_API_URL

# Set environment variables
ENV VITE_POCKETBASE_URL=$VITE_POCKETBASE_URL
ENV POCKETBASE_ADMIN_EMAIL=$POCKETBASE_ADMIN_EMAIL
ENV POCKETBASE_ADMIN_PASSWORD=$POCKETBASE_ADMIN_PASSWORD
ENV VITE_RAZORPAY_KEY_ID=$VITE_RAZORPAY_KEY_ID
ENV RAZORPAY_KEY_SECRET=$RAZORPAY_KEY_SECRET
ENV VITE_SITE_TITLE=$VITE_SITE_TITLE
ENV VITE_SITE_LOGO=$VITE_SITE_LOGO
ENV EMAIL_HOST=$EMAIL_HOST
ENV EMAIL_PORT=$EMAIL_PORT
ENV EMAIL_USER=$EMAIL_USER
ENV EMAIL_PASSWORD=$EMAIL_PASSWORD
ENV EMAIL_FROM=$EMAIL_FROM
ENV SMTP_HOST=$SMTP_HOST
ENV SMTP_PORT=$SMTP_PORT
ENV SMTP_SECURE=$SMTP_SECURE
ENV SMTP_USER=$SMTP_USER
ENV SMTP_PASSWORD=$SMTP_PASSWORD
ENV VITE_GEMINI_API_KEY=$VITE_GEMINI_API_KEY
ENV VITE_WHATSAPP_API_URL=$VITE_WHATSAPP_API_URL

# Install global dependencies
RUN npm install -g tsx serve

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the frontend
RUN npm run build

# Build the server files
RUN npm run build:server

# Create a start script
RUN echo '#!/bin/sh\n\
echo "Starting servers..."\n\
serve -s dist -p 8080 & tsx src/server/index.ts\n\
' > start.sh && chmod +x start.sh

# Expose the ports the app runs on
EXPOSE 8080 3001 3002 3003 3004 4001 4002 4003

# Start both the frontend and backend servers
CMD ["./start.sh"]
