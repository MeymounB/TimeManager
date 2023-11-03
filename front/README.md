# Front Starter

## Link Front to API

Create a ``.env`` file in the root /front folder.
Add the following line :

```bash
NUXT_PUBLIC_BACK_URL= *your_api_url*
```

(Ask your BackEnd dev for the ``*your_api_key*`` 🤪)

Then head to the ``nuxt.config.ts``
And scroll to this section of the file :

```bash
runtimeConfig: {
    public: {
      BACK_URL: "NUXT_PUBLIC_BACK_URL",
    },
  },
```

Paste ``NUXT_PUBLIC_BACK_URL`` next to the ``BACK_URL:`` variable

## Nuxt 3 Minimal Starter

Look at the [Nuxt 3 documentation](https://nuxt.com/docs/getting-started/introduction) to learn more.

### Setup

Make sure to install the dependencies:

```bash
# npm
npm install

# pnpm
pnpm install

# yarn
yarn install

# bun
bun install
```

### Development Server

Start the development server on `http://localhost:3000`:

```bash
# npm
npm run dev

# pnpm
pnpm run dev

# yarn
yarn dev

# bun
bun run dev
```

### Production

Build the application for production:

```bash
# npm
npm run build

# pnpm
pnpm run build

# yarn
yarn build

# bun
bun run build
```

Locally preview production build:

```bash
# npm
npm run preview

# pnpm
pnpm run preview

# yarn
yarn preview

# bun
bun run preview
```

Check out the [deployment documentation](https://nuxt.com/docs/getting-started/deployment) for more information.
