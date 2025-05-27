import 'package:car_payment/adjust_more_section.dart';
import 'package:car_payment/car_payment_notifier.dart';
import 'package:car_payment/details_summary_section.dart';
import 'package:car_payment/gross_income_input.dart';
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
    const dimension = 8.0;

    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(dimension),
          child: ShadCard(
            padding: EdgeInsets.zero,
            child: Center(
              child: Column(
                spacing: dimension,
                children: [
                  SizedBox(height: dimension),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: dimension),
                    child: GrossIncomeInput(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: dimension),
                    child: InterestRateInput(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: dimension),
                    child: MonthlyCarPaymentInput(),
                  ),
                  ShadSeparator.horizontal(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: dimension),
                    child: AdjustMoreSection(),
                  ),
                  SizedBox(height: dimension),
                ],
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(dimension),
          child: ShadCard(
            padding: EdgeInsets.zero,
            child: Center(
              child: SizedBox(
                width: 640,
                child: Column(
                  children: [
                    const DetailsSummarySection(),
                    ShadSeparator.horizontal(),
                    Padding(
                      padding: const EdgeInsets.all(dimension),
                      child: CarAffordableResultsLabel(
                        monthlyPayment: monthlyPayment,
                        affordAmount: affordAmount,
                        downPercent: downPercent,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(dimension),
                      child: const WebReferenceLinkButton(),
                    ),
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
