import 'package:flutter/material.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/view/theme/theme_configs.dart';

class TcButtonsLight {
  static ButtonStyle blackButtonTheme = ButtonStyle(
    backgroundColor: WidgetStateProperty.all<Color>(ThemeConfigs.lightTheme.colorScheme.secondary),
    foregroundColor: WidgetStateProperty.all<Color>(ThemeConfigs.lightTheme.colorScheme.onSecondary),
  );
  static ButtonStyle outlinedButton = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(CConsts.LIGHT_COLOR),
    side: WidgetStatePropertyAll(BorderSide(color: CConsts.COLOR_GREY_LIGHT)),
  );
}

class TcButtonDark {
  //
}
