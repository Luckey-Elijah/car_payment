import 'package:car_payment/currency_text_editing_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CarAffordableResultsLabel extends StatelessWidget {
  const CarAffordableResultsLabel({
    super.key,
    required this.affordAmount,
    required this.downPercent,
    required this.monthlyPayment,
  });

  final double affordAmount;
  final double downPercent;
  final double monthlyPayment;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final label = theme.textTheme.p;
    final boldLabel = label.copyWith(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );

    return Column(
      children: [
        Text.rich(
          TextSpan(
            style: label,
            children: [
              const TextSpan(text: 'You can afford '),
              TextSpan(
                text:
                    r'$'
                    '${formatCurrency(affordAmount.toStringAsFixed(0))}',
                style: boldLabel,
              ),
              const TextSpan(text: ' worth of car with a down payment of '),
              TextSpan(
                text:
                    r'$'
                    '${formatCurrency(((((downPercent) / 100)) * affordAmount).toStringAsFixed(0))}',
                style: boldLabel,
              ),
              const TextSpan(text: '.'),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            style: label,
            children: [
              const TextSpan(text: 'Your monthly payment would be '),
              TextSpan(
                text:
                    r'$'
                    '${formatCurrency(monthlyPayment.toStringAsFixed(0))}',
                style: boldLabel,
              ),
              const TextSpan(text: '.'),
            ],
          ),
        ),
      ],
    );
  }
}

class PretaxIncomeRateLabel extends StatelessWidget {
  const PretaxIncomeRateLabel({super.key, required this.incomeCap});

  final double incomeCap;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final label = theme.textTheme.p;
    final boldLabel = label.copyWith(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );
    return Text.rich(
      TextSpan(
        style: label,
        children: [
          TextSpan(
            text: "${(incomeCap * 100).toStringAsFixed(0)}%",
            style: boldLabel,
          ),
          const TextSpan(text: ' of pre-tax income.'),
        ],
      ),
    );
  }
}

class PayoffTimeLabel extends StatelessWidget {
  const PayoffTimeLabel({super.key, required this.numberOfMonths});

  final int numberOfMonths;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final label = theme.textTheme.p;
    final boldLabel = label.copyWith(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );
    return Text.rich(
      TextSpan(
        style: label,
        children: [
          TextSpan(text: '$numberOfMonths', style: boldLabel),
          const TextSpan(text: ' months to pay off.'),
        ],
      ),
    );
  }
}

class PercentDownLabel extends StatelessWidget {
  const PercentDownLabel({super.key, required this.downPercent});

  final double downPercent;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final label = theme.textTheme.p;
    final boldLabel = label.copyWith(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );
    return Text.rich(
      TextSpan(
        style: label,
        children: [
          TextSpan(text: '${(downPercent).toInt()}%', style: boldLabel),
          const TextSpan(text: ' down.'),
        ],
      ),
    );
  }
}
