import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/functions/basic.dart';

import 'firebase_options.dart';
import 'start/loading_view.dart';

class HostScreen extends StatelessWidget {
  const HostScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        NavigatorState ctxN = Navigator.of(context);
        if (snapshot.hasError) {
          return const LoadingView(
            loaded: LoaderState.loadingError,
          );
        }
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            Future.delayed(const Duration(milliseconds: 500), () {
              ctxN.pushReplacementNamed(initialScreenRoute);
            });
            return const Scaffold();
          default:
            return const LoadingView(
              next: "",
              loaded: LoaderState.loading,
            );
        }
      },
    );
  }
}
