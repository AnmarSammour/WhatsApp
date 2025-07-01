# WhatsApp Clone - Flutter & Firebase

## Introduction

**WhatsApp Clone** is a fully functional mobile messaging application built with **Flutter** and **Firebase**. This project replicates core WhatsApp features including real-time messaging, user authentication, contact management, and status updates. The application follows clean architecture principles with **Cubit** for state management and provides a responsive UI that works seamlessly on both iOS and Android platforms.

### Key Technologies
- **Flutter**: Frontend framework for building native cross-platform apps
- **Firebase**: Backend services (Authentication, Firestore, Storage)
- **Cubit**: Lightweight state management solution
- **Bloc Library**: For managing application state and events

## Features

### Core Functionality
- 🔒 Phone number authentication with OTP verification
- ✉️ Real-time text messaging with read receipts
- 👥 Contact management and synchronization
- 📸 Image sharing in chats
- 📱 Status updates (text/image) with 24-hour expiration
- 👤 User profile management (name, profile photo)

### Technical Highlights
- 🚀 Optimized performance with lazy loading for messages
- 🌐 Internet connectivity detection
- 🔄 Background message synchronization
- 🎨 Responsive UI that adapts to different screen sizes
- 🔧 Custom audio recorder implementation

## Dependencies

The project uses these key dependencies in `pubspec.yaml`:

```yaml
dependencies:
  flutter_bloc: ^8.1.3
  firebase_core: ^2.24.0
  firebase_auth: ^4.11.1
  cloud_firestore: ^4.9.1
  firebase_storage: ^11.5.1
  image_picker: ^1.0.4
  cached_network_image: ^3.3.0
  intl: ^0.18.1
  flutter_contacts: ^1.1.6
  permission_handler: ^10.4.4
  uuid: ^3.0.7
  flutter_sound: ^9.2.13
  path_provider: ^2.1.1
  connectivity_plus: ^4.0.2
```

## Installation

Follow these steps to set up the project:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/AnmarSammour/WhatsApp.git
   cd WhatsApp
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Set up Firebase**:
   - Create a Firebase project at [firebase.google.com](https://firebase.google.com/)
   - Add Android and iOS apps to your Firebase project
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place these files in the appropriate directories:
     - Android: `android/app/google-services.json`
     - iOS: `ios/Runner/GoogleService-Info.plist`

4. **Enable Firebase services**:
   - Enable Phone Authentication in Firebase Console
   - Set up Firestore Database with these rules:
     ```rules
     rules_version = '2';
     service cloud.firestore {
       match /databases/{database}/documents {
         match /{document=**} {
           allow read, write: if request.auth != null;
         }
       }
     }
     ```
   - Set up Firebase Storage with similar rules

5. **Run the application**:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── controller/
│   └── cubit/
│       ├── chat_cubit.dart      # Manages chat operations
│       ├── contact_cubit.dart   # Handles contact management
│       ├── home_cubit.dart      # Controls home screen state
│       ├── login_cubit.dart     # Manages authentication flow
│       ├── message_cubit.dart   # Handles message operations
│       ├── profile_cubit.dart   # Manages user profiles
│       ├── register_cubit.dart  # Handles user registration
│       └── status_cubit.dart    # Manages status updates
│
├── enum/
│   └── message_enum.dart        # Defines message types (text, image, audio)
│
├── model/
│   ├── call_model.dart          # Call data model
│   ├── contact_model.dart       # Contact data model
│   ├── message_model.dart       # Message data model
│   ├── status_model.dart        # Status data model
│   └── user_model.dart          # User data model
│
└── view/
    ├── chat_screen/             # Chat interface
    │   ├── chat_screen.dart
    │   └── widgets/             # Reusable chat components
    │       ├── chat_list.dart
    │       ├── message_reply_preview.dart
    │       └── sender_message_card.dart
    │
    ├── contact_screen/          # Contact management
    │   └── contact_screen.dart
    │
    ├── home_screen/             # Main navigation screen
    │   ├── home_screen.dart
    │   └── widgets/             # Home screen components
    │       ├── bottom_chat_field.dart
    │       ├── contacts_list.dart
    │       └── sender_message_card.dart
    │
    ├── landing_screen/          # Initial screen
    │   └── landing_screen.dart
    │
    ├── login_screen/            # Login flow
    │   └── login_screen.dart
    │
    ├── otp_screen/              # OTP verification
    │   └── otp_screen.dart
    │
    ├── profile_screen/          # User profile
    │   └── profile_screen.dart
    │
    ├── register_screen/         # User registration
    │   └── register_screen.dart
    │
    ├── status_screen/           # Status viewing
    │   └── status_screen.dart
    │
    └── user_information_screen/ # User setup
        └── user_information_screen.dart
│
├── app_routes.dart              # Application navigation routes
├── firebase_options.dart        # Firebase configuration
└── main.dart                    # Application entry point
```

## Key Features Implementation

### Real-time Messaging
```dart
// In message_cubit.dart
Stream<List<Message>> getMessages(String receiverId) {
  return _firestore
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('chats')
      .doc(receiverId)
      .collection('messages')
      .orderBy('timeSent')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => Message.fromMap(doc.data()))
        .toList();
  });
}
```

### OTP Authentication
```dart
// In login_cubit.dart
Future<void> verifyPhoneNumber(String phoneNumber) async {
  await _auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
    },
    verificationFailed: (FirebaseAuthException e) {
      // Handle error
    },
    codeSent: (String verificationId, int? resendToken) {
      emit(CodeSentState(verificationId));
    },
    codeAutoRetrievalTimeout: (String verificationId) {},
  );
}
```

### Status Expiration
```dart
// In status_cubit.dart
Future<void> uploadStatus(File statusFile, String caption) async {
  final statusUrl = await _storage.uploadFile(statusFile, false);
  final status = Status(
    uid: user.uid,
    username: user.name,
    phoneNumber: user.phoneNumber,
    statusUrl: statusUrl,
    caption: caption,
    createdAt: DateTime.now(),
    profilePic: user.profilePic,
    statusId: const Uuid().v4(),
  );
  
  // Status will auto-delete after 24 hours
  await _firestore
      .collection('status')
      .doc(status.statusId)
      .set(status.toMap())
      .then((value) {
    _setupExpiryTimer(status.statusId);
  });
}

void _setupExpiryTimer(String statusId) {
  Timer(const Duration(hours: 24), () {
    _firestore.collection('status').doc(statusId).delete();
  });
}
```
