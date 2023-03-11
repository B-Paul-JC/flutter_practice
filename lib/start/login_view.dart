import 'package:colours/colours.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    super.key,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  static bool loggingIn = false;
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
        title: const Text("Login"),
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: Colours.sandyBrown,
        ),
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
            ElevatedButton(
              onPressed: !loggingIn
                  ? () async {
                      NavigatorState ctxN = Navigator.of(context);
                      final email = _email.text;
                      final password = _password.text;
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        ctxN.pop();
                      } on FirebaseAuthException catch (e) {
                        if (e.code != "unknown") {
                          setState(() {
                            loggingIn = false;
                            errorText =
                                e.code.replaceAll(r'-', " ").toUpperCase();
                          });
                        } else {
                          setState(() {
                            loggingIn = false;
                            errorText =
                                "It seems you've provided invalid credentials, such as empty text.";
                          });
                        }
                      }
                    }
                  : null,
              child: Text(
                !loggingIn ? "Login" : "Logging",
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: loggingIn ? const CircularProgressIndicator() : null,
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
