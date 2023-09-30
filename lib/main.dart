import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:two_sents/constants.dart';
import 'package:two_sents/views/screens/auth_screen.dart';
import 'package:two_sents/views/screens/verify_email.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/.env");

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: dotenv.env["API_KEY"]!,
            appId: dotenv.env["APP_ID"]!,
            messagingSenderId: dotenv.env["MESSAGING_SENDER_ID"]!,
            projectId: dotenv.env["PROJECT_ID"]!,
            authDomain: dotenv.env["AUTH_DOMAIN"]!,
            storageBucket: dotenv.env["STORAGE_BUCKET"]!));
  } else {
    await Firebase.initializeApp();
  }

  runApp(MaterialApp(
    title: "2 SENTS",
    theme: ThemeData().copyWith(
      useMaterial3: true,
      textTheme: GoogleFonts.latoTextTheme().copyWith(
        titleLarge: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 25),
        titleMedium:
            GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 18),
        titleSmall: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 12),
      ),
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 91, 108, 122),
          background: Colors.white,
          primaryContainer: Colors.white),
    ),
    debugShowCheckedModeBanner: false,
    home: StreamBuilder(
        stream: firebaseAuth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const VerifyEmail();
          } else {
            return const AuthScreen();
          }
        }),
  ));
}

