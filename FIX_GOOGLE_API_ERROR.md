# Fix Google API Manager Error - SHA-1 Configuration

## Error Message:
```
E/GoogleApiManager: Failed to get service from broker.
E/GoogleApiManager: java.lang.SecurityException: Unknown calling package name 'com.google.android.gms'.
```

## Root Cause:
Your Android app's **SHA-1 fingerprint** is not registered in Firebase Console. Firebase Authentication requires this for security verification.

---

## ✅ SOLUTION - Option 1: Add SHA-1 Fingerprint (Recommended)

### Step 1: Get Your SHA-1 Fingerprint

Open **Command Prompt** and run:

```bash
keytool -list -v -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore -storepass android
```

**OR** if using Flutter directly:

```bash
cd android
gradlew signingReport
```

### Step 2: Copy the SHA-1 Fingerprint

Look for a line like this in the output:
```
SHA1: A1:B2:C3:D4:E5:F6:G7:H8:I9:J0:K1:L2:M3:N4:O5:P6:Q7:R8:S9:T0
```

**Copy the entire SHA-1 value** (the part after "SHA1: ")

### Step 3: Add SHA-1 to Firebase Console

1. Go to: https://console.firebase.google.com/
2. Select your project: **test1-472911**
3. Click the **⚙️ Settings** icon (gear icon) → **Project settings**
4. Scroll down to **"Your apps"** section
5. Find your Android app: `com.example.memo_gift`
6. Click **"Add fingerprint"**
7. Paste your SHA-1 fingerprint
8. Click **Save**

### Step 4: Download Updated google-services.json

1. In the same Firebase Console page
2. Click **"Download google-services.json"** button
3. Replace the file at: `android/app/google-services.json`

### Step 5: Clean and Rebuild

```bash
flutter clean
flutter pub get
flutter run
```

---

## ✅ SOLUTION - Option 2: Use Test Mode (Quick Fix for Development)

If you just want to test quickly, you can temporarily disable Firebase Authentication and use Firestore in test mode:

### Update Firestore Rules (Firebase Console):

1. Go to: https://console.firebase.google.com/
2. Select project: **test1-472911**
3. Go to **Firestore Database** → **Rules**
4. Replace with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;  // WARNING: Only for testing!
    }
  }
}
```

5. Click **Publish**

⚠️ **WARNING**: This allows anyone to read/write your database. Only use for testing!

### Temporarily Disable Authentication:

Update `lib/main.dart` - change line 46-50 to:

```dart
return Obx(() {
  // Temporarily bypass auth for testing
  return HomeScreen();
  
  // Original code (re-enable after fixing SHA-1):
  // if (authController.user.value != null) {
  //   return HomeScreen();
  // } else {
  //   return LoginScreen();
  // }
});
```

---

## ✅ SOLUTION - Option 3: Use Different Emulator

Sometimes the emulator's Google Play Services is outdated. Try:

1. **Create a new emulator** with Google Play Store support
2. **Update Google Play Services** in the emulator
3. Run the app again

---

## 🎯 Recommended Approach:

**Use Option 1** (SHA-1 configuration) - it's the proper fix and required for production anyway.

The other options are temporary workarounds for development only.

---

## 📝 Additional Notes:

- You need to add SHA-1 for both **debug** and **release** keystores
- For release builds, generate a separate SHA-1 from your release keystore
- Each developer on your team may need to add their own debug SHA-1
- Emulators and physical devices may have different SHA-1 fingerprints

---

## ❓ Still Not Working?

If you still get the error after adding SHA-1:

1. Make sure you downloaded the **updated** google-services.json
2. Run `flutter clean` and rebuild
3. Restart the emulator/device
4. Check that package name matches: `com.example.memo_gift`
5. Wait 5-10 minutes for Firebase to propagate changes
