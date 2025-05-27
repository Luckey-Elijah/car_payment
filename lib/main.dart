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
    const shadSeparatorTheme = ShadSeparatorTheme(
      horizontalMargin: EdgeInsets.zero,
      verticalMargin: EdgeInsets.zero,
    );
    final theme = ShadThemeData(
      brightness: Brightness.light,
      colorScheme: const ShadGrayColorScheme.light(),
      separatorTheme: shadSeparatorTheme,
    );

    final darkTheme = ShadThemeData(
      brightness: Brightness.dark,
      colorScheme: const ShadGrayColorScheme.dark(),
      separatorTheme: shadSeparatorTheme,
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
      title: 'how much car can you afford?',
      themeMode: mode,
      theme: theme,
      darkTheme: darkTheme,
      home: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TitleAndThemeSwitch(),
          ),
          Flexible(
            child: SizedBox(width: 640, child: CarPaymentCalculator()),
          ),
        ],
      ),
    );
  }
}
