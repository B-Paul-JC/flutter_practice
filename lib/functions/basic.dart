import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/screens/error_screen.dart';
import 'package:rive/rive.dart';

import '../screens/success_screen.dart';

//? Routes
const initialScreenRoute = "/initial-screen";
const homeRoute = "/home";
const verifyEmailRoute = "/verify-email";
const loginRoute = "/login";
const registerRoute = "/register";

//? Images
const splineImage = "assets/images/Spline.png";

void pushPage(
  BuildContext context, {
  required String next,
}) {
  Future.delayed(
    const Duration(milliseconds: 5000),
    () {
      if (next.isNotEmpty) {
        Navigator.of(context).pushNamed(
          next,
        );
      }
    },
  );
}

Future<void> verifyEmail(BuildContext context) async {
  await FirebaseAuth.instance.currentUser
      ?.sendEmailVerification()
      .then((value) {
    showInfoDialog(
      context: context,
      code: "verification-sent",
      error: false,
    );
  }).catchError((e) {
    showInfoDialog(
      context: context,
      code: "verification-email-error",
      error: true,
    );
  });
}

void Function() signOut(BuildContext context) {
  NavigatorState ctxN = Navigator.of(context);
  return () async {
    await askConfirmation(
      context,
      title: "Logout?",
      content: "Do you really want to logout?",
      onReject: ctxN.pop,
      onAccept: () async {
        await FirebaseAuth.instance.signOut();
        ctxN.pushReplacementNamed(initialScreenRoute);
        Future.delayed(const Duration(milliseconds: 100), () {
          showInfoDialog(
            code: "logged-out",
            context: context,
            error: false,
          );
        });
      },
    );
  };
}

Future<void> showInfoDialog({
  required BuildContext context,
  required String code,
  required bool error,
}) async {
  String? text = codeInterpretations[code];
  return (await showDialog(
    context: context,
    builder: (context) =>
        error ? ErrorScreen(text ?? "") : SuccessScreen(text ?? ""),
  ));
}

Future<void> loginUser(
    BuildContext context, String email, String password) async {
  NavigatorState ctxN = Navigator.of(context);
  bool loginSuccessful = false;
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    loginSuccessful = true;
  } on FirebaseAuthException catch (e) {
    showInfoDialog(
      context: context,
      code: e.code,
      error: true,
    );
  }
  if (loginSuccessful) {
    ctxN.pop();
    Future.delayed(
      const Duration(milliseconds: 100),
      () => showInfoDialog(
        context: context,
        code: "logged-in",
        error: false,
      ),
    );
  }
}

Future<void> registerUser(
  BuildContext context,
  RegistrationCredential credential,
) async {
  NavigatorState ctxN = Navigator.of(context);

  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: credential.email,
      password: credential.password,
    );
  } on FirebaseAuthException catch (e) {
    showInfoDialog(
      context: context,
      code: e.code,
      error: true,
    );
  } finally {
    ctxN.pop();
    Future.delayed(const Duration(milliseconds: 100), () {
      showInfoDialog(
        code: "newly-registered",
        context: context,
        error: false,
      );
    });
  }
}

class RegistrationCredential {
  final String email;
  final String password;

  const RegistrationCredential({
    required this.email,
    required this.password,
  });
}

class RiveCheck extends StatefulWidget {
  final LoaderState loader;

  const RiveCheck({super.key, required this.loader});

  @override
  State<RiveCheck> createState() => _RiveCheckState();
}

class _RiveCheckState extends State<RiveCheck> {
  late final SMITrigger error;
  late final SMITrigger success;

  void riveInit(Artboard artboard, LoaderState isOkay, {int? delay = 1000}) {
    StateMachineController? controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
    );

    artboard.addController(controller!);

    setState(() {
      error = controller.findInput<bool>('Error') as SMITrigger;
      success = controller.findInput<bool>('Check') as SMITrigger;
    });

    Future.delayed(
      Duration(milliseconds: delay!),
      () {
        if (isOkay == LoaderState.loaded) {
          success.fire();
        } else if (isOkay == LoaderState.loadingError) {
          error.fire();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      "assets/RiveAssets/check.riv",
      onInit: (Artboard artboard) => riveInit(
        artboard,
        widget.loader,
        delay: 100,
      ),
    );
  }
}

enum LoaderState {
  loading,
  loaded,
  loadingError,
}

Future<bool> askConfirmation(
  BuildContext context, {
  required String title,
  required String content,
  required void Function() onReject,
  required void Function() onAccept,
}) async {
  return (await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 6,
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
            content: Text(
              content,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: onReject,
                child: const Text(
                  'No',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: onAccept,
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      )) ??
      false;
}

Map<String, String> codeInterpretations = {
  "": "",
  "weak-password":
      "Sorry the password entered is too weak, please increase it's strength to prevent future regrets.",
  "wrong-password":
      "Uh-oh!, it seems youve forgotten your password, kindly request a change or try another login method.",
  "user-not-found":
      "Uhm, it seems you're actually new to this service, we don't have a user with this email / number.",
  "email-already-in-use":
      "It seems there's an imposter here.\nDid you mean to login?, We already have a user with this email.",
  "invalid-email":
      "The given email is invalid. Kindly visit google.com,yahoo.com or any mailing service to create a valid email, Thank you.",
  "user-disabled":
      "Sorry, this user account has been disabled for now, Contact support and try agin later!",
  "invalid-code":
      "I assume there's a typo in your code, crosscheck and give it another go!\n\nOr just, you know, request a new one.",
  "unknown":
      "You seem to have inputted empty or unrecognized chararcters, Kindly enter actual values and try again!",
  "network-request-failed":
      "You forgot to connect to the internet!, Kindly connect and give it another try!",
  "logged-out": "Great!, You have been logged out successfully!",
  "logged-in": "Login Successful, enjoy your stay!",
  "verification-sent":
      "A verification email has been sent to ${FirebaseAuth.instance.currentUser?.email}, kindly follow the link, verify your email and come back.",
  "verification-email-error":
      "Uh-oh, it seems we're unable to send a verification email at this time, kindly be patient or contact support!",
  "newly-registered": "Welcome to RexTem, hope you have a great time with us!!",
};
