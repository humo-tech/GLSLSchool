import { defineConfig } from 'astro/config'

import vue from '@astrojs/vue'
import sitemap from '@astrojs/sitemap'

// https://astro.build/config
export default defineConfig({
  site: 'https://humo-tech.github.io/',
  base: '/GLSLSchool',
  integrations: [vue(), sitemap()],
})
