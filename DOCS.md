# Stack Moments - Daily Documentation

## Project Structure

```
stack-moments-daily/
├── archetypes/          # Content templates
│   ├── article.md       # Article template
│   ├── brief.md         # Brief template
│   ├── topic.md         # Topic page template
│   └── default.md       # Default template
├── assets/
│   └── css/
│       └── extended/
│           └── custom.css # Custom styles
├── content/
│   ├── posts/           # Long-form articles
│   ├── briefs/          # Short news items
│   ├── topics/          # Topic pages
│   └── about.md         # About page
├── layouts/
│   ├── _default/        # Default layouts
│   ├── _markup/         # Render hooks
│   │   ├── render-image.html
│   │   └── render-link.html
│   └── partials/        # Partial templates
│       ├── giscus.html
│       └── head-meta.html
├── static/
│   └── images/          # Static images
├── config/
│   └── _default/
│       └── module.yaml  # Hugo modules config
├── .github/
│   └── workflows/
│       └── hugo.yml     # GitHub Actions
├── hugo.toml           # Main configuration
├── package.json        # Node.js dependencies
├── netlify.toml        # Netlify config
├── wrangler.toml       # Cloudflare Pages config
├── go.mod              # Go modules
├── install-theme.sh    # Theme installation script
├── .gitignore          # Git ignore rules
└── README.md           # Project documentation
```

## Content Types

### Articles (`content/posts/`)
- Long-form, in-depth content
- Stored as page bundles for image co-location
- Support for cover images, tags, categories
- Comments enabled by default

### Briefs (`content/briefs/`)
- Short news items and updates
- Single file format
- No comments by default
- Quick publication workflow

### Topics (`content/topics/`)
- Landing pages for specific topics
- Curated content collections
- No comments, focused on discovery

## Features Implemented

### Performance
- ✅ Hugo static site generation
- ✅ Image processing with WebP conversion
- ✅ Minification and optimization
- ✅ Fast loading with PaperMod theme

### Content Management
- ✅ Multiple content types with archetypes
- ✅ Taxonomies (tags, categories, series)
- ✅ Page bundles for co-located assets
- ✅ Rich front matter configuration

### User Experience
- ✅ Responsive design with dark/light theme
- ✅ Search functionality (Fuse.js)
- ✅ Table of contents
- ✅ Reading time estimation
- ✅ Post navigation
- ✅ Share buttons

### Technical Features
- ✅ Syntax highlighting with Chroma
- ✅ Code copy buttons
- ✅ Enhanced link handling
- ✅ Responsive images with render hooks
- ✅ SEO optimization (Open Graph, Twitter Cards)

### Comments & Engagement
- ✅ Giscus integration (GitHub-based)
- ✅ Configurable per post
- ✅ Modern discussion interface

### Deployment
- ✅ GitHub Actions workflow
- ✅ Cloudflare Pages configuration
- ✅ Netlify deployment ready
- ✅ Multiple hosting options

## Getting Started

### 1. Theme Installation
Run the theme installation script:
```bash
./install-theme.sh
```

### 2. Development Server
Start the local development server:
```bash
hugo server -D
```

### 3. Create Content
Use Hugo commands to create new content:
```bash
# New article
hugo new posts/my-article/index.md

# New brief
hugo new briefs/my-brief.md

# New topic
hugo new topics/my-topic.md
```

### 4. Configuration
Edit `hugo.toml` to customize:
- Site information
- Menu items
- Theme parameters
- Social links
- Comments settings

## Deployment Options

### GitHub Pages
1. Push to GitHub repository
2. Enable Pages in repository settings
3. GitHub Actions will automatically deploy

### Cloudflare Pages
1. Connect repository to Cloudflare Pages
2. Use build command: `hugo --minify`
3. Set output directory: `public`

### Netlify
1. Connect repository to Netlify
2. Netlify will auto-detect Hugo
3. Configuration in `netlify.toml`

## Customization

### Styling
- Edit `assets/css/extended/custom.css`
- Override theme variables
- Add custom components

### Layouts
- Create files in `layouts/` to override theme
- Use partial templates for reusable components
- Customize render hooks for enhanced Markdown

### Content
- Modify archetypes for different front matter
- Create custom taxonomies
- Add new content sections

## Best Practices

### Content Creation
1. Use descriptive titles and summaries
2. Add appropriate tags and categories
3. Include cover images when relevant
4. Write engaging meta descriptions

### SEO
1. Use descriptive URLs
2. Include alt text for images
3. Set canonical URLs when needed
4. Optimize images before uploading

### Performance
1. Use page bundles for image co-location
2. Optimize images (WebP conversion is automatic)
3. Keep build times fast with incremental builds
4. Monitor Core Web Vitals

## Support & Resources

### Hugo Documentation
- [Hugo Quick Start](https://gohugo.io/getting-started/quick-start/)
- [Content Management](https://gohugo.io/content-management/)
- [Theme Documentation](https://adityatelange.github.io/hugo-PaperMod/)

### Community
- [Hugo Discourse](https://discourse.gohugo.io/)
- [Hugo GitHub](https://github.com/gohugoio/hugo)
- [PaperMod Issues](https://github.com/adityatelange/hugo-PaperMod/issues)

---

Happy blogging with Stack Moments - Daily!
