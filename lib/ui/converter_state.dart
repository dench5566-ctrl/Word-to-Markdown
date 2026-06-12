import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConverterStatus { idle, converting, result, error }

class ConverterState {
  final ConverterStatus status;
  final String? originalFilename;
  final String? markdownContent;
  final String? savedPath;
  final String? errorMessage;
  final List<String> history;

  const ConverterState({
    this.status = ConverterStatus.idle,
    this.originalFilename,
    this.markdownContent,
    this.savedPath,
    this.errorMessage,
    this.history = const [],
  });

  ConverterState copyWith({
    ConverterStatus? status,
    String? originalFilename,
    String? markdownContent,
    String? savedPath,
    String? errorMessage,
    List<String>? history,
  }) {
    return ConverterState(
      status: status ?? this.status,
      originalFilename: originalFilename ?? this.originalFilename,
      markdownContent: markdownContent ?? this.markdownContent,
      savedPath: savedPath ?? this.savedPath,
      errorMessage: errorMessage ?? this.errorMessage,
      history: history ?? this.history,
    );
  }
}