import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rent_app/app_providers.dart';
import 'package:rent_app/constants/constants.dart';
import 'package:rent_app/constants/routes.dart';
import 'package:rent_app/features/auth/screens/login_screen.dart';
import 'package:rent_app/features/auth/screens/signin_screen.dart';
import 'package:rent_app/features/home/screens/tabcontroller.dart';
import 'package:rent_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(AppProviders());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rent App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.lightScaffoldColor,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.lightTextColor),
        ),
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.lightScaffoldColor,
          foregroundColor: AppColors.lightTextColor,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: AppColors.darkScaffold,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.darkTextColor),
        ),
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkScaffold,
          foregroundColor: AppColors.darkTextColor,
          elevation: 0,
        ),
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => AuthGate(),
        RouteNames.login: (context) => LoginScreen(),
        RouteNames.signup: (context) => SignInScreen(),
        RouteNames.home: (context) => Tabcontroller()
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return const Tabcontroller();
        }

        return const LoginScreen();
      },
    );
  }
}
 