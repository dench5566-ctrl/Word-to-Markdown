import 'dart:io';
import 'package:docx_to_markdown/docx_to_markdown.dart';

class DocxToMarkdownService {
  /// Конвертирует .docx файл в Markdown строку.
  Future<String> convert(File docxFile) async {
    if (!await docxFile.exists()) {
      throw Exception('Файл не найден');
    }

    if (await docxFile.length() == 0) {
      throw Exception('Выбран пустой файл');
    }

    try {
      final bytes = await docxFile.readAsBytes();
      final converter = DocxConverter(bytes);
      final markdown = await converter.convert();
      return markdown.trim();
    } catch (e) {
      throw Exception('Ошибка конвертации DOCX в Markdown: $e');
    }
  }
}
