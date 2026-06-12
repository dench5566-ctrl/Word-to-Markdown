import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CounterService {
  static const _fileName = 'counter.txt';
  static const _maxValue = 9999;

  Future<int> getNextNumber() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');

    int current = 0;
    if (await file.exists()) {
      final content = await file.readAsString();
      current = int.tryParse(content.trim()) ?? 0;
    }

    int next = current + 1;
    if (next > _maxValue) next = 1;

    await file.writeAsString(next.toString().padLeft(4, '0'));
    return next;
  }
}