# Sample Images

This directory contains placeholder information for images.
In a real deployment, you would add:

## Article Images
- `ai-development.webp` - AI and development illustration
- `js-frameworks.webp` - JavaScript frameworks comparison
- `cover.png` - Default site cover image

## Topic Images  
- `ai-topic.webp` - AI topic page header

## Best Practices for Images

### Formats
- Use WebP for best compression and quality
- PNG for graphics with transparency
- JPEG for photographs
- SVG for logos and icons

### Sizing
- Cover images: 1200x630px (optimal for social sharing)
- Article images: 800-1200px width
- Topic headers: 1200x400px

### Optimization
- Hugo automatically processes images through render hooks
- Generates responsive variants (400px, 800px, 1200px)
- Converts to WebP format
- Adds lazy loading and proper dimensions

### Organization
Store images with their content using page bundles:
```
content/posts/my-article/
├── index.md
├── featured-image.webp
└── diagram.png
```

This keeps images organized and enables Hugo's resource processing features.
