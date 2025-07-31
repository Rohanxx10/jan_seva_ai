# Jan Seva AI

A Flutter app designed to help villagers easily access government schemes using voice and simple UI.

---

## About

Java Seva AI is a user-friendly mobile application that provides information about government welfare schemes. It is specially designed for rural users with simple screens and voice interaction. Users can ask queries by voice or text, and the app reads out scheme details using text-to-speech.

The app works both online and offline by syncing scheme data for states and central government automatically. It keeps the offline database updated without user action, adding new schemes or removing deleted ones.

---

## Key Features

- **Voice-enabled interaction:** Ask scheme queries using speech and get spoken responses.
- **Text to Voice:** use listen what scheme given by app.
- **Simple and clean UI:** Minimal and easy-to-understand interface for all users.
- **Offline support:** Access state-wise and central schemes offline with automatic background sync.
- **Authentication:** Uses Firebase Authentication for secure user login.
- **Scheme Management:** Save favorite schemes, view recent queries, and browse state/central schemes.
- **Backend API:** Python Flask backend deployed to fetch user queries and serve scheme data.
- **Database:** Uses SQLite for offline storage and Firestore for syncing data.
- **Page slider:** Shows latest released schemes on the home screen.
- **Bottom navigation:** Easy navigation with a bottom bar featuring a notch for the mic button.

---

## Technologies Used

- Flutter (Dart) for frontend and UI
- Firebase Authentication and Firestore
- SQLite for local offline database
- Python with Flask for backend API
- Text-to-Speech (TTS) and Speech-to-Text libraries
- Riverpod for state management

---

## Getting Started

To run the app:

1. Clone this repo
2. Setup Firebase project and add your config files
3. Run `flutter pub get`
4. Use an emulator or real device and run `flutter run`

---

## Screenshots

*(Add screenshots here if available)*

---

## License

MIT License © Your Name

---

Made with ❤️ for rural India to empower access to government schemes easily.
