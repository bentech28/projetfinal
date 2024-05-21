import 'package:flutter/material.dart';

class WhiteText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;

  const WhiteText(
      this.data, {
        Key? key,
        this.style,
        this.textAlign,
        this.textDirection,
        this.softWrap,
        this.overflow,
        this.textScaleFactor,
        this.maxLines,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: const TextStyle(color: Colors.white).merge(style),
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}