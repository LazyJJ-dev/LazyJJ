import sharp from 'sharp';
import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __dirname = dirname(fileURLToPath(import.meta.url));
const publicDir = join(__dirname, '..', 'public');
const assetsDir = join(__dirname, '..', 'src', 'assets');

const pngPath = join(publicDir, 'og-image.png');
const logoPath = join(assetsDir, 'logo-light.svg');

// Colors from logo.svg
const colors = {
  darkBlue: '#1c2c54',
  darkerBlue: '#0f1a33',
  lightBlue: '#559bd1',
  grayBlue: '#9aaec5',
  offWhite: '#e5edec',
};

// Create the background SVG with text
const backgroundSvg = `<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="630" viewBox="0 0 1200 630">
  <defs>
    <linearGradient id="bg-gradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:${colors.darkBlue}"/>
      <stop offset="100%" style="stop-color:${colors.darkerBlue}"/>
    </linearGradient>
  </defs>

  <!-- Background -->
  <rect width="1200" height="630" fill="url(#bg-gradient)"/>

  <!-- Decorative elements -->
  <circle cx="100" cy="100" r="200" fill="${colors.lightBlue}" opacity="0.05"/>
  <circle cx="1100" cy="530" r="250" fill="${colors.grayBlue}" opacity="0.05"/>

  <!-- Title -->
  <text x="600" y="460" font-family="system-ui, -apple-system, sans-serif" font-size="72" font-weight="bold" fill="${colors.offWhite}" text-anchor="middle">LazyJJ</text>

  <!-- Tagline -->
  <text x="600" y="530" font-family="system-ui, -apple-system, sans-serif" font-size="32" fill="${colors.grayBlue}" text-anchor="middle">Ship stacked PRs without fighting your VCS</text>

  <!-- Bottom accent line -->
  <rect x="400" y="580" width="400" height="4" rx="2" fill="${colors.lightBlue}" opacity="0.7"/>
</svg>`;

// Read and resize the logo
const logoBuffer = readFileSync(logoPath);
const resizedLogo = await sharp(logoBuffer)
  .resize(280, 280)
  .png()
  .toBuffer();

// Create the background
const background = await sharp(Buffer.from(backgroundSvg))
  .png()
  .toBuffer();

// Composite the logo onto the background
await sharp(background)
  .composite([
    {
      input: resizedLogo,
      top: 90,
      left: 460,
    },
  ])
  .png()
  .toFile(pngPath);

console.log('Generated og-image.png');
