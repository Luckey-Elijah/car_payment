import 'package:car_payment/car_payment_notifier.dart';
import 'package:car_payment/currency_text_editing_controller.dart';
import 'package:car_payment/gross_income_input.dart';
import 'package:car_payment/label_widgets.dart';
import 'package:car_payment/theme_notifier.dart';
import 'package:car_payment/title_and_theme_switch.dart';
import 'package:context_plus/context_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(ContextPlus.root(child: const CarPaymentApp()));

class CarPaymentApp extends StatelessWidget {
  const CarPaymentApp({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = $theme.watch(context);

    return ShadApp(
      color: const Color(0xffffffff),
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
                  TitleAndThemeSwitch(),
                  Flexible(child: CarPaymentCalculator()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

ShadDecoration? errorWhenNull(double? value, BuildContext context) {
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

class CarPaymentCalculator extends StatelessWidget {
  const CarPaymentCalculator({super.key});

  String? errorMessageIfNull(Object? value, [String? message]) {
    if (value == null) return message ?? 'Please enter a number.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.all(8),
          child: ShadCard(
            width: 200,
            child: Column(
              children: [
                GrossIncomeInput(),
                InterestRateInput(),
                MonthlyCarPaymentInput(),
              ],
            ),
          ),
        ),

        const Padding(padding: EdgeInsets.all(8), child: AdjustMoreSection()),

        const Padding(
          padding: EdgeInsets.all(8),
          child: ShadCard(child: DetailsSummarySection()),
        ),

        Padding(
          padding: const EdgeInsets.all(8),
          child: ShadCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CarAffordableResultsLabel(
                  affordAmount: $carPayment.watchOnly(
                    context,
                    (x) => x.affordAmount,
                  ),
                  downPercent: $carPayment.watchOnly(
                    context,
                    (x) => x.downPercent,
                  ),
                  monthlyPayment: $carPayment.watchOnly(
                    context,
                    (x) => x.monthlyPayment,
                  ),
                ),
                const WebReferenceLinkButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WebReferenceLinkButton extends StatelessWidget {
  const WebReferenceLinkButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadTooltip(
      builder: (_) => Text('$url'),
      child: ShadButton.link(
        onPressed: () async {
          if (!await launchUrl(url) && context.mounted) {
            ShadToaster.of(context).show(
              ShadToast(
                title: const Text('Uh oh! Something went wrong.'),
                description: Text('Could not launch "$url".'),
                action: const CopyUrlToClipboard(),
              ),
            );
          }
        },
        child: const Text('What is the 20/3/8 Rule?'),
      ),
    );
  }
}

class DetailsSummarySection extends StatelessWidget {
  const DetailsSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    final downPercent = $carPayment.watchOnly(context, (x) => x.downPercent);
    final numberOfMonths = $carPayment.watchOnly(
      context,
      (x) => x.numberOfMonths,
    );

    final incomeCap = $carPayment.watchOnly(context, (x) => x.incomeCap);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 480) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: PercentDownLabel(downPercent: $carPayment.downPercent),
              ),
              Flexible(
                child: PayoffTimeLabel(
                  numberOfMonths: $carPayment.numberOfMonths,
                ),
              ),
              Flexible(
                child: PretaxIncomRateLabel(incomeCap: $carPayment.incomeCap),
              ),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PercentDownLabel(downPercent: downPercent),
            PayoffTimeLabel(numberOfMonths: numberOfMonths),
            PretaxIncomRateLabel(incomeCap: incomeCap),
          ],
        );
      },
    );
  }
}

class AdjustMoreSection extends StatelessWidget {
  const AdjustMoreSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Adjust more...', style: ShadTheme.of(context).textTheme.h4),

          LayoutBuilder(
            builder: (context, constraints) {
              const percentDown = PercentDownInput();
              const termLength = TermLengthInput();
              const pretax = PercentIncomeInput();
              if (constraints.maxWidth > 600) {
                return const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: percentDown),
                    Expanded(child: termLength),
                    Expanded(child: pretax),
                  ],
                );
              }
              return const Column(children: [percentDown, termLength, pretax]);
            },
          ),
        ],
      ),
    );
  }
}

class PercentIncomeInput extends StatelessWidget {
  const PercentIncomeInput({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadInput(
      keyboardType: TextInputType.number,
      onChanged: $carPayment.percentIncomeChange,
      suffix: Text('%', style: ShadTheme.of(context).textTheme.muted),
      placeholder: const Text('% of pre-tax income (8%)'),
    );
  }
}

class TermLengthInput extends StatelessWidget {
  const TermLengthInput({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadInput(
      keyboardType: TextInputType.number,
      onChanged: $carPayment.termChange,
      placeholder: const Text('Term Length in months (36)'),
    );
  }
}

class PercentDownInput extends StatelessWidget {
  const PercentDownInput({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadInput(
      keyboardType: TextInputType.number,
      onChanged: $carPayment.percentDownChange,
      suffix: Text('%', style: ShadTheme.of(context).textTheme.muted),
      placeholder: const Text('Percent down (20% default)'),
    );
  }
}

class MonthlyCarPaymentInput extends StatefulWidget {
  const MonthlyCarPaymentInput({super.key});

  @override
  State<MonthlyCarPaymentInput> createState() => _MonthlyCarPaymentInputState();
}

class _MonthlyCarPaymentInputState extends State<MonthlyCarPaymentInput> {
  final controller = CurrencyTextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  void listener() {
    $carPayment.numberOfPaymentsChange(controller.text.replaceAll(',', ''));
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShadInput(
      controller: controller,
      keyboardType: TextInputType.number,
      prefix: Text(r'$', style: ShadTheme.of(context).textTheme.muted),
      placeholder: const Text('Current Monthly Car Payments'),
    );
  }
}

class InterestRateInput extends StatefulWidget {
  const InterestRateInput({super.key});

  @override
  State<InterestRateInput> createState() => _InterestRateInputState();
}

class _InterestRateInputState extends State<InterestRateInput> {
  final focusNode = FocusNode();
  var hasFocus = false;
  var first = true;

  void focusListener() {
    if (hasFocus && !focusNode.hasFocus) {
      setState(() => first = false);
    } else if (!hasFocus) {
      setState(() => hasFocus = focusNode.hasFocus);
    }
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(focusListener);
  }

  @override
  void dispose() {
    focusNode
      ..removeListener(focusListener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final interestRate = $carPayment.watchOnly(context, (x) => x.interestRate);
    var decor = errorWhenNull(interestRate, context);
    return ShadInput(
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      onChanged: $carPayment.interestRateChange,
      placeholder: const Text('Interest Rate'),
      suffix: Text('%', style: ShadTheme.of(context).textTheme.muted),
      decoration: first ? null : decor,
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

final url = Uri.parse('https://moneyguy.com/article/20-3-8-rule/');
