# Latest GitHub changes (last 28 days) — porting guide

**Source branch:** `origin/new_changes`  
**Key commit:** `b3cab4c` — *Add borrowing, categories, and auth flows*  
**Date:** 2026-11-07  
**Parent (before this feature commit):** `f84519e` (mobile rebrand) → `8eda395` (Flutter mobile app)

Also in the last ~28 days on GitHub:

| Commit   | Branch        | Summary |
|----------|---------------|---------|
| `e9dc72a` / `f358f89` … | `main` | Assorted “updated code” commits (already on `main`) |
| `8eda395` | `mobile` / `new_changes` | Add Flutter mobile admin app |
| `f84519e` | `mobile` / `new_changes` | Rebrand mobile app and configure API |
| `b3cab4c` | `new_changes` | **Borrowing, sale categories, auth email flows** ← latest feature set |

`main` and `new_changes` have **diverged** (`main` is 12 commits ahead in one direction; `new_changes` is 3 ahead in the other). Prefer cherry-pick / patch apply with conflict resolution rather than a hard merge.

---

## What `b3cab4c` adds (feature summary)

### 1. Borrowings (Money borrowed)
- New backend module: `backend/src/modules/borrowings/`
- New model: `Borrowing.js`
- Frontend page: `frontend/src/pages/Borrowings/MoneyBorrowed.tsx`
- API client: `frontend/src/api/borrowingsApi.ts`
- Sidebar / routes updated for borrowings

### 2. Sale categories + sale attachments
- New backend module: `backend/src/modules/saleCategories/`
- New model: `SaleCategory.js`
- Frontend page: `frontend/src/pages/Sales/SaleCategories.tsx`
- Sales create/edit updated for category + attachments
- `Sale` model / sales API / validation updated

### 3. Auth: email code login + password recovery
- Login flow extended (`Login.tsx`, `auth.controller.js`, `auth.service.js`, routes, validation)
- Forgot password page: `frontend/src/pages/Auth/ForgotPassword.tsx`
- Mailer utility: `backend/src/utils/mailer.js`
- User model fields for verification / reset codes
- New env vars in `backend/.env.example` (SMTP / mail settings)

### 4. Expenses: split payments
- Expense model / validation / service support multiple payment splits
- Migration: `backfillExpensePayments.js`
- Frontend expenses UI updated

### 5. Timezone-aware business dates
- `backend/src/utils/dateHelper.js` expanded
- Migration: `normalizeBusinessDates.js`
- Frontend: `frontend/src/constants/timezone.ts`
- Reports / dashboard / statement PDF adjusted

### 6. Supporting updates
- Reports & tender types tweaks
- Settings page updates
- Storage / token helpers
- README notes

**Stats:** 73 files, ~+3496 / −315 lines

---

## How to apply the same changes on your next branch

### Option A — Cherry-pick (recommended if histories are close)

```bash
git fetch origin
git checkout YOUR_NEXT_BRANCH
git cherry-pick b3cab4c
# resolve conflicts if any, then:
# git add .
# git cherry-pick --continue
```

### Option B — Apply the patch file in this folder

Patch file:

`docs/porting/0001-Add-borrowing-categories-and-auth-flows.patch`

```bash
git checkout YOUR_NEXT_BRANCH
git apply --check docs/porting/0001-Add-borrowing-categories-and-auth-flows.patch
git apply docs/porting/0001-Add-borrowing-categories-and-auth-flows.patch
# or, to create a commit from the patch:
git am docs/porting/0001-Add-borrowing-categories-and-auth-flows.patch
```

If `git apply` fails due to drift from `main`, use:

```bash
git apply --3way docs/porting/0001-Add-borrowing-categories-and-auth-flows.patch
```

### Option C — Bring the whole `new_changes` tip onto a new branch

```bash
git checkout -b YOUR_NEXT_BRANCH origin/new_changes
# or merge/rebase new_changes into your target branch
```

---

## Env / setup after applying

1. Copy any new keys from `backend/.env.example` into `backend/.env` (especially mail/SMTP for email-code login & forgot password).
2. Restart API: `cd backend && npm install && npm start`
3. Run seed if needed: `npm run seed`
4. Frontend: `cd frontend && npm install && npm run dev`

---

## Full file list (commit `b3cab4c`)

### Added
- `backend/src/database/migrations/backfillExpensePayments.js`
- `backend/src/database/migrations/normalizeBusinessDates.js`
- `backend/src/database/models/Borrowing.js`
- `backend/src/database/models/SaleCategory.js`
- `backend/src/modules/borrowings/*` (controller, repository, routes, service, validation)
- `backend/src/modules/saleCategories/*` (controller, repository, routes, service, validation)
- `backend/src/utils/mailer.js`
- `frontend/src/api/borrowingsApi.ts`
- `frontend/src/constants/timezone.ts`
- `frontend/src/pages/Auth/ForgotPassword.tsx`
- `frontend/src/pages/Borrowings/MoneyBorrowed.tsx`
- `frontend/src/pages/Sales/SaleCategories.tsx`

### Modified (high level)
- Auth: `auth.controller.js`, `auth.service.js`, `auth.routes.js`, `auth.repository.js`, `auth.validation.js`, `Login.tsx`, `authApi.ts`
- Expenses / sales / reports / dashboard / stores / orders / payment methods
- Models: `Expense.js`, `Sale.js`, `User.js`, `models/index.js`
- App wiring: `app.js`, `server.js`, `environment.js`, `.env.example`
- Frontend: Sidebar, Navbar, AppRoutes, Expenses, Sales, Reports, Settings, statement PDF

---

## Mobile parity (implemented on `new_changes`)

The Flutter app now mirrors the website features from `b3cab4c` where applicable:

- OTP login + forgot/reset password + settings change-password (super admin)
- Sale categories CRUD + sales create with category, date, attachment
- Expenses with split payments
- Money borrowed (create / repay / delete) + reports owed banner
- America/Chicago business-date helpers for forms and report defaults
- Drawer / More nav updated to match web sidebar

## Note about older mobile commits

Mobile Flutter work (`8eda395`, `f84519e`) is on `origin/mobile` and also included under `origin/new_changes`.
