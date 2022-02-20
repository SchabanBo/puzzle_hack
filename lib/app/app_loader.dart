import 'package:flutter/material.dart';

import 'puzzle_app.dart' deferred as puzzle_app;

class AppLoader extends StatelessWidget {
  const AppLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: puzzle_app.loadLibrary(),
        builder: (c, s) => s.connectionState == ConnectionState.done
            ? puzzle_app.PuzzleApp()
            : const _SplashScreen(),
      );
}

class _SplashScreen extends StatefulWidget {
  const _SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<_SplashScreen> {
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _visible = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 1000),
            child: const FlutterLogo(size: double.infinity),
            onEnd: () {
              setState(() {
                _visible = !_visible;
              });
            },
          ),
        ),
      ),
    );
  }
}
