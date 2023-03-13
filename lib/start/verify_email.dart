import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../functions/basic.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  static String? email = FirebaseAuth.instance.currentUser?.email;
  static bool verifying = false;

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
                      setState(() {
                        verifying = true;
                      });
                      verifyEmail(context).then(
                        (value) => setState(() {
                          verifying = false;
                        }),
                      );
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
