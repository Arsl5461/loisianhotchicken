# 💕 DatingProject

A modern, feature-rich dating application built with Flutter that connects people based on location, preferences, and shared interests.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)

## ✨ Features

### 🔐 Authentication & Onboarding

- **Phone Verification**: Secure phone number verification with OTP
- **Account Setup**: Comprehensive profile creation wizard
- **Terms & Guidelines**: User agreement and community guidelines
- **Social Login**: Multiple authentication methods

### 👤 Profile Management

- **Detailed Profiles**: Age, height, education, ethnicity, language preferences
- **Photo Management**: Multiple profile pictures with image picker
- **Location Services**: Address picker with Google Maps integration
- **Dating Preferences**: Customizable matching criteria
- **Profile Editing**: Easy profile updates and modifications

### 🗺️ Location & Travel Features

- **Location Picker**: Interactive map-based location selection
- **Travel Mode**: Explore and connect with people in different cities
- **Location Stories**: Share travel experiences and moments
- **City Exploration**: Discover new places and people
- **Location Permissions**: Smart permission handling

### 💬 Communication

- **Real-time Messaging**: Instant chat functionality
- **Contact Management**: Organized contact list
- **Match System**: Swipe-based matching interface
- **Story Sharing**: Visual content sharing

### ⚙️ Settings & Customization

- **Privacy Settings**: Granular privacy controls
- **Notification Management**: Customizable notification preferences
- **Premium Features**: Subscription plans and upgrades
- **Support System**: Help center and FAQ
- **Account Management**: Login methods and security settings

## 🛠️ Tech Stack

- **Framework**: Flutter 3.38.7+
- **Language**: Dart 3.10.7+
- **State Management**: GetX (`GetView`, `GetxController`, `Obx`)
- **Networking**: Dio via `NetworkManager`
- **Realtime**: Socket.IO
- **Auth / Config**: Firebase Auth, Remote Config, Secure Storage
- **Payments**: Stripe
- **Maps**: Google Maps Flutter
- **Testing**: `flutter_test` unit + widget tests with CI

## 🏗️ Architecture

Layered **feature-first** structure with GetX DI:

```
UI (view/) → Controller (controller/ / view/*/controllers/) → Repository (data/repositories/) → NetworkManager (core/dio_service/)
```

### Key layers

| Layer | Responsibility |
|-------|----------------|
| **Views** | Screens and widgets (`GetView`) |
| **Controllers** | State, user actions, navigation |
| **Repositories** | API calls, response parsing, domain results |
| **Services** | Session, socket, storage, Firebase, dialogs |
| **Core** | Routing, constants, typed exceptions, Dio |

### Repositories

- `AuthRepository`, `HomeRepository`, `ChatRepository`, `ProfileRepository`
- `TravelRepository`, `PaymentRepository`, `ReferralRepository`

### Quality tooling

- CI: `flutter analyze` + `flutter test`
- Typed API errors via `dio_exception_mapper.dart`
- Centralized logout via `SessionService` (401 + manual logout)
- `.env` for `API_BASE_URL`, Stripe keys

## 📱 Screenshots

_Add your app screenshots here_

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator / Android Emulator
- Google Maps API Key

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/datingproject.git
   cd datingproject
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Environment**

   ```bash
   cp .env.example .env
   ```

   Required keys: `API_BASE_URL`, `STRIPE_PUBLISHABLE_KEY`

4. **Configure API Keys**
   - Open `android/app/src/main/res/values/secrets.xml`
   - Replace `YOUR_API_KEY_HERE` with your actual Google Maps API key:
     ```xml
     <string name="google_maps_api_key">YOUR_ACTUAL_API_KEY</string>
     ```
   - Note: The `secrets.xml` file is gitignored for security

5. **Run tests**

   ```bash
   flutter analyze lib test
   flutter test
   ```

6. **Run the application**

   ```bash
   flutter run
   ```

### 🔑 API Configuration

#### Google Maps Setup

1. Get your API key from [Google Cloud Console](https://console.cloud.google.com/)
2. Enable the following APIs:
   - Maps SDK for Android
   - Maps SDK for iOS
   - Places API
   - Geocoding API
3. Add your API key to `android/app/src/main/res/values/secrets.xml`

#### iOS Configuration

Add your Google Maps API key to `ios/Runner/AppDelegate.swift`:

```swift
GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
```

## 📁 Project Structure

```
lib/
├── config/                 # App bootstrap, theme, env
├── core/                   # Routing, Dio, exceptions, constants
├── data/repositories/      # API repositories
├── controller/             # Shared controllers (home, likes)
├── services/               # Session, socket, storage, Firebase
├── models/                 # Data models
├── view/                   # Feature screens + widgets
│   ├── auth/
│   ├── HomeScreen/
│   ├── messages/
│   ├── profileSetting/
│   ├── Travel/
│   └── SplashScreen/
└── widgets/                # Shared UI components
test/
├── unit/                   # Repository, service, model tests
└── widget/                 # Widget tests
```

## 🎨 Design System

- **Color Scheme**: Gradient-based design with warm tones
- **Typography**: PublicSans font family for modern readability
- **Components**: Custom elevated buttons, text fields, and input components
- **Responsive**: MediaQuery-based responsive design
- **Icons**: Font Awesome and Lucide icon sets

## 🔒 Security Features

- **API Key Protection**: Secure configuration management
- **Location Privacy**: Granular location permission controls
- **Data Validation**: Input validation and sanitization
- **Secure Storage**: Proper credential management

## 📋 Permissions

The app requires the following permissions:

- **Location**: For finding nearby matches and location-based features
- **Camera**: For taking profile pictures
- **Photo Library**: For selecting existing photos
- **Phone**: For verification purposes

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- **Your Name** - _Initial work_ - [YourGitHub](https://github.com/yourusername)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Google Maps for location services
- Font Awesome for beautiful icons
- The open-source community for inspiration

## 📞 Support

If you have any questions or need help, please:

- Open an issue on GitHub
- Contact us through the app's support system
- Email: your-email@example.com

---

⭐ **Star this repository if you found it helpful!**

![GitHub stars](https://img.shields.io/github/stars/yourusername/datingproject?style=social)
![GitHub forks](https://img.shields.io/github/forks/yourusername/datingproject?style=social)
![GitHub issues](https://img.shields.io/github/issues/yourusername/datingproject)
![GitHub pull requests](https://img.shields.io/github/issues-pr/yourusername/datingproject)

flutter build ipa --release --export-options-plist=ios/ExportOptions.plist --verbose
