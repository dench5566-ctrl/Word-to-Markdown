import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class LogService {
  static const _fileName = 'conversions.log';
  static const _maxEntries = 10;

  Future<void> logConversion(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');

    final now = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    final entry = '$now — $filename\n';

    String content = '';
    if (await file.exists()) {
      content = await file.readAsString();
    }

    final lines = content.trim().split('\n').where((l) => l.isNotEmpty).toList();
    lines.insert(0, entry.trim());

    final limited = lines.take(_maxEntries).join('\n');
    await file.writeAsString('$limited\n');
  }

  Future<List<String>> getLastEntries() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');

    if (!await file.exists()) return [];

    final content = await file.readAsString();
    return content.trim().split('\n').where((l) => l.isNotEmpty).toList();
  }
}