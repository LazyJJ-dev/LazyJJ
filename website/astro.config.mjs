// @ts-check
import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";

// https://astro.build/config
export default defineConfig({
  site: "https://lazyjj.dev",
  integrations: [
    starlight({
      title: "LazyJJ",
      description:
        "Ship stacked PRs faster with LazyJJ - a ready-to-use Jujutsu configuration with GitHub integration and Claude Code support",
      head: [
        {
          tag: "meta",
          attrs: {
            property: "og:image",
            content: "https://lazyjj.dev/og-image.png",
          },
        },
        {
          tag: "meta",
          attrs: {
            name: "twitter:card",
            content: "summary_large_image",
          },
        },
        {
          tag: "meta",
          attrs: {
            name: "twitter:image",
            content: "https://lazyjj.dev/og-image.png",
          },
        },
        {
          tag: "script",
          attrs: {
            type: "application/ld+json",
          },
          content: JSON.stringify({
            "@context": "https://schema.org",
            "@type": "SoftwareApplication",
            name: "LazyJJ",
            description:
              "A ready-to-use Jujutsu configuration for stacked PR workflows with GitHub integration and Claude Code support",
            applicationCategory: "DeveloperApplication",
            operatingSystem: "macOS, Linux",
            offers: {
              "@type": "Offer",
              price: "0",
              priceCurrency: "USD",
            },
            url: "https://lazyjj.dev",
            author: {
              "@type": "Person",
              name: "Ernesto Jiménez",
              url: "https://github.com/ernesto-jimenez",
            },
          }),
        },
      ],
      social: {
        github: "https://github.com/lazyjj-dev/lazyjj",
        blueSky: "https://bsky.app/profile/ernesto-jimenez.com",
      },
      components: {
        Footer: './src/components/Footer.astro',
      },
      sidebar: [
        {
          label: "Getting Started",
          items: [
            { label: "Introduction", slug: "introduction" },
            { label: "Installation", slug: "installation" },
            { label: "Quick Start", slug: "quickstart" },
          ],
        },
        {
          label: "Guides",
          items: [
            { label: "Understanding JJ's Mental Model", slug: "guides/mental-model" },
            { label: "The Operation Log", slug: "guides/operation-log" },
            { label: "Git → JJ Quick Reference", slug: "guides/git-differences" },
            { label: "LazyJJ vs Graphite", slug: "guides/from-graphite" },
            { label: "Common Mistakes", slug: "guides/common-mistakes" },
          ],
        },
        {
          label: "Tutorials",
          items: [
            { label: "Create a Stack", slug: "tutorials/create-stack" },
            { label: "Navigate Your Stack", slug: "tutorials/navigate-stack" },
            { label: "Edit Mid-Stack Commits", slug: "tutorials/edit-mid-stack" },
            { label: "Working with Conflicts", slug: "tutorials/resolve-conflicts" },
            { label: "Create a Pull Request", slug: "tutorials/create-pr" },
            { label: "Sync with Remote", slug: "tutorials/sync-remote" },
          ],
        },
        {
          label: "Reference",
          items: [
            { label: "Aliases", slug: "reference/aliases" },
            { label: "Advanced Revsets", slug: "reference/revsets-advanced" },
            { label: "Stack Workflow", slug: "reference/stack" },
          ],
        },
        {
          label: "Integrations",
          items: [
            { label: "GitHub", slug: "integrations/github" },
            { label: "Claude", slug: "integrations/claude" },
          ],
        },
      ],
      customCss: ["./src/styles/custom.css"],
    }),
  ],
});
