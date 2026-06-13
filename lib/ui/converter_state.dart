const Object _unset = Object();

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
    Object? originalFilename = _unset,
    Object? markdownContent = _unset,
    Object? savedPath = _unset,
    Object? errorMessage = _unset,
    Object? history = _unset,
  }) {
    return ConverterState(
      status: status ?? this.status,
      originalFilename: identical(originalFilename, _unset)
          ? this.originalFilename
          : originalFilename as String?,
      markdownContent: identical(markdownContent, _unset)
          ? this.markdownContent
          : markdownContent as String?,
      savedPath: identical(savedPath, _unset) ? this.savedPath : savedPath as String?,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
      history: identical(history, _unset) ? this.history : history as List<String>,
    );
  }
}
