import 'dart:math';

import 'package:car_payment/finance_helpers.dart';
import 'package:flutter/widgets.dart';

final $carPayment = CarPaymentNotifier();

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
