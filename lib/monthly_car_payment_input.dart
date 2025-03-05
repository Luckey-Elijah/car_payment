import 'package:car_payment/car_payment_notifier.dart';
import 'package:car_payment/currency_text_editing_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MonthlyCarPaymentInput extends StatefulWidget {
  const MonthlyCarPaymentInput({super.key});

  @override
  State<MonthlyCarPaymentInput> createState() => _MonthlyCarPaymentInputState();
}

class _MonthlyCarPaymentInputState extends State<MonthlyCarPaymentInput> {
  final controller = CurrencyTextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  void listener() {
    $carPayment.numberOfPaymentsChange(controller.text.replaceAll(',', ''));
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShadInput(
      controller: controller,
      keyboardType: TextInputType.number,
      leading: Text(r'$', style: ShadTheme.of(context).textTheme.muted),
      placeholder: const Text('Current Monthly Car Payments'),
    );
  }
}
