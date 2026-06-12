import 'dart:convert';
import 'package:flutter/services.dart';

class AppTexts {
  final String version;
  final String language;
  final Map<String, String> texts;

  AppTexts({
    required this.version,
    required this.language,
    required this.texts,
  });

  factory AppTexts.fromJson(Map<String, dynamic> json) {
    return AppTexts(
      version: json['version'] ?? '1.0',
      language: json['language'] ?? 'ru',
      texts: Map<String, String>.from(json['texts'] ?? {}),
    );
  }

  static Future<AppTexts> load() async {
    final String jsonString =
        await rootBundle.loadString('assets/config/texts.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return AppTexts.fromJson(jsonMap);
  }

  String get(String key) => texts[key] ?? key;
}