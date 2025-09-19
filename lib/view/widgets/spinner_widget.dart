import 'package:flutter/material.dart';

class SpinnerWidget extends StatelessWidget {
  const SpinnerWidget({super.key, this.size, this.value, this.color});

  final double? size;
  final double? value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(strokeWidth: 1.0, strokeCap: StrokeCap.round, color: color),
    );
  }
}
