import 'package:flutter/widgets.dart';

class DecimalTextEditingController extends TextEditingController {
  DecimalTextEditingController([String? text]) {
    addListener(_formatDecimal);
    if (text != null) super.text = text;
  }

  void _formatDecimal() {
    final text = this.text;
    final filtered = text.replaceAll(RegExp(r'[^0-9.]'), '').split('.').take(2).join('.');

    if (filtered != text) {
      final selectionIndex = selection.baseOffset - (text.length - filtered.length);
      this.text = filtered;
      selection = TextSelection.collapsed(
        offset: selectionIndex.clamp(0, filtered.length),
      );
    }
  }

  @override
  void dispose() {
    removeListener(_formatDecimal);
    super.dispose();
  }
}
