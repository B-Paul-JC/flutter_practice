import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../start/loading_view.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  static User user = FirebaseAuth.instance.currentUser!;
  static String? email = FirebaseAuth.instance.currentUser?.email;
  static bool verifying = false;

  StreamSubscription stream =
      Stream.periodic(const Duration(milliseconds: 500), (i) {
    user.reload();
    if (user.emailVerified) {
      return Stream.error("error");
    } else {
      return false;
    }
  }).listen((event) {
    if (event == false) {}
  });

  @override
  void dispose() {
    stream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Your Email"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: "Email: ",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: email,
                  style: const TextStyle(
                    fontSize: 22.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
              onPressed: !verifying
                  ? () {
                      FirebaseAuth.instance.currentUser
                          ?.sendEmailVerification();
                      setState(() {
                        verifying = true;
                      });
                    }
                  : null,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) {
                    if (verifying) {
                      return Theme.of(context).primaryColor.withOpacity(0.4);
                    }
                    return Theme.of(context).primaryColor;
                  },
                ),
              ),
              child: Text(!verifying ? "Verify Email" : "Verifying..."),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: verifying ? const CircularProgressIndicator() : null,
          ),
        ],
      ),
    );
  }
}
