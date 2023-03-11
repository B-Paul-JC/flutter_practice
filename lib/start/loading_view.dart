import 'package:colours/colours.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../functions/basic.dart';

enum Loader {
  loading,
  loaded,
  loadingError,
}

class LoadingView extends StatefulWidget {
  final Loader loaded;
  final String? next;

  const LoadingView({
    super.key,
    required this.loaded,
    this.next,
  });

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  late SMITrigger error;
  late SMITrigger success;
  late SMITrigger reset;
  static late Widget child;

  @override
  Widget build(BuildContext context) {
    child = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 150,
        ),
        Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
            ),
            child: Image.asset(
              "assets/images/Spline.png",
            ),
          ),
        ),
        const SizedBox(
          height: 150,
        ),
        Text(() {
          if (widget.loaded == Loader.loadingError) {
            return "Loading Failed! Please re-install the app or contact support";
          }
          return "";
        }()),
        const SizedBox(
          height: 50,
        ),
        SizedBox(
          width: 80,
          height: 80,
          child: RiveAnimation.asset(
            "assets/RiveAssets/check.riv",
            onInit: (Artboard artboard) {
              StateMachineController? controller =
                  StateMachineController.fromArtboard(
                artboard,
                'State Machine 1',
              );

              artboard.addController(controller!);
              error = controller.findInput<bool>('Error') as SMITrigger;
              success = controller.findInput<bool>('Check') as SMITrigger;
              reset = controller.findInput<bool>('Reset') as SMITrigger;

              Future.delayed(
                const Duration(milliseconds: 1000),
                () {
                  if (widget.loaded == Loader.loaded) {
                    success.fire();
                  } else if (widget.loaded == Loader.loadingError) {
                    error.fire();
                  }
                },
              );
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text("RexTem"),
        const SizedBox(
          height: 50,
        ),
        widget.loaded == Loader.loaded &&
                FirebaseAuth.instance.currentUser == null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/login");
                    },
                    text: "Login",
                  ),
                  BButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/register");
                    },
                    text: "Register",
                  ),
                ],
              )
            : Container(),
      ],
    );

    return Scaffold(
      body: ListView(
        children: [
          DefaultTextStyle(
            style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
              color: Colours.black,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

class BButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  const BButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        fixedSize: const MaterialStatePropertyAll(Size(100, 50)),
        shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.elliptical(
              12.0,
              14.0,
            ),
          ),
        )),
        foregroundColor: const MaterialStatePropertyAll(Colours.black),
        elevation: const MaterialStatePropertyAll(6.0),
        backgroundColor: const MaterialStatePropertyAll(Colours.white),
        side: MaterialStatePropertyAll(
          BorderSide(
            width: 4.0,
            color: Theme.of(context).primaryColor,
          ),
        ),
        padding: const MaterialStatePropertyAll(EdgeInsets.all(
          10.0,
        )),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
