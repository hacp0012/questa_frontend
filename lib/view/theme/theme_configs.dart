import 'package:flutter/material.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/view/theme/configs/tc_text_input.dart';

class ThemeConfigs {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: CConsts.FONT_ALBERT,
    colorScheme: ColorScheme.fromSeed(
      seedColor: CConsts.PRIMARY_COLOR,
      // primary: CConsts.PRIMARY_COLOR,
      secondary: CConsts.SECONDARY_COLOR,
      surface: Color(0xffF1F0F0),
    ),
    brightness: Brightness.light,

    // CONFIGS.
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(CConsts.COLOR_GREEN_LIGHT),
        foregroundColor: WidgetStateProperty.all<Color>(CConsts.SECONDARY_COLOR),
        visualDensity: VisualDensity.compact,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        side: WidgetStatePropertyAll(BorderSide(color: CConsts.COLOR_GREY_LIGHT)),
        visualDensity: VisualDensity.compact,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(CConsts.LIGHT_COLOR),
        // side: WidgetStatePropertyAll(BorderSide(color: CConsts.COLOR_GREY_LIGHT)),
      ),
    ),
    inputDecorationTheme: TcTextInput.light,
    bottomSheetTheme: BottomSheetThemeData(
      modalBarrierColor: CConsts.SECONDARY_COLOR.withAlpha(63),
      backgroundColor: CConsts.COLOR_SURFACE,
      elevation: 27,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.vertical(top: Radius.elliptical(207, 9)),
        // borderRadius: BorderRadiusGeometry.only(topRight: Radius.circular(18), topLeft: Radius.circular(18)),
      ),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      surfaceTintColor: CConsts.COLOR_SURFACE.withAlpha(207),
      backgroundColor: Color(0xffF1F0F0).withAlpha(207),
      actionsPadding: EdgeInsets.only(right: 12),
    ),
    chipTheme: ChipThemeData(
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(18)),
      backgroundColor: CConsts.LIGHT_COLOR,
      padding: EdgeInsets.all(6.6),
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStatePropertyAll(CConsts.SECONDARY_COLOR),
      fillColor: WidgetStatePropertyAll(CConsts.LIGHT_COLOR),
      visualDensity: VisualDensity.compact,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(6.3)),
      side: BorderSide(color: CConsts.COLOR_GREY_LIGHT),
    ),
    shadowColor: CConsts.SECONDARY_COLOR.withAlpha(108),
    dialogTheme: DialogThemeData(
      backgroundColor: CConsts.LIGHT_COLOR,
      barrierColor: CConsts.SECONDARY_COLOR.withAlpha(63),
      elevation: 27,
      shadowColor: CConsts.SECONDARY_COLOR.withAlpha(72),
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12)),
    ),
    popupMenuTheme: PopupMenuThemeData(
      surfaceTintColor: CConsts.LIGHT_COLOR,
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12)),
    ),
    menuTheme: MenuThemeData(
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(CConsts.LIGHT_COLOR),
        surfaceTintColor: WidgetStatePropertyAll(CConsts.LIGHT_COLOR),
        elevation: WidgetStatePropertyAll(12),
        shadowColor: WidgetStatePropertyAll(CConsts.SECONDARY_COLOR.withAlpha(72)),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12))),
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: CConsts.LIGHT_COLOR,
      elevation: 12,
      shadowColor: CConsts.SECONDARY_COLOR.withAlpha(72),
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12)),
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: CConsts.LIGHT_COLOR,
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12)),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: CConsts.PRIMARY_COLOR,
    brightness: Brightness.dark,
  );
}
