import 'package:colours/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_practice/functions/basic.dart';

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
                      loginUser(
                        context,
                        _email.text,
                        _password.text,
                      );
                    }
                  : null,
              child: Text(
                !loggingIn ? "Login" : "Logging In...",
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
          ],
        ),
      ),
    );
  }
}
