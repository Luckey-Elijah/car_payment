import 'package:car_payment/car_payment_notifier.dart';
import 'package:car_payment/currency_text_editing_controller.dart';
import 'package:car_payment/error_when_null.dart';
import 'package:car_payment/first_focus.dart';
import 'package:context_plus/context_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class GrossIncomeInput extends StatefulWidget {
  const GrossIncomeInput({super.key});

  @override
  State<GrossIncomeInput> createState() => _GrossIncomeInputState();
}

class _GrossIncomeInputState extends State<GrossIncomeInput> with FirstFocus {
  final controller = CurrencyTextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
    controller.text = '80000';
  }

  void listener() {
    $carPayment.grossIncomeChange(controller.text.replaceAll(',', ''));
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
    final annualGrossIncome = $carPayment.watchOnly(
      context,
      (x) => x.annualGrossIncome,
    );

    var decoration = errorWhenNull(annualGrossIncome, context);
    return ShadInput(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      placeholder: const Text('Annual Gross Income'),
      leading: Text(r'$', style: ShadTheme.of(context).textTheme.muted),
      decoration: first ? null : decoration,
    );
  }
}
