import 'package:car_payment/adjust_more_section.dart';
import 'package:car_payment/car_payment_notifier.dart';
import 'package:car_payment/details_summary_section.dart';
import 'package:car_payment/gross_income_input.dart';
import 'package:car_payment/hline.dart';
import 'package:car_payment/interest_rate_input.dart';
import 'package:car_payment/label_widgets.dart';
import 'package:car_payment/monthly_car_payment_input.dart';
import 'package:car_payment/url.dart';
import 'package:context_plus/context_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CarPaymentCalculator extends StatelessWidget {
  const CarPaymentCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    final $ = $carPayment;
    final affordAmount = $.watchOnly(context, (x) => x.affordAmount);
    final downPercent = $.watchOnly(context, (x) => x.downPercent);
    final monthlyPayment = $.watchOnly(context, (x) => x.monthlyPayment);
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.all(8),
          child: ShadCard(
            child: Center(
              child: SizedBox(
                width: 640,
                child: Column(
                  children: [
                    GrossIncomeInput(),
                    InterestRateInput(),
                    MonthlyCarPaymentInput(),
                    AdjustMoreSection(),
                  ],
                ),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8),
          child: ShadCard(
            child: Center(
              child: SizedBox(
                width: 640,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const DetailsSummarySection(),
                    const HLine(),
                    CarAffordableResultsLabel(
                      monthlyPayment: monthlyPayment,
                      affordAmount: affordAmount,
                      downPercent: downPercent,
                    ),
                    const WebReferenceLinkButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
