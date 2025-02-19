import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HLine extends StatelessWidget {
  const HLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ShadDecorator(
        decoration: ShadDecoration(
          border: ShadBorder(
            top: ShadBorderSide(
              width: 1,
              color: ShadTheme.of(context).colorScheme.border,
            ),
          ),
        ),
      ),
    );
  }
}
