import 'package:car_payment/car_payment_notifier.dart';
import 'package:car_payment/label_widgets.dart';
import 'package:context_plus/context_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
          return IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PercentDownLabel(downPercent: $carPayment.downPercent),
                ShadSeparator.vertical(),
                PayoffTimeLabel(numberOfMonths: $carPayment.numberOfMonths),
                ShadSeparator.vertical(),
                PretaxIncomeRateLabel(incomeCap: $carPayment.incomeCap),
              ],
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PercentDownLabel(downPercent: downPercent),
            PayoffTimeLabel(numberOfMonths: numberOfMonths),
            PretaxIncomeRateLabel(incomeCap: incomeCap),
          ],
        );
      },
    );
  }
}
