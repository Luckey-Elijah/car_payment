import 'package:car_payment/car_payment_notifier.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PercentDownInput extends StatelessWidget {
  const PercentDownInput({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadInput(
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: $carPayment.percentDownChange,
      suffix: Text('%', style: ShadTheme.of(context).textTheme.muted),
      placeholder: const Text('Percent down (20% default)'),
    );
  }
}
