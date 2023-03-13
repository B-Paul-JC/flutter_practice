import 'package:colours/colours.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import '../functions/basic.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        NavigatorState ctxN = Navigator.of(context);

        return await askConfirmation(
          context,
          title: "Are you sure you want to exit the app?",
          content: "Leave the app?",
          onReject: () => ctxN.pop(false),
          onAccept: () => ctxN.pop(true),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home View"),
          actions: [
            IconButton(
              onPressed: signOut(context),
              icon: const Icon(
                FluentIcons.sign_out_24_filled,
                color: Colours.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
