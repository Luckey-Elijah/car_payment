import 'dart:math';

import 'package:car_payment/finance_helpers.dart';
import 'package:car_payment/label_widgets.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      title: 'How much car can you afford?',
      home: const CarPaymentCalculator(),
    );
  }
}

class CarPaymentCalculator extends StatefulWidget {
  const CarPaymentCalculator({super.key});

  @override
  State<CarPaymentCalculator> createState() => _CarPaymentCalculatorState();
}

class _CarPaymentCalculatorState extends State<CarPaymentCalculator> {
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

  String? errorMessageIfNull(Object? value, [String? message]) {
    if (value == null) return message ?? 'Please enter a number.';
    return null;
  }

  void grossIncomeChange(String value) {
    setState(() => annualGrossIncome = double.tryParse(value));
  }

  void interestRateChange(String value) {
    var parsed = double.tryParse(value);
    setState(() {
      if (parsed != null && parsed <= 0) {
        interestRate = null;
      } else {
        interestRate = parsed;
      }
    });
  }

  void numberOfPaymentsChange(String value) {
    setState(() => currentMonthlyPayments = double.tryParse(value) ?? 0);
  }

  void percentDownChange(String value) {
    setState(() => downPercent = double.tryParse(value) ?? 20);
  }

  void termChange(String value) {
    setState(() => numberOfMonths = int.tryParse(value) ?? 36);
  }

  void percentIncomeChange(String value) {
    setState(() => incomeCap = (double.tryParse(value) ?? 8) / 100);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox.square(dimension: 16),
          TextField(
            autofocus: true,
            onChanged: grossIncomeChange,
            decoration: InputDecoration(
              errorText: errorMessageIfNull(annualGrossIncome),
              prefixText: r'$',
              labelText: 'Annual Gross Income',
            ),
          ),
          const SizedBox.square(dimension: 16),
          TextField(
            onChanged: interestRateChange,
            decoration: InputDecoration(
              errorText: errorMessageIfNull(
                  interestRate, 'Please enter a number greater than 0.'),
              labelText: 'Interest Rate',
              suffixText: '%',
            ),
          ),
          const SizedBox.square(dimension: 16),
          TextField(
            onChanged: numberOfPaymentsChange,
            decoration: const InputDecoration(
              prefixText: r'$',
              labelText: 'Current Monthly Car Payments',
            ),
          ),
          const SizedBox.square(dimension: 16),
          ExpansionTile(
            title: Text(
              'Adjust more...',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: percentDownChange,
                        decoration: const InputDecoration(
                          suffixText: r'%',
                          labelText: 'Percent Down (20%)',
                        ),
                      ),
                    ),
                    const SizedBox.square(dimension: 16),
                    Expanded(
                      child: TextField(
                        onChanged: termChange,
                        decoration: const InputDecoration(
                          labelText: 'Term Length in months (36)',
                        ),
                      ),
                    ),
                    const SizedBox.square(dimension: 16),
                    Expanded(
                      child: TextField(
                        onChanged: percentIncomeChange,
                        decoration: const InputDecoration(
                          suffixText: r'%',
                          labelText: '% of pre-tax income (8%)',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox.square(dimension: 16),
          PercentDownLabel(downPercent: downPercent),
          PayoffTimeLabel(numberOfMonths: numberOfMonths),
          PretaxIncomRateLabel(incomeCap: incomeCap),
          const Divider(),
          CarAffordableResultsLabel(
            affordAmount: affordAmount,
            downPercent: downPercent,
            monthlyPayment: monthlyPayment,
          ),
        ],
      ),
    );
  }
}
