# d2 — DOCX → Markdown

Простое мобильное приложение для конвертации `.docx` файлов в Markdown полностью оффлайн.

## Что исправлено в v001

- Сборка GitHub Actions переведена с Flutter 3.24.5 на Flutter 3.44.0.
- Повышено требование Dart SDK до `>=3.11.0`, потому что `docx_to_markdown` требует Dart 3.10+, а актуальный `file_saver` 0.4.0 требует Dart 3.11+.
- Исправлен вызов API `docx_to_markdown`: используется `DocxConverter(bytes).convert()`.
- Добавлена генерация Android-папки в GitHub Actions, если в архиве её нет.
- Обновлён `file_saver` до 0.4.0 и исправлена подготовка UTF-8 байтов для сохранения Markdown.
- Добавлен прямой dependency `path`, потому что он используется в коде напрямую.
- Убраны лишние зависимости для генерации Riverpod, которые в проекте не используются.

## Запуск локально

```bash
flutter pub get
flutter analyze
flutter run
```

## Сборка APK локально

Если папки `android/` нет:

```bash
flutter create --platforms=android --project-name d2 --org com.dench5566 .
```

Потом:

```bash
flutter pub get
flutter build apk --release
```

## Техническое задание

См. файл `d2_DOCX_to_Markdown_Technical_Specification_v001.md`.
