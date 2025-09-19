import 'package:flutter/material.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/modules/extensions_utils_packs.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key, this.alignment = TextAlign.center, this.child, this.thickness = 1, this.gap = 9});
  final TextAlign alignment;
  final Widget? child;
  final double thickness;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (child == null)
          Expanded(
            child: Divider(color: CConsts.COLOR_GREY_LIGHT, thickness: thickness),
          )
        else if (alignment == TextAlign.start) ...[
          child ?? Container(),
          (gap).gap,
          Expanded(
            child: Divider(color: CConsts.COLOR_GREY_LIGHT, thickness: thickness),
          ),
        ] else if (alignment == TextAlign.center) ...[
          Expanded(
            child: Divider(color: CConsts.COLOR_GREY_LIGHT, thickness: thickness),
          ),
          (gap).gap,
          child ?? Container(),
          (gap).gap,
          Expanded(
            child: Divider(color: CConsts.COLOR_GREY_LIGHT, thickness: thickness),
          ),
        ] else if (alignment == TextAlign.left) ...[
          Expanded(
            child: Divider(color: CConsts.COLOR_GREY_LIGHT, thickness: thickness),
          ),
          (gap).gap,
          child ?? Container(),
        ],
      ],
    );
  }
}
