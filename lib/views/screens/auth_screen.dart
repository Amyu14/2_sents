import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:two_sents/constants.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLogin = false;

  FocusNode node = FocusNode();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  BoxDecoration containerDecoration(BuildContext context) {
    return BoxDecoration(
        gradient: LinearGradient(colors: [
      Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7),
      Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.9),
    ], begin: Alignment.topLeft, end: Alignment.bottomRight));
  }

  void submitData(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (isLogin) {
        try {
          await firebaseAuth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a valid email address and password!")));
        }

      } else {

        try {
          await firebaseAuth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text).then((value) {
            firestore.collection("users").doc(firebaseAuth.currentUser!.uid).set({
            "username": usernameController.text,
            "emailAddress" : emailController.text
          }); 
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
          return;
        }


      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: containerDecoration(context),
      child: Center(
        child: Card(
          elevation: 2,
          shadowColor: Theme.of(context).colorScheme.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            width: 500,
            padding: const EdgeInsets.fromLTRB(12,12,12,18),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "2  S E N T S",
                          style: GoogleFonts.antonio(
                              fontWeight: FontWeight.w100,
                              fontSize: 50),
                        )
                      ],
                    ),
                    if (!isLogin)
                      const SizedBox(
                        height: 10,
                      ),
                    
                    if (!isLogin)
                      TextFormField(
                        key: const ValueKey(0),
                        controller: usernameController,
                        validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a username!";
                        }
                        return null;
                      },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Username",
                            hintStyle: Theme.of(context).textTheme.bodyMedium),
                      ),
                    const SizedBox(
                      height: 10,
                    ),


                    TextFormField(
                      key: const ValueKey(1),
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email address!";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: "Email",
                          hintStyle: Theme.of(context).textTheme.bodyMedium),
                    ),
                    const SizedBox(
                      height: 10,
                    ),


                    TextFormField(
                      key: const ValueKey(2),
                      controller: passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password!";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Password",
                          hintStyle: Theme.of(context).textTheme.bodyMedium),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () => submitData(context),
                            child: Text(isLogin ? "Log In" : "Sign Up"))),

                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            isLogin
                                ? "Dont' have an account?"
                                : "Already have an account?",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontSize: 16)),
                        InkWell(
                          onTap: () {
                            setState(() {
                              emailController.clear();
                              passwordController.clear();
                              usernameController.clear();
                              isLogin = !isLogin;
                              node.unfocus();
                            });
                          },
                          child: Text(
                            isLogin ? " Sign Up." : " Log In.",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}