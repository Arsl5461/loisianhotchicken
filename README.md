# Louisiana Hot Chicken Admin

Multi-store restaurant management platform for Louisiana Hot Chicken.

## Stack

- Frontend: React, Vite, TypeScript, Redux Toolkit, Tailwind CSS, Recharts
- Backend: Node.js, Express, MongoDB, Mongoose, JWT, Zod

## Quick start

1. Install and run MongoDB locally on `mongodb://127.0.0.1:27017`.
2. Backend

```bash
cd backend
cp .env.example .env
npm install
npm run seed
npm run dev
```

3. Frontend

```bash
cd frontend
npm install
npm run dev
```

Default Super Admin:

- Email: `admin@louisianahotchicken.com`
- Password: `ChangeMeNow!123`

API: `http://localhost:5000/api/v1`  
App (dev): `http://localhost:5173`

## Serve the frontend from the API

```bash
cd frontend
npm run build
cd ../backend
npm run start
```

The built app is then available at `http://localhost:5000`. API routes stay under `/api/v1`.

On a server, do **not** run `npm run dev` under PM2. That uses `node --watch` and restarts the process with SIGINT in a loop, so the browser never gets a stable site.

```bash
cd frontend
# Leave VITE_BACKEND_URL empty when the API serves the UI (same origin).
# Or set it to the public API origin, e.g. https://your-domain.com
npm run build

cd ../backend
pm2 delete app
pm2 start ecosystem.config.cjs
pm2 save
```

Confirm logs show `listening on http://0.0.0.0:5000` and that `/health` stays up. Then open `http://YOUR_SERVER_IP:5000`.
