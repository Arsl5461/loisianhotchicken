# Referral Reward Claim API

## Overview

Referral reward claim now upgrades the user to a paid-access referral subscription.

## Endpoint

```
POST /api/referrals/me/rewards/:rewardId/claim
```

## Request

**Headers:**

```json
{
  "Authorization": "Bearer <token>"
}
```

**Body:** No body required

## Success Response (200)

```json
{
  "success": true,
  "message": "Reward claimed successfully",
  "data": {
    "reward": {
      "_id": "reward_id",
      "status": "claimed",
      "rewardType": "free_subscription_upgrade",
      "claimedAt": "2026-04-19T12:00:00.000Z",
      "claimContext": {
        "appliedSubscriptionTier": "referral",
        "durationDays": 30,
        "appliedFrom": "2026-04-19T12:00:00.000Z",
        "appliedUntil": "2026-05-19T12:00:00.000Z"
      }
    },
    "subscription": {
      "tier": "referral",
      "expiresAt": "2026-05-19T12:00:00.000Z",
      "autoRenew": false,
      "amount": 0,
      "paymentDate": "2026-04-19T12:00:00.000Z"
    }
  }
}
```

## Frontend Implementation

### What to treat as Paid Access

**Paid tiers** (unlock all paid-only features):

- `standard`
- `premium`
- `referral` ✨ NEW

**Free tier** (limited access):

- `free`

### Referral Subscription Display

When tier is `"referral"`:

- ✅ Treat as active paid membership
- Show `amount = 0` (no charge)
- Show `paymentDate` = claim time
- Show `autoRenew = false`

### Subscription Object Shape

Expect this structure from all subscription endpoints:

```typescript
{
  "tier": "standard" | "premium" | "referral" | "free",
  "expiresAt": "ISO date string or null",
  "autoRenew": boolean,
  "amount": number,
  "paymentDate": "ISO date string or null"
}
```

## Key Changes for Frontend

| Aspect        | Before                | After                                            |
| ------------- | --------------------- | ------------------------------------------------ |
| Paid tiers    | `standard`, `premium` | `standard`, `premium`, `referral`                |
| Referral tier | N/A                   | Unlocks paid features, amount=0, autoRenew=false |
| Free tier     | `free`                | `free` (unchanged)                               |

---

**Questions?** Check with backend team for clarifications.
