# Custom Domain Setup Script
# Run this after DNS propagation is complete

# Step 1: Update baseURL in Hugo config
Write-Host "Updating Hugo baseURL to custom domain..." -ForegroundColor Green
(Get-Content config/_default/hugo.toml) -replace 'baseURL = "https://stackspheresolutions.github.io/daily.stackmoments/"', 'baseURL = "https://daily.stackmoments.com/"' | Set-Content config/_default/hugo.toml

# Step 2: Create CNAME file
Write-Host "Creating CNAME file..." -ForegroundColor Green
"daily.stackmoments.com" | Out-File -FilePath "static/CNAME" -Encoding ASCII

# Step 3: Test build
Write-Host "Testing Hugo build..." -ForegroundColor Green
hugo --minify

if ($LASTEXITCODE -eq 0) {
    Write-Host "Build successful!" -ForegroundColor Green
    
    # Step 4: Commit and deploy
    Write-Host "Committing and deploying..." -ForegroundColor Green
    git add .
    git commit -m "Switch to custom domain daily.stackmoments.com after DNS propagation"
    git push origin master
    
    Write-Host "Custom domain deployment complete!" -ForegroundColor Green
    Write-Host "Your site will be available at: https://daily.stackmoments.com/" -ForegroundColor Cyan
} else {
    Write-Host "Build failed! Check for errors above." -ForegroundColor Red
}