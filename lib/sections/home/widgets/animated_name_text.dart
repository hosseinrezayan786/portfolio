import 'dart:async';

import 'package:flutter/material.dart';

class AnimatedNameText extends StatefulWidget {
  final String text;
  TextStyle style;
  TextAlign textAlign;
  final VoidCallback? onCompleted;
  AnimatedNameText({
    super.key,
    required this.text,
    required this.style,
    this.textAlign = TextAlign.start,
    this.onCompleted,
  });

  @override
  State<AnimatedNameText> createState() => _AnimatedNameTextState();
}

class _AnimatedNameTextState extends State<AnimatedNameText> {
  late int _visibleChars;
  Timer? _charTimer;
  bool _hasCompleted = false;

  void _startAnimation() {
    const startDelay = Duration(milliseconds: 500);
    Future.delayed(startDelay, () {
      if (!mounted) return;

      _scheduleNextChar();
    });
  }

  void _scheduleNextChar() {
    if (_visibleChars >= widget.text.length) {
      if (!_hasCompleted) {
        _hasCompleted = true;
        widget.onCompleted?.call();
      }
      return;
    }

    _charTimer?.cancel();
    _charTimer = Timer(Duration(milliseconds: 130), () {
      if (!mounted) return;
      setState(() {
        _visibleChars = (_visibleChars + 1)
            .clamp(0, widget.text.length)
            .toInt();
      });
      _scheduleNextChar();
    });
  }

  @override
  void initState() {
    _visibleChars = 0;
    // TODO: implement initState
    super.initState();
    _startAnimation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _charTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final displayText = widget.text.substring(0, _visibleChars);
    return Text.rich(
      TextSpan(children: [TextSpan(text: displayText)]),

      style: widget.style,
      textAlign: widget.textAlign,
    );
  }
}
