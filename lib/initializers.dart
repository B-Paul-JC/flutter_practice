import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'start/loading_view.dart';

class InitialViews extends StatefulWidget {
  const InitialViews({super.key});

  @override
  State<InitialViews> createState() => _InitialViewsState();
}

class _InitialViewsState extends State<InitialViews> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        User? user = snapshot.data;
        NavigatorState ctxN = Navigator.of(context);
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            if (user == null) {
              return const LoadingView(
                loaded: Loader.loaded,
              );
            }
            if (user.emailVerified) {
              Future.delayed(
                const Duration(milliseconds: 1000),
                () => ctxN.pushReplacementNamed("/home"),
              );
              return Container();
            } else {
              return const LoadingView(
                loaded: Loader.loaded,
                next: "/verify-email",
              );
            }

          case ConnectionState.none:
          default:
            return const LoadingView(
              next: "",
              loaded: Loader.loadingError,
            );
        }
      },
    );
  }
}
