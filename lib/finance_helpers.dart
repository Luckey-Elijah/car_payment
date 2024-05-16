import 'dart:math';

double loanAmount({
  required double monthlyPayment,
  required double interestRate,
  required int months,
}) {
  return (monthlyPayment / interestRate) *
      (1 - (1 / (pow(1 + interestRate, months))));
}

double calculateAffordableAmount({
  required double annualGrossIncome,
  required double interestRate,
  required double currentMonthlyPayments,
  required double downPercent,
  required double incomeCap,
  required int numberOfMonths,
}) {
  final rate = interestRate / 12 / 100;
  final basePayment = (annualGrossIncome / 12) * incomeCap;
  final downRate = (1 - (downPercent / 100));
  final loan = loanAmount(
    interestRate: rate,
    months: numberOfMonths,
    monthlyPayment: max(basePayment - currentMonthlyPayments, 0),
  );
  return loan / downRate;
}
