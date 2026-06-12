import sitemap from "@astrojs/sitemap"
import starlight from "@astrojs/starlight"
import tailwindcss from "@tailwindcss/vite"
import astroPwa from "@vite-pwa/astro"
import compress from "astro-compress"
import compressor from "astro-compressor"
import { defineConfig, fontProviders } from "astro/config"
import lucode from "lucode-starlight"
import checker from "vite-plugin-checker"
import svgr from "vite-plugin-svgr"

// Context
const { DEV: isDev } = import.meta.env

const site =
  process.env.COOLIFY_URL ||
  "https://registro-incidencias-videovigilancia-callao.martindotpy.dev"

export default defineConfig({
  site,
  trailingSlash: "never",

  integrations: [
    starlight({
      title: "Registro de Incidencias de Videovigilancia en el Callao",
      logo: {
        alt: "Logo",
        replacesTitle: true,
        dark: "./src/assets/svg/favicon-dark.svg",
        light: "./src/assets/svg/favicon-light.svg",
      },
      locales: {
        root: {
          label: "Español",
          lang: "es",
        },
      },
      social: [
        {
          icon: "github",
          label: "GitHub",
          href: "https://github.com/martindotpy/registro-de-indicencias-videovigilancia-callao",
        },
      ],
      sidebar: [
        {
          label: "ETL",
          items: [{ autogenerate: { directory: "etl" } }],
        },
      ],
      components: {
        Head: "./src/core/components/molecules/Head.astro",
      },
      customCss: ["./src/styles.css"],
      plugins: [
        lucode({
          footerText: "",
        }),
      ],
    }),
    sitemap({
      changefreq: "monthly",
      priority: 0.5,
      serialize(item) {
        if (item.url === `${site}/`) item.priority = 1

        return item
      },
      filter(page) {
        const pageUrl = new URL(page, site)

        if (pageUrl.pathname.endsWith("/_shell")) return false

        return true
      },
    }),
    astroPwa({
      base: "/",
      scope: "/",
      includeAssets: ["favicon.svg"],
      registerType: "autoUpdate",
      pwaAssets: {
        config: true,
      },
      manifest: {
        start_url: "/",
        name: "Registro de Incidencias de Videovigilancia en el Callao",
        short_name: "Registro de Incidencias",
        theme_color: "#0a0a0a",
        background_color: "#0a0a0a",
        display: "standalone",
      },
      workbox: {
        navigateFallback: "_shell",
        navigateFallbackDenylist: [/^\/api\//],
        globPatterns: [
          "**/*.{html,png,jpg,jpeg,svg,webp,avif,gif,ico,js,css,woff2,woff,ttf,otf}",
        ],
        globIgnores: [
          "**\\/node_modules\\/**\\/*",
          "\\/src\\/**\\/*",
          "**/index.png",
          "index.png",
          "sw.js",
          "workbox-*.js",
        ],
        runtimeCaching: [
          {
            urlPattern: ({ request }) => request.destination === "document",
            handler: "NetworkFirst",
            options: {
              cacheName: "offline-private-pages-cache",
              matchOptions: { ignoreVary: true, ignoreSearch: true },
              cacheableResponse: { statuses: [200] },
              expiration: { maxEntries: 50 },
            },
          },
          {
            urlPattern: ({ url, request }) =>
              url.pathname.startsWith("/api/") && request.method === "GET",
            handler: "NetworkFirst",
            options: {
              cacheName: "api-resources",
              cacheableResponse: { statuses: [0, 200] },
              expiration: {
                maxEntries: 100,
                maxAgeSeconds: 60 * 60 * 24 * 3,
              },
            },
          },
        ],
      },
      devOptions: {
        enabled: false,
        navigateFallbackAllowlist: [],
      },
    }),
    compress({
      CSS: false,
      Image: {
        sharp: {
          avif: false,
        },
      },
      Exclude: (file) => file.endsWith("favicon.svg"),
    }),
    compressor({ zstd: false }),
  ],
  vite: {
    plugins: [
      svgr(),
      ...(isDev
        ? [
            checker({
              typescript: true,
            }),
          ]
        : []),
      tailwindcss(),
    ],
  },
  fonts: [
    {
      provider: fontProviders.google(),
      name: "Geist",
      cssVariable: "--font-geist",
      subsets: ["latin"],
      weights: ["100 900"],
      styles: ["normal"],
    },
    {
      provider: fontProviders.google(),
      name: "Geist Mono",
      cssVariable: "--font-geist-mono",
      subsets: ["latin"],
      weights: ["100 900"],
      styles: ["normal"],
    },
  ],
  image: { layout: "constrained" },
})
