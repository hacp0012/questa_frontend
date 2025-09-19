import 'package:flutter/material.dart';
import 'package:questa/configs/c_consts.dart';

class CustomOtpFieldWidget extends StatelessWidget {
  CustomOtpFieldWidget({
    super.key,
    this.values = const [],
    this.length = 4,
    this.obscureText = false,
    this.width,
    this.height,
    this.spaceBetween,
    this.onSet,
  });

  final bool obscureText;
  final int length;
  final List<String> values;
  final double? width;
  final double? height;
  final double? spaceBetween;
  final Function(List<String> setedsValues)? onSet;

  final List<Widget> _items = [];

  // COMPONENT. //////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    init();

    return Row(spacing: spaceBetween ?? 9, mainAxisAlignment: MainAxisAlignment.center, children: _items);
  }

  // METHODS. oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
  void init() {
    List<String> setedsValues = [];
    for (int i = 0; i < length; i++) {
      String? value = values.elementAtOrNull(i);

      if (value != null) setedsValues.add(value);
      if (obscureText) {
        _items.add(item(value != null ? '•' : ''));
        continue;
      } else {
        _items.add(item(value ?? ''));
      }
    }
    onSet?.call(setedsValues);
  }

  Widget item(String value) {
    return Card.outlined(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9 / 1),
        side: BorderSide(color: value.isEmpty ? Colors.grey.shade300 : CConsts.SECONDARY_COLOR, width: 2),
      ),
      margin: EdgeInsets.zero,
      child: SizedBox(
        height: height ?? 40,
        width: width ?? 40,
        child: Center(
          child: Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: obscureText ? 27 : 18),
          ),
        ),
      ),
    );
  }
}
