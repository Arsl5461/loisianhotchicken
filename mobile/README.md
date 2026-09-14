# Louisiana Hot Chicken Admin — Mobile

Flutter admin app for iOS and Android. Same core features as the web admin, using the existing `/api/v1` backend.

## Run

Start the backend first. This repo’s local API currently listens on port **5050**.

```bash
cd mobile
flutter pub get
flutter run
```

Override the API origin when needed:

```bash
# iOS Simulator
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:5050/api/v1

# Android emulator
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5050/api/v1

# Physical device on the same Wi-Fi (use your Mac’s LAN IP)
flutter run --dart-define=API_BASE_URL=http://192.168.x.x:5050/api/v1
```

Default Super Admin:

- Email: `admin@louisianahotchicken.com`
- Password: `ChangeMeNow!123`

## Architecture

Clean Architecture + Riverpod:

`presentation → use case → repository → Dio API client`

Tokens are stored in secure storage. The selected store is sent as `X-Store-Id`.
