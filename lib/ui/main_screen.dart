import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_texts.dart';
import '../config/appearance.dart';
import 'converter_controller.dart';
import 'converter_state.dart';
import 'widgets/app_button.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  late Future<AppTexts> _textsFuture;
  late Future<AppAppearance> _appearanceFuture;

  @override
  void initState() {
    super.initState();
    _textsFuture = AppTexts.load();
    _appearanceFuture = AppAppearance.load();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(converterControllerProvider);
    final controller = ref.read(converterControllerProvider.notifier);

    return FutureBuilder2<AppTexts, AppAppearance>(
      future1: _textsFuture,
      future2: _appearanceFuture,
      builder: (context, texts, appearance) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: appearance.getColor('background', isDark: isDark),
          appBar: AppBar(
            title: Text(texts.get('appTitle')),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(appearance.getSize('pagePadding')),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildBody(context, state, controller, texts, appearance, isDark),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    ConverterState state,
    ConverterController controller,
    AppTexts texts,
    AppAppearance appearance,
    bool isDark,
  ) {
    switch (state.status) {
      case ConverterStatus.idle:
        return _buildIdleState(context, state, controller, texts, appearance, isDark);
      case ConverterStatus.converting:
        return _buildConvertingState(texts, appearance, isDark);
      case ConverterStatus.result:
        return _buildResultState(context, state, controller, texts, appearance, isDark);
      case ConverterStatus.error:
        return _buildErrorState(context, state, controller, texts, appearance, isDark);
    }
  }

  Widget _buildIdleState(
    BuildContext context,
    ConverterState state,
    ConverterController controller,
    AppTexts texts,
    AppAppearance appearance,
    bool isDark,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.description_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: appearance.getSize('mainButtonHeight'),
            child: ElevatedButton(
              onPressed: controller.pickAndConvert,
              style: ElevatedButton.styleFrom(
                backgroundColor: appearance.getColor('buttonBackground', isDark: isDark),
                foregroundColor: appearance.getColor('buttonText', isDark: isDark),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    appearance.getSize('mainButtonRadius'),
                  ),
                ),
                elevation: 4,
              ),
              child: Text(
                texts.get('mainButton'),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            texts.get('mainButtonHint'),
            style: TextStyle(
              color: appearance.getColor('textSecondary', isDark: isDark),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 48),
          _buildHistorySection(state, texts, appearance, isDark),
        ],
      ),
    );
  }

  Widget _buildHistorySection(
    ConverterState state,
    AppTexts texts,
    AppAppearance appearance,
    bool isDark,
  ) {
    final entries = state.history.take(5).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appearance.getColor('surface', isDark: isDark),
        borderRadius: BorderRadius.circular(appearance.getSize('cardRadius')),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            texts.get('historyTitle'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: appearance.getColor('textPrimary', isDark: isDark),
            ),
          ),
          const SizedBox(height: 8),
          if (entries.isEmpty)
            Text(
              texts.get('historyEmpty'),
              style: TextStyle(
                color: appearance.getColor('textSecondary', isDark: isDark),
              ),
            )
          else
            ...entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  entry,
                  style: TextStyle(
                    color: appearance.getColor('textSecondary', isDark: isDark),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConvertingState(AppTexts texts, AppAppearance appearance, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            texts.get('converting'),
            style: TextStyle(
              fontSize: 18,
              color: appearance.getColor('textPrimary', isDark: isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultState(
    BuildContext context,
    ConverterState state,
    ConverterController controller,
    AppTexts texts,
    AppAppearance appearance,
    bool isDark,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          Icon(
            Icons.check_circle,
            size: appearance.getSize('iconSize'),
            color: appearance.getColor('successColor', isDark: isDark),
          ),
          const SizedBox(height: 24),
          Text(
            texts.get('successTitle'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: appearance.getColor('textPrimary', isDark: isDark),
            ),
          ),
          const SizedBox(height: 32),
          if (state.originalFilename != null)
            _buildInfoRow(texts.get('originalFile'), state.originalFilename!, appearance, isDark),
          if (state.savedPath != null)
            _buildInfoRow(texts.get('savedPath'), state.savedPath!, appearance, isDark),
          const SizedBox(height: 32),
          AppButton(
            text: texts.get('saveButton'),
            onPressed: controller.saveMarkdown,
          ),
          const SizedBox(height: 12),
          AppButton(
            text: texts.get('shareButton'),
            onPressed: controller.shareMarkdown,
            isPrimary: false,
          ),
          const SizedBox(height: 12),
          AppButton(
            text: texts.get('convertAnotherButton'),
            onPressed: controller.convertAnother,
            isPrimary: false,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, AppAppearance appearance, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: appearance.getColor('textSecondary', isDark: isDark),
            ),
          ),
          const SizedBox(height: 4),
          SelectableText(
            value,
            style: TextStyle(
              fontSize: 15,
              color: appearance.getColor('textPrimary', isDark: isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    ConverterState state,
    ConverterController controller,
    AppTexts texts,
    AppAppearance appearance,
    bool isDark,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: appearance.getColor('errorColor', isDark: isDark),
            ),
            const SizedBox(height: 24),
            Text(
              texts.get('errorTitle'),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: appearance.getColor('textPrimary', isDark: isDark),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              state.errorMessage ?? texts.get('errorConvert'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: appearance.getColor('textSecondary', isDark: isDark),
              ),
            ),
            const SizedBox(height: 32),
            AppButton(
              text: texts.get('retryButton'),
              onPressed: controller.pickAndConvert,
            ),
            const SizedBox(height: 12),
            AppButton(
              text: texts.get('backButton'),
              onPressed: controller.resetToIdle,
              isPrimary: false,
            ),
          ],
        ),
      ),
    );
  }
}

// Вспомогательный виджет для двух Future
class FutureBuilder2<T1, T2> extends StatelessWidget {
  final Future<T1> future1;
  final Future<T2> future2;
  final Widget Function(BuildContext, T1, T2) builder;

  const FutureBuilder2({
    super.key,
    required this.future1,
    required this.future2,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T1>(
      future: future1,
      builder: (context, snapshot1) {
        if (!snapshot1.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return FutureBuilder<T2>(
          future: future2,
          builder: (context, snapshot2) {
            if (!snapshot2.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return builder(context, snapshot1.data as T1, snapshot2.data as T2);
          },
        );
      },
    );
  }
}
