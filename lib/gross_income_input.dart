import 'package:car_payment/car_payment_notifier.dart';
import 'package:car_payment/currency_text_editing_controller.dart';
import 'package:car_payment/main.dart';
import 'package:context_plus/context_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class GrossIncomeInput extends StatefulWidget {
  const GrossIncomeInput({super.key});

  @override
  State<GrossIncomeInput> createState() => _GrossIncomeInputState();
}

class _GrossIncomeInputState extends State<GrossIncomeInput> {
  final controller = CurrencyTextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  void listener() {
    $carPayment.grossIncomeChange(controller.text.replaceAll(',', ''));
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final annualGrossIncome = $carPayment.watchOnly(
      context,
      (x) => x.annualGrossIncome,
    );
    return Column(
      children: [
        Text('$annualGrossIncome'),
        ShadInput(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          placeholder: const Text('Annual Gross Income'),
          prefix: Text(r'$', style: ShadTheme.of(context).textTheme.muted),
          decoration: errorWhenNull(annualGrossIncome, context),
        ),
      ],
    );
  }
}
