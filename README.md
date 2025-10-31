# Stack Moments - Daily

A modern Hugo-powered news blog focused on technology, programming, and software development insights.  

## 🌐 Live Site
- **GitHub Pages**: https://stackspheresolutions.github.io/daily.stackmoments/
- **Custom Domain**: Ready for daily.stackmoments.com setup

## 🚀 Features

- **Fast and Responsive**: Built with Hugo for lightning-fast load times
- **Modern Design**: Beautiful Blowfish theme with ocean color scheme
- **Rich Content Types**: Support for articles, news briefs, and topic pages
- **Enhanced Images**: Responsive image processing with WebP support
- **Automatic Deployment**: GitHub Actions workflow for seamless updates
- **Code Highlighting**: Syntax highlighting with copy buttons
- **Search Functionality**: Built-in search powered by Fuse.js
- **Comments System**: Giscus integration for GitHub-based discussions
- **SEO Optimized**: Open Graph, Twitter Cards, and structured data
- **Mobile Friendly**: Responsive design with dark/light theme toggle
- **Fresh Content**: Daily AI and technology news coverage

## Quick Start

### Prerequisites
- [Hugo Extended](https://gohugo.io/getting-started/installing/) (v0.110.0 or later)
- Git

### Installation

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd stack-moments-daily
   ```

2. Add the PaperMod theme:
   ```bash
   git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
   git submodule update --init --recursive
   ```

3. Start the development server:
   ```bash
   hugo server -D
   ```

4. Visit `http://localhost:1313` to view your site.

### Creating Content

#### New Article
```bash
hugo new posts/my-article/index.md
```

#### New Brief
```bash
hugo new briefs/my-brief.md
```

#### New Topic Page
```bash
hugo new topics/my-topic.md
```

## Configuration

### Site Settings
Edit `hugo.toml` to customize:
- Site title and description
- Author information
- Social media links
- Menu items
- Theme parameters

### Comments (Giscus)
To enable comments:
1. Set up a GitHub repository for discussions
2. Configure Giscus at https://giscus.app/
3. Update the `[params.giscus]` section in `hugo.toml`

### Analytics
Add your Google Analytics ID in the `hugo.toml` file:
```toml
googleAnalytics = "G-XXXXXXXXXX"
```

## Content Structure

```
content/
├── posts/          # Long-form articles
├── briefs/         # Short news items
├── topics/         # Topic landing pages
└── about.md        # About page
```

## Deployment

### Cloudflare Pages
1. Connect your GitHub repository to Cloudflare Pages
2. Use these build settings:
   - Build command: `hugo --minify`
   - Build output directory: `public`
   - Environment variables: `HUGO_VERSION=0.120.0`

### Netlify
1. Connect your repository to Netlify
2. Use these build settings:
   - Build command: `hugo --minify`
   - Publish directory: `public`

### GitHub Pages
Add `.github/workflows/hugo.yml` for GitHub Actions deployment.

## Content Guidelines

### Front Matter
Each content type has specific front matter requirements. Use the provided archetypes as templates.

### Images
- Store images in page bundles (`posts/my-post/index.md` + images)
- Use descriptive alt text
- Add captions when helpful
- Images will be automatically optimized and converted to WebP

### Code Blocks
Use proper syntax highlighting:
\`\`\`javascript
console.log("Hello, World!");
\`\`\`

## Theme Customization

The site uses the PaperMod theme with custom configurations. To further customize:
1. Override layouts in the `layouts/` directory
2. Add custom CSS in `assets/css/extended/`
3. Modify theme parameters in `hugo.toml`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Support

For questions or issues, please create an issue in the GitHub repository.

# Full site deployment
hugo --minify
aws s3 sync ./public/ s3://daily.stackmoments --delete

# Or use your deployment script
.\deploy.ps1
