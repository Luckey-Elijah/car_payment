import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class BgAndDefaultTextWrapper extends StatelessWidget {
  const BgAndDefaultTextWrapper({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ShadTheme.of(context).colorScheme.background,
      child: DefaultTextStyle(
        style: ShadTheme.of(context).textTheme.p,
        child: child,
      ),
    );
  }
}
