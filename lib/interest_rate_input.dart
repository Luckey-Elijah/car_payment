import 'package:car_payment/car_payment_notifier.dart';
import 'package:car_payment/decimal_text_editing_controller.dart';
import 'package:car_payment/error_when_null.dart';
import 'package:car_payment/first_focus.dart';
import 'package:context_plus/context_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class InterestRateInput extends StatefulWidget {
  const InterestRateInput({super.key});

  @override
  State<InterestRateInput> createState() => _InterestRateInputState();
}

class _InterestRateInputState extends State<InterestRateInput> with FirstFocus {
  late final DecimalTextEditingController controller = DecimalTextEditingController('8.0')
    ..addListener(() => $carPayment.interestRateChange(controller.text));

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (!focusNode.hasFocus && controller.text.endsWith('.')) {
        controller.text = '${controller.text}00';
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final interestRate = $carPayment.watchOnly(context, (x) => x.interestRate);
    final decoration = errorWhenNull(interestRate, context);
    return ShadInput(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      placeholder: const Text('Interest Rate'),
      trailing: Icon(LucideIcons.percent),
      decoration: first ? null : decoration,
    );
  }
}
