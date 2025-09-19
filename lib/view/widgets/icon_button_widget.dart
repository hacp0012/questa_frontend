import 'package:flutter/material.dart';
import 'package:questa/configs/c_consts.dart';

class IconButtonWidget extends StatelessWidget {
  const IconButtonWidget({super.key, required this.icon, this.onPressed, this.isBlack = false});
  final Widget icon;
  final VoidCallback? onPressed;
  final bool isBlack;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      icon: icon,
      onPressed: onPressed,
      style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(isBlack ? CConsts.SECONDARY_COLOR : CConsts.LIGHT_COLOR)),
    );
  }
}
