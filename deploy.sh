#!/bin/bash

# Prompt for the public IP
read -p "Enter the public IP address: " PUBLIC_IP

# Define the directories
PROJECT_DIR=~/molecular-web-app
MOLE_TOOL_DIR=$PROJECT_DIR/mole-tool
BACKEND_DIR=$MOLE_TOOL_DIR/backend
NGINX_CONF=/etc/nginx/sites-available/default
ENV_FILE=$MOLE_TOOL_DIR/.env

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

# Update the Nginx configuration
echo "Updating Nginx configuration..."
sudo sed -i "s/server_name .*/server_name $PUBLIC_IP;/" $NGINX_CONF

# Update the React app environment variable
echo "Updating React app environment variable..."
echo "REACT_APP_PUBLIC_URL=http://$PUBLIC_IP" > $ENV_FILE

# Restart Nginx to apply changes
echo "Restarting Nginx..."
sudo systemctl restart nginx

echo "Deployment script executed successfully."
