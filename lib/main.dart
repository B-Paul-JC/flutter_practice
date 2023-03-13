import 'package:flutter/material.dart';
import 'package:colours/colours.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'functions/basic.dart';
import 'start/register_view.dart';
import 'start/login_view.dart';
import 'host_screen.dart';
import 'initializers.dart';
import 'views/home_view.dart';
import 'start/verify_email.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HostPage(
            child: LoginView(),
          ),
          opaque: false,
        );
      case registerRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HostPage(
            child: RegisterView(),
          ),
          opaque: false,
        );
      case homeRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HostPage(
            child: HomeView(),
          ),
          opaque: false,
        );
      case verifyEmailRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HostPage(
            child: VerifyEmailView(),
          ),
          opaque: false,
        );
      case initialScreenRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HostPage(
            child: InitialViews(),
          ),
          opaque: false,
        );
      default:
        throw Exception("Route Not Found ${settings.name}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: onGenerateRoutes,
      debugShowCheckedModeBanner: false,
      color: Colours.hotPink,
      theme: ThemeData(
        primarySwatch: Colours.sandyBrown,
        fontFamily: "Raleway",
      ),
      title: "Practice App",
      home: const HostScreen(),
    );
  }
}

class HostPage extends StatelessWidget {
  final Widget child;

  const HostPage({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.synchronized(
      child: FadeInAnimation(
        child: SlideAnimation(
          verticalOffset: 1000,
          child: child,
        ),
      ),
    );
  }
}
