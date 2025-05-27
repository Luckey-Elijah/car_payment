import 'package:car_payment/car_payment_notifier.dart';
import 'package:car_payment/decimal_text_editing_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PercentDownInput extends StatefulWidget {
  const PercentDownInput({super.key});

  @override
  State<PercentDownInput> createState() => _PercentDownInputState();
}

class _PercentDownInputState extends State<PercentDownInput> {
  final controller = DecimalTextEditingController('20.0');

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShadInput(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: $carPayment.percentDownChange,
      trailing: Icon(LucideIcons.percent),
      placeholder: const Text('percent down'),
    );
  }
}
