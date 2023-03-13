import 'package:colours/colours.dart';
import 'package:flutter/material.dart';

import '../functions/basic.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  static bool registering = false;
  final FocusNode _focusNodeOne = FocusNode();
  final FocusNode _focusNodeTwo = FocusNode();
  late final TextEditingController _email;
  late final TextEditingController _password;

  static String errorText = "";

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _focusNodeOne.dispose();
    _focusNodeTwo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller: _email,
              autocorrect: false,
              focusNode: _focusNodeOne,
              onTapOutside: (e) => _focusNodeOne.unfocus(),
              enableSuggestions: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "Enter your email here",
              ),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              focusNode: _focusNodeTwo,
              onTapOutside: (e) => _focusNodeTwo.unfocus(),
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: "Enter your password here",
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: !registering
                  ? () async {
                      setState(() {
                        registering = true;
                      });
                      registerUser(
                        context,
                        RegistrationCredential(
                          email: _email.text,
                          password: _password.text,
                        ),
                      ).then(
                        (value) => setState(() {
                          registering = false;
                        }),
                      );
                    }
                  : null,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) {
                    if (registering) {
                      return Theme.of(context).primaryColor.withOpacity(0.4);
                    }
                    return Theme.of(context).primaryColor;
                  },
                ),
              ),
              child: Text(
                !registering ? "Register" : "Registering...",
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: registering ? const CircularProgressIndicator() : null,
            ),
            Text(
              errorText,
              style: const TextStyle(color: Colours.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
