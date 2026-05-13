# cms-fe

🌐 Public-facing portfolio frontend for Heru Oktafian.

Built with **Ruby on Rails**, **Hotwire (Turbo)**, and **Tailwind CSS**. This repository fetches content from the [`cms-be`](https://github.com/heru-oktafian/cms-be) backend API and renders it as a single-page portfolio experience with smooth navigation.

---

## 🚀 Stack

- **Ruby on Rails** (view layer + asset pipeline)
- **Hotwire / Turbo** (`@hotwired/turbo-rails`) — page transitions & AJAX
- **Tailwind CSS** — utility-first styling
- **esbuild** — JavaScript bundling
- **`cms-be`** — backend API (Go + Fiber + PostgreSQL)

---

## 📌 Features

- **Dynamic section navigation** — clicking navbar items fetches only that section's data from the API, without a full page reload
- **Smooth anchor scrolling** — browser native scroll with background fetch
- **Static fallback content** — rendered if the backend is unavailable
- **Responsive design** — mobile-first with Tailwind CSS
- **Single-page layout** — no full page reloads for section navigation

---

## 🔗 API Integration

The frontend communicates with `cms-be` for all dynamic content. All API endpoints live under:

```text
/api/v1/public/
```

### Available section endpoints

| Section | Endpoint |
|---------|----------|
| Skills | `/api/v1/public/skills` |
| Tools | `/api/v1/public/tools` |
| Projects | `/api/v1/public/projects` |
| Experiences | `/api/v1/public/experiences` |
| Social Links | `/api/v1/public/social-links` |
| Profile | `/api/v1/public/profile` |
| Full Portfolio | `/api/v1/public/portfolio` |

The frontend hits `/sections/{section}` internally (Rails controller → fetches from API → returns HTML partial).

---

## 🗂️ Project Structure

```text
cms-fe/
├── app/
│   ├── assets/builds/          # compiled JS & CSS (esbuild output)
│   ├── controllers/            # Rails controllers
│   │   └── pages_controller.rb # handles static pages + section refresh
│   ├── javascript/
│   │   ├── application.js      # entry point — imports Turbo, controllers
│   │   ├── section_refresh.js # navbar click → fetch & update section
│   │   └── mobile_nav.js       # mobile navigation toggle
│   ├── services/
│   │   └── cms_api_client.rb   # thin HTTP client for cms-be API
│   └── views/
│       ├── layouts/           # application layout
│       └── pages/             # page templates + section partials
├── config/
│   ├── routes.rb              # page routes + /sections/:section
│   └── .env.example
├── public/                    # static assets
├── package.json               # esbuild config
├── Procfile.dev               # development process types
└── bin/dev                    # starts Rails + esbuild watch + Tailwind
```

---

## ⚙️ Environment Variables

Copy the example file and adjust values:

```bash
cp .env.example .env
```

Key variables:

```env
CMS_BE_BASE_URL=http://127.0.0.1:8080
RAILS_HOST=127.0.0.1
RAILS_PORT=3000
```

> **Note:** The frontend is designed to be served from the same host as the backend in production (e.g., behind a reverse proxy or same domain). CORS is not enabled by default.

---

## ▶️ Running Locally

Make sure the backend (`cms-be`) is running first. Then:

```bash
# Install dependencies
bundle install
yarn install

# Start dev server (Rails + esbuild watch + Tailwind CSS)
./bin/dev
```

The app should be available at:

```text
http://127.0.0.1:3000
```

---

## 🏗️ Production Build

```bash
yarn build        # compile JS via esbuild
yarn build:css    # compile Tailwind CSS
rails assets:precompile
```

Or with `foreman`:

```bash
foreman start -f Procfile
```

---

## 🔒 License

Private project for internal development.