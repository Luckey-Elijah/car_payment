import 'package:car_payment/car_payment_notifier.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class TermLengthInput extends StatelessWidget {
  const TermLengthInput({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadInput(
      keyboardType: TextInputType.number,
      onChanged: $carPayment.termChange,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      placeholder: const Text('Term Length in months (36)'),
    );
  }
}
