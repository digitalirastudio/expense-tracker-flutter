# Expense Tracker

A Flutter expense tracking app that helps users record, manage, and review their daily expenses.

## Features

* 🔐 User registration and login with Firebase Authentication
* 📧 Email verification and password reset
* 👤 User profile with display name and avatar
* 💰 Add and edit expenses
* 🗑️ Delete expenses
* 📅 Select expense date and time
* 📝 Add notes to expenses
* 🔎 Search transactions by category
* 🗂️ Filter transactions by date and category
* 📊 Dashboard with total expenses
* 📅 Monthly expense summary
* 📈 Category breakdown
* ☁️ Firebase Realtime Database for storing user data and expenses
* 🚪 Secure logout
* ❌ Delete account functionality

## Technologies Used

* Flutter
* Dart
* Firebase Authentication
* Firebase Realtime Database
* Android Studio
* Git & GitHub

## Project Structure

```text
lib/
├── models/
├── screens/
├── services/
├── widgets/
└── main.dart
```

## Getting Started

### Prerequisites

Make sure you have:

* Flutter SDK installed
* Dart SDK
* Android Studio or another Flutter-compatible IDE
* A Firebase project configured for the application

### Installation

Clone the repository:

```bash
git clone https://github.com/digitalirastudio/expense-tracker-flutter.git
```

Open the project:

```bash
cd expense-tracker-flutter
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

## Firebase

The application uses Firebase Authentication for user accounts and Firebase Realtime Database for storing user expenses.

Each user's expenses are stored under their authenticated Firebase user ID.

## Future Improvements

Possible future improvements include:

* Expense charts and visual analytics
* Custom expense categories
* Budget tracking
* Dark mode
* Export expenses
* Recurring expenses

## Author

**Ira Studio**

GitHub: [digitalirastudio](https://github.com/digitalirastudio)
