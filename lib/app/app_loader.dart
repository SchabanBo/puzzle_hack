import 'package:flutter/material.dart';

import 'puzzle_app.dart' deferred as puzzle_app;

class AppLoader extends StatelessWidget {
  const AppLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _load(),
        builder: (c, s) => s.connectionState == ConnectionState.done
            ? puzzle_app.PuzzleApp()
            : const _SplashScreen(),
      );

  Future<void> _load() async {
    await puzzle_app.loadLibrary();
  }
}

class _SplashScreen extends StatefulWidget {
  const _SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<_SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: FlutterLogo(size: double.infinity),
        ),
      ),
    );
  }
}
