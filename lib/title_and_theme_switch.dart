import 'package:car_payment/theme_notifier.dart';
import 'package:context_plus/context_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class TitleAndThemeSwitch extends StatelessWidget {
  const TitleAndThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = $theme.watch(context);

    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                'How Much Car Can You Afford?',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: ShadTheme.of(context).textTheme.h3,
              ),
            ),
          ),
        ),
        ShadTooltip(
          builder:
              (_) => switch (mode) {
                ThemeMode.system => const Text('using system mode'),
                ThemeMode.light => const Text('using light mode'),
                ThemeMode.dark => const Text('using dark mode'),
              },
          child: ShadIconButton.outline(
            icon: Icon(switch (mode) {
              ThemeMode.system => LucideIcons.computer,
              ThemeMode.light => LucideIcons.lightbulb,
              ThemeMode.dark => LucideIcons.lightbulbOff,
            }),
            onSecondaryTapDown: (value) {
              $theme.value = switch (mode) {
                ThemeMode.system => ThemeMode.dark,
                ThemeMode.light => ThemeMode.system,
                ThemeMode.dark => ThemeMode.light,
              };
            },
            onPressed: () {
              $theme.value = switch (mode) {
                ThemeMode.system => ThemeMode.light,
                ThemeMode.light => ThemeMode.dark,
                ThemeMode.dark => ThemeMode.system,
              };
            },
          ),
        ),
      ],
    );
  }
}
