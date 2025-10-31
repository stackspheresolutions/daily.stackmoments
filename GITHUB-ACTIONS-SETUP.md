# GitHub Actions & Pages Setup Guide

## Current Status

✅ **Workflow file exists:** `.github/workflows/hugo.yml`  
❓ **Actions may need to be enabled**

---

## Quick Fix Checklist

### 1. Enable GitHub Actions

**Go to:** https://github.com/stackspheresolutions/daily.stackmoments/settings/actions

**Set these permissions:**

#### Actions permissions:
- ✅ Select: **"Allow all actions and reusable workflows"**

#### Workflow permissions:
- ✅ Select: **"Read and write permissions"**
- ✅ Check: **"Allow GitHub Actions to create and approve pull requests"**

Click **Save**

---

### 2. Enable GitHub Pages

**Go to:** https://github.com/stackspheresolutions/daily.stackmoments/settings/pages

**Configure:**
- **Source:** Select **"GitHub Actions"** (NOT "Deploy from a branch")
- Click **Save**

If using custom domain:
- **Custom domain:** Enter `daily.stackmoments.com`
- **Enforce HTTPS:** Check this (after DNS propagation)

---

### 3. Trigger a Workflow Run

After enabling Actions, trigger a new deployment:

#### Option A: Manual trigger via GitHub UI
1. Go to: https://github.com/stackspheresolutions/daily.stackmoments/actions
2. Click on **"Deploy Hugo site to Pages"** workflow
3. Click **"Run workflow"** button
4. Select branch: **master**
5. Click **"Run workflow"**

#### Option B: Push a new commit (from your local machine)
```powershell
git commit --allow-empty -m "Trigger GitHub Actions workflow"
git push origin master
```

---

## Verification Steps

### Check Workflow Status
1. **Go to Actions tab:**  
   https://github.com/stackspheresolutions/daily.stackmoments/actions

2. **Look for:**
   - ✅ Green checkmark = Success
   - 🟡 Yellow dot = Running
   - ❌ Red X = Failed

3. **Click on a workflow run** to see detailed logs

### Check Deployment Status
1. **Go to Deployments:**  
   https://github.com/stackspheresolutions/daily.stackmoments/deployments

2. **Look for:**
   - Should see "github-pages" environment
   - Active deployment should show your site URL

---

## Common Issues & Solutions

### Issue 1: Actions tab is missing
**Solution:** Actions might be disabled for the organization
1. Go to organization settings: https://github.com/organizations/stackspheresolutions/settings/actions
2. Enable Actions for the organization
3. Enable for the repository

### Issue 2: "Workflow runs have been disabled"
**Solution:** 
1. Repository was flagged and Actions were disabled
2. Go to: https://github.com/stackspheresolutions/daily.stackmoments/settings/actions
3. Enable Actions as described above

### Issue 3: Workflow fails with permissions error
**Solution:**
1. Go to Settings > Actions > General
2. Under "Workflow permissions", select "Read and write permissions"
3. Save and re-run the workflow

### Issue 4: Pages not deploying
**Solution:**
1. Verify Pages source is set to "GitHub Actions"
2. Check if workflow completed successfully
3. Look for deployment in: https://github.com/stackspheresolutions/daily.stackmoments/deployments

### Issue 5: 404 error on GitHub Pages site
**Possible causes:**
- DNS not propagated yet (if using custom domain)
- Pages not enabled
- Workflow didn't complete successfully
- Repository is private (now resolved)

**Solution:**
1. Check workflow logs for errors
2. Verify baseURL in `config/_default/hugo.toml`
3. Wait for DNS propagation (15-30 minutes)

---

## Understanding the Workflow

Your `.github/workflows/hugo.yml` does:

1. **Triggers on:**
   - Push to `master` or `main` branch
   - Manual trigger (workflow_dispatch)

2. **Build job:**
   - Installs Hugo v0.147.9
   - Installs Dart Sass
   - Checks out code with submodules
   - Sets up GitHub Pages
   - Builds Hugo site with minification
   - Uploads build artifact

3. **Deploy job:**
   - Deploys to GitHub Pages
   - Makes site available at GitHub Pages URL

---

## URLs Reference

| Purpose | URL |
|---------|-----|
| Actions Dashboard | https://github.com/stackspheresolutions/daily.stackmoments/actions |
| Actions Settings | https://github.com/stackspheresolutions/daily.stackmoments/settings/actions |
| Pages Settings | https://github.com/stackspheresolutions/daily.stackmoments/settings/pages |
| Deployments | https://github.com/stackspheresolutions/daily.stackmoments/deployments |
| Current Site (GitHub) | https://stackspheresolutions.github.io/daily.stackmoments/ |
| Custom Domain (after DNS) | https://daily.stackmoments.com/ |

---

## Step-by-Step: Complete Setup

### Step 1: Enable Actions (2 minutes)
```
1. Visit: https://github.com/stackspheresolutions/daily.stackmoments/settings/actions
2. Set: "Allow all actions and reusable workflows"
3. Set: "Read and write permissions"
4. Click Save
```

### Step 2: Configure Pages (1 minute)
```
1. Visit: https://github.com/stackspheresolutions/daily.stackmoments/settings/pages
2. Source: "GitHub Actions"
3. Custom domain: "daily.stackmoments.com" (optional, after DNS setup)
4. Click Save
```

### Step 3: Trigger Deployment (1 minute)
```powershell
# From your local machine
git commit --allow-empty -m "Enable GitHub Actions and Pages"
git push origin master
```

### Step 4: Monitor (2-3 minutes)
```
1. Watch: https://github.com/stackspheresolutions/daily.stackmoments/actions
2. Wait for green checkmark
3. Visit your site!
```

---

## Testing Your Site

### Test GitHub Pages URL
```powershell
# Quick test
Start-Process "https://stackspheresolutions.github.io/daily.stackmoments/"
```

### Test Custom Domain (after DNS setup)
```powershell
# Check DNS first
nslookup -type=CNAME daily.stackmoments.com

# Test the site
Start-Process "https://daily.stackmoments.com/"
```

---

## Next Steps After Actions Are Working

1. ✅ **Verify deployment:** Site loads at GitHub Pages URL
2. ✅ **Add DNS records:** As per DNS-SETUP-GUIDE.md
3. ✅ **Configure custom domain:** In Pages settings
4. ✅ **Enable HTTPS:** After DNS propagation
5. ✅ **Test custom domain:** Site loads at daily.stackmoments.com

---

## Monitoring & Maintenance

### View Recent Deployments
```powershell
# See recent workflow runs (requires gh CLI authentication)
gh run list --limit 10

# View specific run details
gh run view <run-id>
```

### Manual Deployment Trigger
Useful when you want to redeploy without code changes:
```powershell
# Empty commit to trigger workflow
git commit --allow-empty -m "Redeploy site"
git push origin master
```

### Check Deployment Logs
If something goes wrong, check the workflow logs:
1. Go to Actions tab
2. Click on the failed run
3. Expand the failed step
4. Read error messages

---

## Support

- **GitHub Actions Docs:** https://docs.github.com/en/actions
- **GitHub Pages Docs:** https://docs.github.com/en/pages
- **Hugo Docs:** https://gohugo.io/hosting-and-deployment/hosting-on-github/

---

## Quick Command Reference

```powershell
# Build locally
hugo --minify

# Test locally
hugo server -D

# Trigger deployment
git commit --allow-empty -m "Deploy"
git push origin master

# Check DNS
nslookup -type=CNAME daily.stackmoments.com

# Open GitHub Pages
Start-Process "https://stackspheresolutions.github.io/daily.stackmoments/"
```

---

**Last Updated:** November 1, 2025
