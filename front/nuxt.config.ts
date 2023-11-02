// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  app: {
    head: {
      title: "TimeManager - PAR5",
    },
  },

  modules: ["@nuxt/devtools", "@vueuse/nuxt", "@pinia/nuxt", '@nuxtjs/svg-sprite'],

  devtools: { enabled: true },
  ssr: false,

  css: ["@/assets/scss/main.scss"],

  postcss: {
    plugins: {
      "postcss-import": {},
      "tailwindcss/nesting": {},
      tailwindcss: {},
      autoprefixer: {},
    },
  },

  typescript: {
    strict: true,
    shim: false,
  },

  runtimeConfig: {
    public: {
      BACK_URL: "",
    },
  },
});
