import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'controllers/auth_provider.dart';
import 'controllers/memo_provider.dart';
import 'views/auth/login_screen.dart';
import 'views/home/home_screen.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized successfully');
  } catch (e) {
    debugPrint('❌ Firebase Error: $e');
    // Don't run the app if Firebase fails to initialize
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Firebase Initialization Failed',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Error: $e',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return;
  }

  runApp(const MemoGiftApp());
}

class MemoGiftApp extends StatelessWidget {
  const MemoGiftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, MemoProvider>(
          create: (_) => MemoProvider(),
          update: (_, auth, memo) => memo!..updateUser(auth.user?.uid),
        ),
      ],
      child: MaterialApp(
        title: 'MemoGift',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const RootWrapper(),
      ),
    );
  }
}

class RootWrapper extends StatelessWidget {
  const RootWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.user != null) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
