# Assets Approval Mobile Application

## Overview
The Assets Approval Mobile Application is designed to streamline the process of approving and managing assets within an organization. This application provides a user-friendly interface for users to log in, view assets, and manage approval requests.

## Features
- **User Authentication**: Secure login form for users to access the application.
- **Dashboard**: Overview of assets and their approval statuses.
- **Approval Management**: List and manage approval requests for assets.
- **Settings**: User account settings for managing personal information.

## Project Structure
```
assets_approval_app
├── android
├── ios
├── lib
│   ├── main.dart
│   └── src
│       ├── app.dart
│       ├── core
│       │   ├── constants.dart
│       │   ├── theme.dart
│       │   └── utils.dart
│       ├── models
│       │   ├── asset.dart
│       │   ├── approval.dart
│       │   └── user.dart
│       ├── data
│       │   └── mock_data.dart
│       ├── services
│       │   ├── auth_service.dart
│       │   └── asset_service.dart
│       ├── providers
│       │   ├── auth_provider.dart
│       │   └── approval_provider.dart
│       ├── routes
│       │   └── app_router.dart
│       ├── screens
│       │   ├── login_screen.dart
│       │   ├── dashboard_screen.dart
│       │   ├── approvals_screen.dart
│       │   └── settings_screen.dart
│       └── widgets
│           ├── login_form.dart
│           ├── approval_card.dart
│           └── bottom_nav_bar.dart
├── test
│   └── widget_test.dart
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

## Getting Started
1. **Clone the repository**:
   ```
   git clone <repository-url>
   cd assets_approval_app
   ```

2. **Install dependencies**:
   ```
   flutter pub get
   ```

3. **Run the application**:
   ```
   flutter run
   ```

## Technologies Used
- Flutter: For building the mobile application.
- Dart: Programming language used for Flutter development.

## Contributing
Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## License
This project is licensed under the MIT License - see the LICENSE file for details.