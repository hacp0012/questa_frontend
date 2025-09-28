import 'package:flutter/material.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:run_it/run_it.dart';

class ChipWidget extends StatelessWidget {
  const ChipWidget({
    super.key,
    required this.child,
    this.color,
    this.padding,
    this.margin,
    this.useInkwell = false,
    this.onPressed,
  });
  final Widget child;
  final Color? color;
  final bool useInkwell;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(3.9),
      margin: margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(color: color ?? CConsts.LIGHT_COLOR, borderRadius: BorderRadius.circular(24)),
      child: child,
    ).run((it) {
      if (onPressed != null) return it.cursorClick(inkwell: useInkwell, onClick: onPressed);
      return it;
    });
  }
}
