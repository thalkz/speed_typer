import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlayerKeyboardListener extends StatefulWidget {
  const PlayerKeyboardListener({
    Key? key,
    required this.child,
    required this.onInputKey,
    required this.onStart,
    required this.onStop,
  }) : super(key: key);

  final Widget child;
  final Function(String) onInputKey;
  final Function() onStart;
  final Function() onStop;

  @override
  _PlayerKeyboardListenerState createState() => _PlayerKeyboardListenerState();
}

class _PlayerKeyboardListenerState extends State<PlayerKeyboardListener> {
  late FocusNode _node;
  late FocusAttachment _nodeAttachment;

  @override
  void initState() {
    super.initState();
    _node = FocusNode(debugLabel: 'KeyboardListener');
    _nodeAttachment = _node.attach(context, onKey: _handleKeyPress);
  }

  KeyEventResult _handleKeyPress(FocusNode node, RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey.keyLabel.length == 1) {
        widget.onInputKey(event.logicalKey.keyLabel);
        return KeyEventResult.handled;
      } else if (event.logicalKey.keyLabel == 'Enter') {
        widget.onStart();
        return KeyEventResult.handled;
      } else if (event.logicalKey.keyLabel == 'Escape') {
        widget.onStop();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    _nodeAttachment.reparent();
    _node.requestFocus();
    return widget.child;
  }
}
