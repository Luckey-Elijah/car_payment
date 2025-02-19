import 'package:flutter/widgets.dart';

mixin FirstFocus<T extends StatefulWidget> on State<T> {
  final focusNode = FocusNode();
  bool _hadFocus = false;
  bool first = true;

  void focusListener() {
    if (_hadFocus && !focusNode.hasFocus) {
      setState(() => first = false);
    } else if (!_hadFocus) {
      setState(() => _hadFocus = focusNode.hasFocus);
    }
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(focusListener);
  }

  @override
  void dispose() {
    focusNode
      ..removeListener(focusListener)
      ..dispose();
    super.dispose();
  }
}
