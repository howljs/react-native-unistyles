# Unistyles documentation (v3)

Static Astro + Starlight site for [unistyl.es](https://unistyl.es).

## Local development

```bash
# from monorepo root
bun install
bun run --cwd apps/docs dev
```

```bash
bun run --cwd apps/docs build   # output: apps/docs/dist
bun run --cwd apps/docs preview
```

## Redirects

Legacy Unistyles 2.0 paths (`/start/*`, `/reference/*`, `/other/*`, `/examples/*`) redirect to [v2.unistyl.es](https://v2.unistyl.es).

- **Production (Cloudflare Pages):** `public/_redirects` → real HTTP 301s
- **Astro config:** `redirects` in `astro.config.mjs` → HTML meta-refresh for local preview

## Cloudflare Pages (v3)

Deployed by [`.github/workflows/docs.yml`](../../.github/workflows/docs.yml) via Wrangler direct upload.

| Setting | Value |
|---------|--------|
| Project name | `unistyles-docs` |
| Production branch | `main` |
| Build | `bun install --frozen-lockfile && bun run --cwd apps/docs build` |
| Output | `apps/docs/dist` |
| Custom domains | `unistyl.es`, `www.unistyl.es` |

### Required GitHub secrets

| Secret | Where to get it |
|--------|-----------------|
| `CLOUDFLARE_API_TOKEN` | [API Tokens](https://dash.cloudflare.com/profile/api-tokens) → Create Token → **Edit Cloudflare Workers** template (needs Pages:Edit) |
| `CLOUDFLARE_ACCOUNT_ID` | Workers & Pages overview → Account ID (right sidebar) |

Create the Pages project once (if it does not exist yet):

```bash
npx wrangler@latest pages project create unistyles-docs --production-branch main
```

Manual deploy (same as CI):

```bash
bun run --cwd apps/docs build
npx wrangler@latest pages deploy apps/docs/dist \
  --project-name unistyles-docs \
  --branch main
```

## Cloudflare Pages (v2 archive)

Frozen docs for Unistyles 2.0 live on branch `docs/v2` (pre-monorepo layout under `docs/`).

| Setting | Value |
|---------|--------|
| Project name | `unistyles-docs-v2` |
| Production branch | `docs/v2` |
| Root directory | `docs` |
| Build command | `npm install --workspaces=false && npm run build` |
| Build output directory | `dist` |
| Node.js version | `20` |
| Custom domain | `v2.unistyl.es` |

Treat `docs/v2` as archival — do not merge main into it.
