# DNS Configuration Guide for daily.stackmoments.com

## Overview
This guide will help you configure DNS records to point your custom domain `daily.stackmoments.com` to GitHub Pages.

---

## Step 1: Identify Your DNS Provider

First, determine where your domain `stackmoments.com` is registered and where DNS is managed. Common providers:
- **GoDaddy**
- **Namecheap**
- **Cloudflare**
- **Google Domains**
- **AWS Route 53**
- **Other registrar**

---

## Step 2: Configure DNS Records

You have **TWO options** for setting up your custom domain:

### Option A: Using CNAME Record (Recommended for Subdomain)

Since `daily.stackmoments.com` is a subdomain, this is the **recommended** approach.

#### Add this DNS Record:

| Type  | Name/Host | Value/Target | TTL |
|-------|-----------|--------------|-----|
| CNAME | daily | stackspheresolutions.github.io | 3600 (or Auto) |

**Example configurations by provider:**

#### **Cloudflare:**
```
Type: CNAME
Name: daily
Target: stackspheresolutions.github.io
Proxy status: DNS only (gray cloud) - initially, then you can enable proxy
TTL: Auto
```

#### **GoDaddy:**
```
Type: CNAME
Host: daily
Points to: stackspheresolutions.github.io
TTL: 1 Hour
```

#### **Namecheap:**
```
Type: CNAME Record
Host: daily
Value: stackspheresolutions.github.io
TTL: Automatic
```

#### **AWS Route 53:**
```
Record name: daily
Record type: CNAME
Value: stackspheresolutions.github.io
TTL: 300
Routing policy: Simple routing
```

---

### Option B: Using A Records (Alternative)

If you want to use A records instead, add ALL four of these:

| Type | Name/Host | Value/Target | TTL |
|------|-----------|--------------|-----|
| A | daily | 185.199.108.153 | 3600 |
| A | daily | 185.199.109.153 | 3600 |
| A | daily | 185.199.110.153 | 3600 |
| A | daily | 185.199.111.153 | 3600 |

⚠️ **Note:** CNAME is simpler and recommended for subdomains.

---

## Step 3: Configure GitHub Pages

After adding the DNS records:

1. **Go to GitHub Repository Settings:**
   ```
   https://github.com/stackspheresolutions/daily.stackmoments/settings/pages
   ```

2. **Under "Custom domain":**
   - Enter: `daily.stackmoments.com`
   - Click **Save**

3. **Wait for DNS check:**
   - GitHub will verify your DNS configuration
   - This can take a few minutes to several hours

4. **Enable HTTPS:**
   - Once DNS is verified, check the box: **"Enforce HTTPS"**
   - Wait a few minutes for SSL certificate provisioning

---

## Step 4: Update Hugo Configuration

The configuration has been updated automatically, but verify:

**File:** `config/_default/hugo.toml`
```toml
baseURL = "https://daily.stackmoments.com/"
```

**File:** `static/CNAME`
```
daily.stackmoments.com
```

✅ These files have been created/updated for you.

---

## Step 5: Deploy Changes

Run these commands to deploy:

```powershell
# Build and verify
hugo --minify

# Commit changes
git add .
git commit -m "Configure custom domain daily.stackmoments.com"
git push origin master
```

Or use the provided script:
```powershell
.\switch-to-custom-domain.ps1
```

---

## Verification Steps

### 1. Check DNS Propagation
Use these tools to verify your DNS records:
- https://dnschecker.org/#CNAME/daily.stackmoments.com
- https://www.whatsmydns.net/#CNAME/daily.stackmoments.com

### 2. Test DNS Resolution (PowerShell)
```powershell
# Check CNAME record
nslookup -type=CNAME daily.stackmoments.com

# Or use Resolve-DnsName
Resolve-DnsName daily.stackmoments.com -Type CNAME
```

Expected output:
```
daily.stackmoments.com canonical name = stackspheresolutions.github.io
```

### 3. Verify GitHub Pages Status
Go to: https://github.com/stackspheresolutions/daily.stackmoments/settings/pages

You should see:
- ✅ **Custom domain:** daily.stackmoments.com
- ✅ **DNS check successful**
- ✅ **HTTPS** (after certificate provisioning)

### 4. Test Your Site
After DNS propagation (5 minutes to 48 hours):
- http://daily.stackmoments.com (should redirect to HTTPS)
- https://daily.stackmoments.com

---

## Troubleshooting

### DNS Not Propagating
- **Wait:** DNS can take 5 minutes to 48 hours to propagate
- **Clear cache:** Try incognito/private browser mode
- **Check TTL:** Lower TTL values propagate faster

### GitHub Pages Not Working
- **Verify DNS:** Ensure CNAME points to `stackspheresolutions.github.io`
- **Check Settings:** Verify custom domain is saved in GitHub Pages settings
- **Repository visibility:** Must be public (which you've already done)
- **CNAME file:** Must exist in `static/CNAME` directory

### SSL Certificate Issues
- **Wait:** SSL certificates can take 24-48 hours to provision
- **Don't check too frequently:** Excessive checks can delay provisioning
- **Try later:** Come back after a few hours

### "Domain is taken" Error
- This means another GitHub repository is using this domain
- Ensure no other repo has this domain configured
- Check your organization's other repositories

### CAA Record Issues (Advanced)
If using CAA records on your domain, ensure they allow Let's Encrypt:
```
0 issue "letsencrypt.org"
0 issue "pki.goog"
```

---

## Quick Reference: DNS Provider-Specific Guides

### Cloudflare
1. Log in to Cloudflare dashboard
2. Select your domain: `stackmoments.com`
3. Go to **DNS** section
4. Click **Add record**
5. Select **CNAME**
6. Name: `daily`
7. Target: `stackspheresolutions.github.io`
8. Proxy status: **DNS only** (gray cloud)
9. Save

### GoDaddy
1. Log in to GoDaddy account
2. Go to **My Products** → **DNS**
3. Find `stackmoments.com` → click **DNS**
4. Click **Add** under Records
5. Type: **CNAME**
6. Host: `daily`
7. Points to: `stackspheresolutions.github.io`
8. TTL: **1 Hour**
9. Save

### Namecheap
1. Log in to Namecheap account
2. Click **Domain List** → Manage
3. Select **Advanced DNS**
4. Click **Add New Record**
5. Type: **CNAME Record**
6. Host: `daily`
7. Value: `stackspheresolutions.github.io`
8. TTL: **Automatic**
9. Save

### AWS Route 53
1. Open Route 53 console
2. Go to **Hosted Zones**
3. Select `stackmoments.com`
4. Click **Create record**
5. Record name: `daily`
6. Record type: **CNAME**
7. Value: `stackspheresolutions.github.io`
8. TTL: **300**
9. Create records

---

## Timeline

| Step | Time Required |
|------|---------------|
| DNS record creation | 1-5 minutes |
| DNS propagation | 5 minutes - 48 hours (typically 15-30 minutes) |
| GitHub DNS verification | 1-10 minutes after propagation |
| SSL certificate provisioning | 5 minutes - 48 hours |

---

## Support Resources

- **GitHub Pages Documentation:** https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site
- **Hugo Documentation:** https://gohugo.io/hosting-and-deployment/hosting-on-github/
- **DNS Checker:** https://dnschecker.org/

---

## Next Steps After DNS Configuration

1. ✅ Add DNS records at your provider
2. ✅ Configure custom domain in GitHub Pages settings
3. ✅ Wait for DNS propagation
4. ✅ Enable HTTPS
5. ✅ Update Hugo baseURL (already done)
6. ✅ Deploy changes (run commands above)
7. ✅ Test your site

---

**Need help?** Check the GitHub Pages documentation or open an issue in your repository.
