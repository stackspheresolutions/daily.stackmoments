# Hugo Static Site Deployment Script for S3
# Usage: .\deploy.ps1

Write-Host "Building Hugo site for production..." -ForegroundColor Green
hugo --minify

if ($LASTEXITCODE -eq 0) {
    Write-Host "Deploying to S3 bucket..." -ForegroundColor Green
    aws s3 sync ./public/ s3://daily.stackmoments --delete --cache-control "max-age=86400"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Deployment complete!" -ForegroundColor Green
        Write-Host "Your site is available at:" -ForegroundColor Yellow
        Write-Host "  Website endpoint: http://daily.stackmoments.s3-website.ap-south-1.amazonaws.com/" -ForegroundColor Cyan
        Write-Host "  S3 endpoint: https://daily.stackmoments.s3.amazonaws.com/" -ForegroundColor Cyan
        Write-Host "Cache headers set to 24 hours (86400 seconds)" -ForegroundColor Gray
    } else {
        Write-Host "Deployment failed!" -ForegroundColor Red
    }
} else {
    Write-Host "Hugo build failed!" -ForegroundColor Red
}