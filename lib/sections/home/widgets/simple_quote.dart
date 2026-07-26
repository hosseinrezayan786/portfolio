import 'package:flutter/material.dart';

class SimpleQuote extends StatefulWidget {
  const SimpleQuote({
    super.key,
    required this.text,
    required this.style,

    this.textAlign = TextAlign.start,
  });

  final String text;
  final TextStyle style;
  final TextAlign textAlign;

  @override
  State<SimpleQuote> createState() => _SimpleQuoteState();
}

class _SimpleQuoteState extends State<SimpleQuote> {
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: widget.textAlign,
      text: TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: Text(widget.text, style: widget.style),
          ),
        ],
      ),
    );
  }
}
