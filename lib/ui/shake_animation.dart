import 'package:flutter/material.dart';

class ShakeAnimation extends StatefulWidget {
  const ShakeAnimation({
    Key? key,
    required this.isShaking,
    required this.child,
    required this.shakeDistance,
    required this.shakeSpeed,
  }) : super(key: key);

  final bool isShaking;
  final Widget child;
  final double shakeDistance;
  final Duration shakeSpeed;

  @override
  _ShakeAnimationState createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<ShakeAnimation> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.shakeSpeed);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset((widget.shakeDistance * _controller.value) - widget.shakeDistance / 2, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }

  @override
  void didUpdateWidget(covariant ShakeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isShaking != oldWidget.isShaking) {
      if (widget.isShaking) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
