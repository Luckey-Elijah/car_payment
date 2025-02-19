import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

ShadDecoration? errorWhenNull(double? value, BuildContext context) {
  if (value == null) {
    return ShadDecoration(
      border: ShadBorder.all(
        color:
            value == null
                ? ShadTheme.of(context).colorScheme.destructive
                : null,
      ),
    );
  }
  return null;
}
