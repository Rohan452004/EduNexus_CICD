#!/bin/bash
set -e
export AWS_REGION=ap-south-1

APP_DIR="/var/www/edunexus"

cd $APP_DIR

echo "Starting Node application from $APP_DIR..."
echo "Fetching environment variables from AWS Parameter Store..."

# Define all your parameter names
PARAMS=(
  "/edunexus/PORT"
  "/edunexus/DATABASE_URL"
  "/edunexus/CONTACT_MAIL"
  "/edunexus/MAIL_HOST"
  "/edunexus/MAIL_USER"
  "/edunexus/MAIL_PASS"
  "/edunexus/JWT_SECRET"
  "/edunexus/FOLDER_NAME"
  "/edunexus/RAZORPAY_KEY"
  "/edunexus/RAZORPAY_SECRET"
  "/edunexus/CLOUD_NAME"
  "/edunexus/API_KEY"
  "/edunexus/API_SECRET"
  "/edunexus/FRONTEND_URL"
)

# Fetch parameters
for param in "${PARAMS[@]}"; do
  name=$(basename "$param")
  value=$(aws ssm get-parameter --name "$param" --with-decryption --query Parameter.Value --output text) || { echo "Failed to fetch $name"; exit 1; }
  export $name="$value"
done

# Write to .env file
echo "Writing .env file..."
cat > "$APP_DIR/.env" << EOF
PORT=$PORT
DATABASE_URL=$DATABASE_URL
CONTACT_MAIL=$CONTACT_MAIL
MAIL_HOST=$MAIL_HOST
MAIL_USER=$MAIL_USER
MAIL_PASS=$MAIL_PASS
JWT_SECRET=$JWT_SECRET
FOLDER_NAME=$FOLDER_NAME
RAZORPAY_KEY=$RAZORPAY_KEY
RAZORPAY_SECRET=$RAZORPAY_SECRET
CLOUD_NAME=$CLOUD_NAME
API_KEY=$API_KEY
API_SECRET=$API_SECRET
FRONTEND_URL=$FRONTEND_URL
EOF

echo "Starting application with PM2..."

if ! command -v pm2 &> /dev/null; then
    npm install -g pm2
fi

if ! command -v node &> /dev/null; then
    echo "Node.js not found. Please ensure Node.js is installed."
    exit 1
fi

pm2 start "$APP_DIR/index.js" --name "edunexus" --env production

pm2 startup | bash || echo "PM2 startup script failed"
pm2 save || echo "PM2 save failed"

echo "Application started successfully."
