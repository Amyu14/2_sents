import 'dart:async';
import 'package:flutter/material.dart';
import 'package:two_sents/constants.dart';
import 'package:two_sents/views/screens/home_screen.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  Timer? timer;
  bool canResendEmail = false;

  @override
  void initState() {
    super.initState();
    isEmailVerified = firebaseAuth.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(const Duration(seconds: 3), (_) {
        checkEmailVerified();
      });
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = firebaseAuth.currentUser!;
      await user.sendEmailVerification();
      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future checkEmailVerified() async {
    await firebaseAuth.currentUser!.reload();
    setState(() {
      isEmailVerified = firebaseAuth.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      timer!.cancel();
    }
  }

  @override
  void dispose() {
    if (timer != null) timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? const HomeScreen()
        : Scaffold(
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                      "A verification email has been sent to the address you provided."),
                  const SizedBox(
                    width: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: canResendEmail ? sendVerificationEmail : null,
                        icon: const Icon(Icons.email),
                        label: const Text("RESEND EMAIL"),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          firebaseAuth.signOut();
                        },
                        icon: const Icon(Icons.email),
                        label: const Text("CANCEL"),
                      ),
                    ],
                  )
                ],
            )
          );
  }
}
