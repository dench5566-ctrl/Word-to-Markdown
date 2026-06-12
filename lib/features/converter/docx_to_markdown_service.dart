import 'dart:io';
import 'package:docx_to_markdown/docx_to_markdown.dart';

class DocxToMarkdownService {
  /// Конвертирует .docx файл в Markdown строку.
  /// Возвращает результат или выбрасывает исключение.
  Future<String> convert(File docxFile) async {
    try {
      final bytes = await docxFile.readAsBytes();
      final markdown = await DocxToMarkdown().convert(bytes);
      return markdown.trim();
    } catch (e) {
      throw Exception('Ошибка конвертации DOCX в Markdown: $e');
    }
  }
}