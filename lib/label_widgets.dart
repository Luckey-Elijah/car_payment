import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);
    final label = theme.textTheme.headlineSmall;
    final boldLabel = label?.copyWith(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );

    return Text.rich(
      TextSpan(
        style: label,
        children: [
          const TextSpan(text: 'You can afford '),
          TextSpan(
            text: r'$' '${affordAmount.toStringAsFixed(0)}',
            style: boldLabel,
          ),
          const TextSpan(text: ' worth of car with a down payment of '),
          TextSpan(
            text: r'$'
                '${((((downPercent) / 100)) * affordAmount).toStringAsFixed(0)}',
            style: boldLabel,
          ),
          const TextSpan(text: '. Your monthly payment would be '),
          TextSpan(
            text: r'$' '${monthlyPayment.toStringAsFixed(0)}',
            style: boldLabel,
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }
}

class PretaxIncomRateLabel extends StatelessWidget {
  const PretaxIncomRateLabel({
    super.key,
    required this.incomeCap,
  });

  final double incomeCap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = theme.textTheme.headlineSmall;
    final boldLabel = label?.copyWith(
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
  const PayoffTimeLabel({
    super.key,
    required this.numberOfMonths,
  });

  final int numberOfMonths;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = theme.textTheme.headlineSmall;
    final boldLabel = label?.copyWith(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );
    return Text.rich(
      TextSpan(
        style: label,
        children: [
          TextSpan(
            text: '$numberOfMonths',
            style: boldLabel,
          ),
          const TextSpan(text: ' months to pay off.'),
        ],
      ),
    );
  }
}

class PercentDownLabel extends StatelessWidget {
  const PercentDownLabel({
    super.key,
    required this.downPercent,
  });

  final double downPercent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = theme.textTheme.headlineSmall;
    final boldLabel = label?.copyWith(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );
    return Text.rich(
      TextSpan(
        style: label,
        children: [
          TextSpan(
            text: '${(downPercent).toInt()}%',
            style: boldLabel,
          ),
          const TextSpan(text: ' down.'),
        ],
      ),
    );
  }
}
