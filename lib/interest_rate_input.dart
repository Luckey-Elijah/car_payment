import 'package:car_payment/car_payment_notifier.dart';
import 'package:car_payment/error_when_null.dart';
import 'package:car_payment/first_focus.dart';
import 'package:context_plus/context_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class InterestRateInput extends StatefulWidget {
  const InterestRateInput({super.key});

  @override
  State<InterestRateInput> createState() => _InterestRateInputState();
}

class _InterestRateInputState extends State<InterestRateInput> with FirstFocus {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
    controller.text = '8';
  }

  void listener() {
    $carPayment.interestRateChange(controller.text);
  }

  @override
  void dispose() {
    controller
      ..removeListener(listener)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final interestRate = $carPayment.watchOnly(context, (x) => x.interestRate);
    var decor = errorWhenNull(interestRate, context);
    return ShadInput(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      onChanged: $carPayment.interestRateChange,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      placeholder: const Text('Interest Rate'),
      trailing: Text('%', style: ShadTheme.of(context).textTheme.muted),
      decoration: first ? null : decor,
    );
  }
}
