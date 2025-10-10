#!/bin/bash

# Hugo Static Site Deployment Script for S3
# Usage: ./deploy.sh

echo "Building Hugo site for production..."
hugo --minify

echo "Deploying to S3 bucket..."
aws s3 sync ./public/ s3://daily.stackmoments --delete --cache-control "max-age=86400"

echo "Deployment complete!"
echo "Your site is available at: http://daily.stackmoments.s3-website.ap-south-1.amazonaws.com/"
echo "Or using the S3 endpoint: https://daily.stackmoments.s3.amazonaws.com/"

echo "Cache headers set to 24 hours (86400 seconds)"