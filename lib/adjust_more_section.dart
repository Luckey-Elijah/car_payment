import 'package:car_payment/percent_down_input.dart';
import 'package:car_payment/percent_income_input.dart';
import 'package:car_payment/term_length_input.dart';
import 'package:flutter/widgets.dart';

class AdjustMoreSection extends StatelessWidget {
  const AdjustMoreSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
    );
  }
}
