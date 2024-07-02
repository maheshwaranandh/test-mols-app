#!/bin/bash

# Define the directories
PROJECT_DIR=~/molecular-web-app
MOLE_TOOL_DIR=$PROJECT_DIR/mole-tool
BACKEND_DIR=$MOLE_TOOL_DIR/backend

# Update package lists and install dependencies
echo "Updating package lists..."
sudo apt-get update

echo "Installing Node.js and npm..."
sudo apt-get install -y nodejs npm

echo "Installing pm2 globally..."
sudo npm install -g pm2

# Navigate to mole-tool and install dependencies
echo "Installing dependencies for the frontend..."
cd $MOLE_TOOL_DIR
npm install

# Navigate to backend and install dependencies
echo "Installing dependencies for the backend..."
cd $BACKEND_DIR
npm install

# Start the backend server with pm2
echo "Starting the backend server..."
pm2 start server.js --name mole-tool-backend

# Save pm2 process list and configure pm2 to start on boot
pm2 save
pm2 startup

# Navigate back to mole-tool and start the React app with pm2
echo "Starting the frontend server..."
cd $MOLE_TOOL_DIR
pm2 start npm --name "mole-tool-frontend" -- start

echo "Deployment script executed successfully."
