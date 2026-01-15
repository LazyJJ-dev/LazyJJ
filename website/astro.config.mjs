// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
  site: 'https://lazyjj-dev.github.io',
  base: '/lazyjj',
  integrations: [
    starlight({
      title: 'LazyJJ',
      description: 'A ready-to-use Jujutsu distribution with sensible defaults and modern workflows',
      social: {
        github: 'https://github.com/lazyjj-dev/lazyjj',
      },
      sidebar: [
        {
          label: 'Getting Started',
          items: [
            { label: 'Introduction', slug: 'introduction' },
            { label: 'Installation', slug: 'installation' },
            { label: 'Quick Start', slug: 'quickstart' },
          ],
        },
        {
          label: 'Reference',
          items: [
            { label: 'Aliases', slug: 'reference/aliases' },
            { label: 'Revsets', slug: 'reference/revsets' },
            { label: 'Stack Workflow', slug: 'reference/stack' },
          ],
        },
        {
          label: 'Integrations',
          items: [
            { label: 'GitHub', slug: 'integrations/github' },
            { label: 'Claude', slug: 'integrations/claude' },
          ],
        },
      ],
      customCss: ['./src/styles/custom.css'],
    }),
  ],
});
