#!/usr/bin/env node
import { promises as fs } from 'node:fs';
import path from 'node:path';
import favicons from 'favicons';

const root = process.cwd();
const inputArg = process.argv[2];
const srcPath = inputArg ? path.resolve(root, inputArg) : path.resolve(root, 'assets', 'images', 'logo.png');
const outDir = path.resolve(root, 'static');

async function ensureOutDir(dir) {
  await fs.mkdir(dir, { recursive: true });
}

async function writeFiles(response, dir) {
  for (const image of response.images) {
    await fs.writeFile(path.join(dir, image.name), image.contents);
  }
  for (const file of response.files) {
    await fs.writeFile(path.join(dir, file.name), file.contents);
  }
}

async function main() {
  try {
    await ensureOutDir(outDir);
    const configuration = {
      path: '/',
      appName: 'Stack Moments - Daily',
      appShortName: 'StackMoments',
      appDescription: 'Daily Intelligence for Developers',
      developerName: 'Stack Moments',
      background: '#ffffff',
      theme_color: '#0ea5e9',
      display: 'standalone',
      icons: {
        android: true,
        appleIcon: true,
        appleStartup: false,
        favicons: true,
        windows: true,
        yandex: false,
        coast: false,
        firefox: false
      }
    };

    const { images, files, html } = await favicons(srcPath, configuration);
    await writeFiles({ images, files }, outDir);

    // Write a minimal webmanifest if not generated
    const manifestPath = path.join(outDir, 'site.webmanifest');
    try {
      await fs.access(manifestPath);
    } catch {
      const manifest = {
        name: 'Stack Moments - Daily',
        short_name: 'StackMoments',
        start_url: '/',
        display: 'standalone',
        background_color: '#ffffff',
        theme_color: '#0ea5e9',
        icons: images
          .filter(i => i.name.endsWith('.png'))
          .map(i => ({ src: `/${i.name}`, sizes: `${i.width}x${i.height}`, type: 'image/png' }))
      };
      await fs.writeFile(manifestPath, JSON.stringify(manifest, null, 2));
    }

    // Write optional HTML snippet for reference
    const snippet = html.join('\n');
    await fs.writeFile(path.join(outDir, 'favicons-snippet.html'), snippet);

    console.log('Favicons generated in', outDir);
  } catch (err) {
    console.error('Failed to generate favicons:', err.message);
    process.exit(1);
  }
}

main();
