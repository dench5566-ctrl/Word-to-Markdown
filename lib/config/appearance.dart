import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class AppAppearance {
  final Map<String, dynamic> light;
  final Map<String, dynamic> dark;
  final Map<String, dynamic> sizes;

  AppAppearance({
    required this.light,
    required this.dark,
    required this.sizes,
  });

  factory AppAppearance.fromJson(Map<String, dynamic> json) {
    return AppAppearance(
      light: Map<String, dynamic>.from(json['light'] ?? {}),
      dark: Map<String, dynamic>.from(json['dark'] ?? {}),
      sizes: Map<String, dynamic>.from(json['sizes'] ?? {}),
    );
  }

  static Future<AppAppearance> load() async {
    final String jsonString =
        await rootBundle.loadString('assets/config/appearance.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return AppAppearance.fromJson(jsonMap);
  }

  Color getColor(String key, {bool isDark = false}) {
    final theme = isDark ? dark : light;
    final value = theme[key] as String? ?? '#000000';
    return Color(int.parse(value.replaceFirst('#', '0xff')));
  }

  double getSize(String key) {
    return (sizes[key] as num?)?.toDouble() ?? 16.0;
  }
}