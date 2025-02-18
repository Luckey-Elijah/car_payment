import 'package:flutter/widgets.dart';

class CurrencyTextEditingController extends TextEditingController {
  CurrencyTextEditingController() {
    addListener(_formatInput);
  }

  void _formatInput() {
    final text = value.text;
    if (text.isEmpty) return;

    final newText = _formatCurrency(text);
    if (newText != text) {
      value = value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
  }

  String _formatCurrency(String input) {
    final buffer = StringBuffer();
    final digits = input.replaceAll(RegExp(r'[^\d]'), '');
    for (int i = 0; i < digits.length; i++) {
      if (i != 0 && (digits.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  @override
  void dispose() {
    removeListener(_formatInput);
    super.dispose();
  }
}
