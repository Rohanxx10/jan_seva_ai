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


![Screenshot_2025-07-31-12-15-06-72_ba17c719b52ff451fd4894c0ae671ff4](https://github.com/user-attachments/assets/73630218-767b-40f2-8ca0-7fcf7ca91801)
![Screenshot_2025-07-31-12-14-48-55_ba17c719b52ff451fd4894c0ae671ff4](https://github.com/user-attachments/assets/760c8e89-534a-4416-a627-e8c2438b3819)
![Screenshot_2025-07-31-12-14-31-03_ba17c719b52ff451fd4894c0ae671ff4](https://github.com/user-attachments/assets/495e3bf0-2fb9-4ef8-b195-89b9f4a008ec)
![Screenshot_2025-07-31-12-13-39-90_ab1359306de43320f9557c797b1c4be5](https://github.com/user-attachments/assets/78d3a259-21ad-4991-b0b8-2c74fbcc6b8c)
![Screenshot_2025-07-31-12-13-10-61_ba17c719b52ff451fd4894c0ae671ff4](https://github.com/user-attachments/assets/774d9e9a-e772-4de7-bb60-5127eacc988c)

---

## License


---

Made with ❤️ for rural India to empower access to government schemes easily.
