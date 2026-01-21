import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/menu_screen.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const CS2App());
}

class CS2App extends StatelessWidget {
  const CS2App({super.key});

  @override
  Widget build(BuildContext context) {
    // Force landscape for a game-like feel on mobile, though on Mac it's a window.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return MaterialApp(
      title: 'Counter-Strike 2 (Flutter Edition)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1B1B1B),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFDE9B35), // CS2 Gold/Orange
          secondary: Color(0xFF5D79AE), // CT Blue
          surface: Color(0xFF2D2D2D),
          background: Color(0xFF1B1B1B),
        ),
        fontFamily: 'Roboto', // Standard font, close enough for a demo
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MenuScreen(),
        '/game': (context) => const GameScreen(),
      },
    );
  }
}
