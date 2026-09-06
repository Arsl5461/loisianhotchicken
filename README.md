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
