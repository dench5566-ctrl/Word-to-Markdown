import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as p;

import '../features/converter/docx_to_markdown_service.dart';
import '../features/converter/counter_service.dart';
import '../features/converter/log_service.dart';
import 'converter_state.dart';

final converterControllerProvider =
    StateNotifierProvider<ConverterController, ConverterState>((ref) {
  return ConverterController(
    docxService: DocxToMarkdownService(),
    counterService: CounterService(),
    logService: LogService(),
  );
});

class ConverterController extends StateNotifier<ConverterState> {
  final DocxToMarkdownService _docxService;
  final CounterService _counterService;
  final LogService _logService;

  ConverterController({
    required DocxToMarkdownService docxService,
    required CounterService counterService,
    required LogService logService,
  })  : _docxService = docxService,
        _counterService = counterService,
        _logService = logService,
        super(const ConverterState()) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final entries = await _logService.getLastEntries();
    state = state.copyWith(history: entries);
  }

  Future<void> pickAndConvert() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['docx'],
      withData: false,
    );

    if (result == null || result.files.isEmpty) return;

    final platformFile = result.files.first;
    final filePath = platformFile.path;
    if (filePath == null) {
      state = state.copyWith(
        status: ConverterStatus.error,
        errorMessage: 'Не удалось получить путь к файлу',
      );
      return;
    }

    final file = File(filePath);
    final originalName = p.basenameWithoutExtension(filePath);

    state = state.copyWith(
      status: ConverterStatus.converting,
      originalFilename: '$originalName.docx',
      errorMessage: null,
    );

    try {
      final markdown = await _docxService.convert(file);

      if (markdown.trim().isEmpty) {
        state = state.copyWith(
          status: ConverterStatus.error,
          errorMessage: 'Получен пустой Markdown',
        );
        return;
      }

      state = state.copyWith(
        status: ConverterStatus.result,
        markdownContent: markdown,
      );
    } catch (e) {
      state = state.copyWith(
        status: ConverterStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> saveMarkdown() async {
    if (state.markdownContent == null || state.originalFilename == null) return;

    final originalName = p.basenameWithoutExtension(state.originalFilename!);
    final suggestedName = '$originalName.md';

    try {
      final savedPath = await FileSaver.instance.saveAs(
        name: suggestedName,
        bytes: state.markdownContent!.codeUnits,
        ext: 'md',
        mimeType: MimeType.text,
      );

      if (savedPath != null) {
        // Логируем успешное сохранение
        await _logService.logConversion(suggestedName);
        await _loadHistory();

        state = state.copyWith(
          savedPath: savedPath,
        );
      } else {
        // Пользователь отменил сохранение
        state = state.copyWith(
          status: ConverterStatus.idle,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: ConverterStatus.error,
        errorMessage: 'Ошибка сохранения: $e',
      );
    }
  }

  Future<void> shareMarkdown() async {
    if (state.markdownContent == null) return;

    await Share.share(
      state.markdownContent!,
      subject: state.originalFilename?.replaceAll('.docx', '.md'),
    );
  }

  void convertAnother() {
    state = const ConverterState(status: ConverterStatus.idle);
    _loadHistory();
  }

  void resetToIdle() {
    state = const ConverterState(status: ConverterStatus.idle);
  }

  void setError(String message) {
    state = state.copyWith(
      status: ConverterStatus.error,
      errorMessage: message,
    );
  }
}