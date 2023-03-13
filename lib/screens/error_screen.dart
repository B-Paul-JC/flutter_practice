import 'package:flutter/material.dart';
import 'package:flutter_practice/functions/basic.dart';
import 'package:rive/rive.dart';

class ErrorScreen extends StatelessWidget {
  final String text;
  const ErrorScreen(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    NavigatorState ctxN = Navigator.of(context);

    return GestureDetector(
      onTap: ctxN.pop,
      child: Scaffold(
        backgroundColor: const Color(0x22770000),
        body: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              width: 250,
              height: 250,
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 12.0,
              ),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                border: Border(
                  left: BorderSide(
                    color: Colors.red.shade500,
                    width: 6.0,
                  ),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: const [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: RiveCheck(
                            loader: LoaderState.loadingError,
                          ),
                        ),
                        Text(
                          "Sorry, Something\nwent wrong...",
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Positioned(
                    top: 80,
                    child: Text(
                      "Details:",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 21.0,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 120,
                    width: 180,
                    child: Text(
                      text,
                      maxLines: 10,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontStyle: FontStyle.italic,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
