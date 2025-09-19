import 'package:flutter/material.dart';
import 'package:questa/configs/c_consts.dart';

class TcTextInput {
  static InputDecorationTheme light = InputDecorationTheme(
    isDense: true,
    filled: true,
    alignLabelWithHint: true,
    fillColor: CConsts.LIGHT_COLOR,
    contentPadding: const EdgeInsets.all(9.3),
    border: OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      gapPadding: 3.0,
      borderSide: BorderSide(color: CConsts.COLOR_GREY_LIGHT, width: 1),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      gapPadding: 3.0,
      borderSide: const BorderSide(color: Colors.transparent, style: BorderStyle.none, width: 3),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      gapPadding: 3.0,
      borderSide: const BorderSide(color: CConsts.PRIMARY_COLOR),
    ),
    hintStyle: const TextStyle(fontSize: null, fontFamily: CConsts.FONT_INTER),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      gapPadding: 3.0,
      borderSide: const BorderSide(color: CConsts.SECONDARY_COLOR, width: 1),
    ),
  );

  static InputDecorationTheme dark = InputDecorationTheme(
    isDense: true,
    filled: true,
    alignLabelWithHint: true,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(9), gapPadding: 1.0),
    contentPadding: const EdgeInsets.all(9),
    hintStyle: const TextStyle(fontSize: (9 * 2) - 1, fontWeight: FontWeight.w300),
  );
}
