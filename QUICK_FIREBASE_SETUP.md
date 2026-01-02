# 🚀 Quick Firebase Setup

## Step 1: Run FlutterFire Configure

Open your terminal in the project directory and run:

```powershell
flutterfire configure
```

**Follow the prompts:**
1. Select or create a Firebase project
2. Select platforms (at minimum: Android)
3. Wait for configuration to complete

This will generate `lib/firebase_options.dart`

## Step 2: Update main.dart

After `firebase_options.dart` is generated, update `lib/main.dart`:

**Change this:**
```dart
await Firebase.initializeApp();
```

**To this:**
```dart
import 'firebase_options.dart'; // Add this import at the top

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

## Step 3: Enable Authentication in Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Click **Authentication** → **Get started**
4. Go to **Sign-in method** tab
5. Enable **Email/Password**
6. Click **Save**

## Step 4: Enable Firestore

1. In Firebase Console, click **Firestore Database**
2. Click **Create database**
3. Select **Start in test mode**
4. Choose a location
5. Click **Enable**

## Step 5: Run the App

```powershell
flutter run
```

## ✅ You're Done!

Now you can:
- Register new users
- Login with email/password
- User data is stored in Firestore

---

## 📱 Test the App

1. **Register**: Create a new account with name, email, password
2. **Check Firestore**: Go to Firebase Console → Firestore → users collection
3. **Login**: Use the registered credentials to login

---

## 🔧 If You Encounter Issues

### "No Firebase App has been created"
- Make sure you ran `flutterfire configure`
- Check that `firebase_options.dart` is imported in `main.dart`

### Build Errors
- Update `android/app/build.gradle`:
  - `minSdkVersion 21` (or higher)
  - `compileSdkVersion 34` (or higher)

---

**Need more details? Check `FIREBASE_SETUP_GUIDE.md`**
