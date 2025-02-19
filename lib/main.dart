import 'package:car_payment/bg_and_default_text_wrapper.dart';
import 'package:car_payment/car_payment_calculator.dart';
import 'package:car_payment/theme_notifier.dart';
import 'package:car_payment/title_and_theme_switch.dart';
import 'package:context_plus/context_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() => runApp(ContextPlus.root(child: const App()));

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = $theme.watch(context);
    final theme = ShadThemeData(
      brightness: Brightness.light,
      colorScheme: const ShadGrayColorScheme.light(),
    );

    final darkTheme = ShadThemeData(
      brightness: Brightness.dark,
      colorScheme: const ShadGrayColorScheme.dark(),
    );

    final color = switch (mode) {
      ThemeMode.light => theme.colorScheme.background,
      ThemeMode.dark => darkTheme.colorScheme.background,
      ThemeMode.system => switch (MediaQuery.platformBrightnessOf(context)) {
        Brightness.light => theme.colorScheme.background,
        Brightness.dark => darkTheme.colorScheme.background,
      },
    };
    return ShadApp(
      color: color,
      debugShowCheckedModeBanner: false,
      title: 'How Much Car Can You Afford?',
      themeMode: mode,
      theme: theme,
      darkTheme: darkTheme,
      home: const BgAndDefaultTextWrapper(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: TitleAndThemeSwitch(),
            ),
            Flexible(child: CarPaymentCalculator()),
          ],
        ),
      ),
    );
  }
}
