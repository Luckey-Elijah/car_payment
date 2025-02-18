import 'dart:math';

import 'package:car_payment/finance_helpers.dart';
import 'package:car_payment/label_widgets.dart';
import 'package:flutter/material.dart' show Brightness, ThemeMode;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const CarPaymentApp());

class CarPaymentApp extends StatelessWidget {
  const CarPaymentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: $theme,
      builder: (contex, mode, _) {
        return ShadApp(
          debugShowCheckedModeBanner: false,
          title: 'How Much Car Can You Afford?',
          themeMode: mode,
          theme: ShadThemeData(
            brightness: Brightness.light,
            colorScheme: const ShadGrayColorScheme.light(),
          ),
          darkTheme: ShadThemeData(
            brightness: Brightness.dark,
            colorScheme: const ShadGrayColorScheme.dark(),
          ),
          home: Builder(
            builder: (context) {
              return ColoredBox(
                color: ShadTheme.of(context).colorScheme.background,
                child: DefaultTextStyle(
                  style: ShadTheme.of(context).textTheme.p,
                  child: const Column(
                    children: [
                      Title(),
                      Expanded(child: CarPaymentCalculator()),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

final $theme = ValueNotifier<ThemeMode>(ThemeMode.system);

class Title extends StatelessWidget {
  const Title({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Text(
          'How Much Car Can You Afford',
          style: ShadTheme.of(context).textTheme.h3,
        ),
        const Spacer(),
        ValueListenableBuilder(
          valueListenable: $theme,
          builder: (_, mode, _) {
            return ShadTooltip(
              builder:
                  (_) => switch (mode) {
                    ThemeMode.system => const Text('using system mode'),
                    ThemeMode.light => const Text('using light mode'),
                    ThemeMode.dark => const Text('using dark mode'),
                  },
              child: ShadButton.outline(
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
            );
          },
        ),
      ],
    );
  }
}

class CarPaymentCalculator extends StatefulWidget {
  const CarPaymentCalculator({super.key});

  @override
  State<CarPaymentCalculator> createState() => _CarPaymentCalculatorState();
}

final url = Uri.parse('https://moneyguy.com/article/20-3-8-rule/');

class CarPaymentNotifier with ChangeNotifier {
  int numberOfMonths = 36;
  double downPercent = 20.0;
  double incomeCap = 0.08;

  double currentMonthlyPayments = 0;
  double? annualGrossIncome;
  double? interestRate;

  double get monthlyPayment {
    if (annualGrossIncome != null) {
      final basePayment = (annualGrossIncome! / 12) * incomeCap;
      return max(basePayment - currentMonthlyPayments, 0);
    }
    return 0;
  }

  double get affordAmount {
    if (annualGrossIncome != null && interestRate != null) {
      return calculateAffordableAmount(
        annualGrossIncome: annualGrossIncome!,
        interestRate: interestRate!,
        currentMonthlyPayments: currentMonthlyPayments,
        downPercent: downPercent,
        incomeCap: incomeCap,
        numberOfMonths: numberOfMonths,
      );
    }
    return 0.0;
  }

  void grossIncomeChange(String value) {
    annualGrossIncome = double.tryParse(value);
    notifyListeners();
  }

  void interestRateChange(String value) {
    var parsed = double.tryParse(value);
    if (parsed != null && parsed <= 0) {
      interestRate = null;
    } else {
      interestRate = parsed;
    }
    notifyListeners();
  }

  void numberOfPaymentsChange(String value) {
    currentMonthlyPayments = double.tryParse(value) ?? 0;
    notifyListeners();
  }

  void percentDownChange(String value) {
    downPercent = double.tryParse(value) ?? 20;
    notifyListeners();
  }

  void termChange(String value) {
    numberOfMonths = int.tryParse(value) ?? 36;
    notifyListeners();
  }

  void percentIncomeChange(String value) {
    incomeCap = (double.tryParse(value) ?? 8) / 100;
    notifyListeners();
  }
}

class _CarPaymentCalculatorState extends State<CarPaymentCalculator> {
  final notifier = CarPaymentNotifier();
  String? errorMessageIfNull(Object? value, [String? message]) {
    if (value == null) return message ?? 'Please enter a number.';
    return null;
  }

  @override
  void dispose() {
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ShadDecoration? errorWhenNull(Object? value) {
      if (value == null) {
        return ShadDecoration(
          border: ShadBorder.all(
            color:
                value == null
                    ? ShadTheme.of(context).colorScheme.destructive
                    : null,
          ),
        );
      }
      return null;
    }

    const gap = SizedBox.square;
    return ListenableBuilder(
      listenable: notifier,
      builder: (context, _) {
        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ShadCard(
                child: Column(
                  children: [
                    ShadInput(
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      onChanged: notifier.grossIncomeChange,
                      placeholder: const Text('Annual Gross Income'),
                      prefix: Text(
                        r'$',
                        style: ShadTheme.of(context).textTheme.muted,
                      ),
                      decoration: errorWhenNull(notifier.annualGrossIncome),
                    ),

                    ShadInput(
                      keyboardType: TextInputType.number,
                      onChanged: notifier.interestRateChange,
                      placeholder: const Text('Interest Rate'),
                      suffix: Text(
                        '%',
                        style: ShadTheme.of(context).textTheme.muted,
                      ),
                      decoration: errorWhenNull(notifier.interestRate),
                    ),

                    ShadInput(
                      keyboardType: TextInputType.number,
                      onChanged: notifier.numberOfPaymentsChange,
                      prefix: Text(
                        r'$',
                        style: ShadTheme.of(context).textTheme.muted,
                      ),
                      placeholder: const Text('Current Monthly Car Payments'),
                    ),
                  ],
                ),
              ),
            ),
            gap(dimension: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ShadCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Adjust more...',
                      style: ShadTheme.of(context).textTheme.h4,
                    ),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        final percentDown = ShadInput(
                          keyboardType: TextInputType.number,
                          onChanged: notifier.percentDownChange,
                          suffix: Text(
                            '%',
                            style: ShadTheme.of(context).textTheme.muted,
                          ),
                          placeholder: const Text('Percent down (20% default)'),
                        );
                        final termLength = ShadInput(
                          keyboardType: TextInputType.number,
                          onChanged: notifier.termChange,
                          placeholder: const Text('Term Length in months (36)'),
                        );
                        final pretax = ShadInput(
                          keyboardType: TextInputType.number,
                          onChanged: notifier.percentIncomeChange,
                          suffix: Text(
                            '%',
                            style: ShadTheme.of(context).textTheme.muted,
                          ),
                          placeholder: const Text('% of pre-tax income (8%)'),
                        );
                        if (constraints.maxWidth > 600) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(child: percentDown),
                              Expanded(child: termLength),
                              Expanded(child: pretax),
                            ],
                          );
                        }
                        return Column(
                          children: [percentDown, termLength, pretax],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            gap(dimension: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ShadCard(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 480) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: PercentDownLabel(
                              downPercent: notifier.downPercent,
                            ),
                          ),
                          Flexible(
                            child: PayoffTimeLabel(
                              numberOfMonths: notifier.numberOfMonths,
                            ),
                          ),
                          Flexible(
                            child: PretaxIncomRateLabel(
                              incomeCap: notifier.incomeCap,
                            ),
                          ),
                        ],
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PercentDownLabel(downPercent: notifier.downPercent),
                        PayoffTimeLabel(
                          numberOfMonths: notifier.numberOfMonths,
                        ),
                        PretaxIncomRateLabel(incomeCap: notifier.incomeCap),
                      ],
                    );
                  },
                ),
              ),
            ),
            gap(dimension: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ShadCard(
                child: Column(
                  children: [
                    CarAffordableResultsLabel(
                      affordAmount: notifier.affordAmount,
                      downPercent: notifier.downPercent,
                      monthlyPayment: notifier.monthlyPayment,
                    ),
                    ShadTooltip(
                      builder: (_) => Text('$url'),
                      child: ShadButton.link(
                        onPressed: () async {
                          if (!await launchUrl(url) && context.mounted) {
                            ShadToaster.of(context).show(
                              ShadToast(
                                title: const Text(
                                  'Uh oh! Something went wrong.',
                                ),
                                description: Text('Could not launch "$url".'),
                                action: const CopyUrlToClipboard(),
                              ),
                            );
                          }
                        },
                        child: const Text('Based on the 20/3/8 Rule'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CopyUrlToClipboard extends StatefulWidget {
  const CopyUrlToClipboard({super.key});

  @override
  State<CopyUrlToClipboard> createState() => _CopyUrlToClipboardState();
}

class _CopyUrlToClipboardState extends State<CopyUrlToClipboard> {
  var copied = false;

  @override
  Widget build(BuildContext context) {
    return ShadButton(onPressed: onPressed, icon: icon());
  }

  Widget icon() {
    if (copied) return const Icon(LucideIcons.clipboardCheck);
    return const Icon(LucideIcons.clipboardCopy);
  }

  void onPressed() async {
    try {
      await Clipboard.setData(ClipboardData(text: '$url'));
    } finally {
      setState(() => copied = true);
    }
  }
}
