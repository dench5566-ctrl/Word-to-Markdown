import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/app_theme.dart';
import 'ui/main_screen.dart';

void main() {
  runApp(const ProviderScope(child: D2App()));
}

class D2App extends StatelessWidget {
  const D2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DOCX → Markdown',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(isDark: false),
      darkTheme: buildTheme(isDark: true),
      themeMode: ThemeMode.system,
      home: const MainScreen(),
    );
  }
}