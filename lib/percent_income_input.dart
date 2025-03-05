import 'package:car_payment/car_payment_notifier.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PercentIncomeInput extends StatelessWidget {
  const PercentIncomeInput({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadInput(
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: $carPayment.percentIncomeChange,
      leading: Text('%', style: ShadTheme.of(context).textTheme.muted),
      placeholder: const Text('% of pre-tax income (8%)'),
    );
  }
}
