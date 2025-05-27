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
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: PercentDownLabel(downPercent: $carPayment.downPercent)),
                  ),
                ),
                ShadSeparator.vertical(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: PayoffTimeLabel(numberOfMonths: $carPayment.numberOfMonths),
                    ),
                  ),
                ),
                ShadSeparator.vertical(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: PretaxIncomeRateLabel(incomeCap: $carPayment.incomeCap)),
                  ),
                ),
              ],
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _WithDot(PercentDownLabel(downPercent: downPercent)),
            _WithDot(PayoffTimeLabel(numberOfMonths: numberOfMonths)),
            _WithDot(PretaxIncomeRateLabel(incomeCap: incomeCap)),
          ],
        );
      },
    );
  }
}

class _WithDot extends StatelessWidget {
  const _WithDot(this.child, {super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final style = ShadTheme.of(context).textTheme.p;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: DecoratedBox(
            decoration: BoxDecoration(shape: BoxShape.circle, color: style.color),
            child: SizedBox.square(dimension: (style.fontSize ?? 16.0) / 3),
          ),
        ),
        child,
      ],
    );
  }
}
