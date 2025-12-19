import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design_system/tds.dart';
import '../features/intro/intro_screen.dart';

class ThumbSomeApp extends StatelessWidget {
  const ThumbSomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Thumb Some',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.surface,
        fontFamily: 'Pretendard',
      ),
      home: const IntroScreen(),
    );
  }
}
