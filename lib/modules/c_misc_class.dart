import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/modules/extensions_utils_packs.dart';

class CMiscClass {
  /// Return [T] when brightness of [context] is [light] or when is [dark]
  /// otherwise return [null].
  static T? whenBrightnessOf<T>(BuildContext context, {T? light, T? dark}) {
    return Theme.of(context).brightness == Brightness.light ? light : dark;
  }

  static T? match<R, T>(R value, Map<R, T> matchs) {
    return matchs[value];
  }

  static PrintableDateHandler date(DateTime dateTime) => PrintableDateHandler(dateTime);

  static String numberAbrev(double number) {
    String symbole = '';

    if (number < 1e3) {
      symbole = '';
    } else if (number < 1e6) {
      symbole = 'K';
      number /= 1e3;
    } else if (number < 1e9) {
      symbole = 'M';
      number /= 1e6;
    } else {
      symbole = 'B';
      number /= 1e9;
    }

    String numberStr = number.toString();
    List<String> splited = numberStr.split(RegExp(r'[.]'));

    if (splited.length == 2) {
      String first = splited[1][0];

      if (first != '0') {
        numberStr = [splited[0], first].join('.');
      } else {
        numberStr = splited[0];
      }
    }

    return "$numberStr$symbole";
  }

  /// Return [{'months': month, 'days': days, 'hours': hours, 'minutes': minutes, 'seconds': seconds}]
  static Map<String, int> readableDuration({required int durationInSeconds}) {
    int formula(int unit, int time) {
      if (time > unit) {
        double r = time / unit;
        int q = r.floor();
        int t = q * unit;
        return time - t;
      }
      return time;
    }

    Duration duration = Duration(seconds: durationInSeconds);

    int monthsUnit = 12;
    int daysUnit = 30;
    int hoursUnit = 24;
    int minutesUnit = 60;
    int secondsUnit = 60;

    int month = formula(monthsUnit, duration.inDays);
    int days = formula(daysUnit, duration.inDays);
    int hours = formula(hoursUnit, duration.inHours);
    int minutes = formula(minutesUnit, duration.inMinutes);
    int seconds0 = formula(secondsUnit, duration.inSeconds);

    return {'months': month, 'days': days, 'hours': hours, 'minutes': minutes, 'seconds': seconds0};
  }

  static FilteringTextInputFormatter doubleInputFormater() => FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,18}'));

  static FilteringTextInputFormatter intInputFormater({int? length}) =>
      FilteringTextInputFormatter.allow(RegExp(r'^\d' + (length == null ? '+' : "{0,$length}")));

  /// Rmove all markdown spacial characters : * _ \n
  static String remeveMarkdownSymboles(String text) {
    String newText = text.replaceAll(RegExp(r"[_*]"), '');

    return newText;
  }

  static MenuStyle anchorMenuStyle(BuildContext context) {
    return MenuStyle(
      elevation: WidgetStatePropertyAll(18),
      backgroundColor: WidgetStatePropertyAll(context.theme.colorScheme.surface.onDark(context, CConsts.SECONDARY_COLOR)),
    );
  }
}

class PrintableDateHandler {
  final DateTime dateTime;

  PrintableDateHandler(this.dateTime);

  /// 11 Avr 2024
  String sementic({String format = '{day} {month} {year}'}) {
    Map<int, String> months = {
      1: 'Jan',
      2: 'Fév',
      3: 'Mars',
      4: 'Avr',
      5: 'Mai',
      6: 'Juin',
      7: 'Juil',
      8: 'Aout',
      9: 'Sep',
      10: 'Oct',
      11: 'Nov',
      12: 'Déc',
    };

    String date = format.replaceAll('{day}', dateTime.day.toString());
    date = date.replaceAll('{month}', months[dateTime.month]!).padLeft(2, '0');
    date = date.replaceAll('{year}', dateTime.year.toString());
    date = date.replaceAll('{houre}', dateTime.hour.toString().padLeft(2, '0'));
    date = date.replaceAll('{minute}', dateTime.minute.toString().padLeft(2, '0'));
    date = date.replaceAll('{second}', dateTime.second.toString().padLeft(2, '0'));

    return date;
  }

  /// 11/04/2024
  String numeric({String? format, String seperator = '/'}) {
    format ??= "{day}$seperator{month}$seperator{year}";
    String date = format.replaceAll('{day}', dateTime.day.toString().padLeft(2, '0'));
    date = date.replaceAll('{month}', dateTime.month.toString().padLeft(2, '0'));
    date = date.replaceAll('{year}', dateTime.year.toString());
    date = date.replaceAll('{hour}', dateTime.hour.toString().padLeft(2, '0'));
    date = date.replaceAll('{minute}', dateTime.minute.toString().padLeft(2, '0'));
    date = date.replaceAll('{second}', dateTime.second.toString().padLeft(2, '0'));

    return date;
  }

  /// il y a 15 jours|maintenent
  String ago({bool clean = false}) {
    DateTime now = DateTime.now();

    Duration diference = now.difference(dateTime);

    String date = '';

    if (diference.inMinutes < 2) {
      date = 'maintenant';
    } else if (diference.inMinutes < 60) {
      date = "${clean ? '' : 'il y a '}${diference.inMinutes} min";
    } else if (diference.inHours < 10) {
      date = "${clean ? '' : 'il y a '}${diference.inHours} heure${diference.inHours > 1 ? 's' : ''}";
    } else if (diference.inHours < 24) {
      date = "${clean ? '' : 'hier à '}${dateTime.hour} ${dateTime.hour > 1 ? 'heure' : 'heure'}";
    } else if (diference.inDays < 30) {
      date = diference.inDays == 1 ? 'hier' : "${clean ? '' : 'il y a '}${diference.inDays} jours";
    } else if (diference.inDays < 60) {
      date = "${clean ? '' : 'il y a '}2 mois";
    } else {
      date = sementic();
    }

    return date;
  }
}

class CBreakpoints {
  static const double xs = 576;
  static const double sm = 768;
  static const double md = 992;
  static const double lg = 1200;
  static const double xl = double.infinity;

  CBreakpoints.of(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    if (screenSize.width <= sm) {
      isMobile = true;
    } else if (screenSize.width > sm && screenSize.width <= md) {
      isTablet = true;
    } else if (screenSize.width > md && screenSize.width <= lg) {
      isDesktop = true;
    } else if (screenSize.width > lg && screenSize.width <= 1600) {
      isLarge = true;
    } else if (screenSize.width > lg) {
      isXLarge = true;
    }
  }

  bool isMobile = false;
  bool isTablet = false;
  bool isDesktop = false;
  bool isLarge = false;
  bool isXLarge = false;

  // static const double xs = 480;
  // static const double sm = 576;
  // static const double md = 768;
  // static const double lg = 992;
  // static const double xl = 1200;
  // static const double xxl = 1400;
  // static const double xxxl = 1600;
  // static const double xxxxl = 10000;
  // static const double max = double.infinity;
  // ResponsiveGridBreakpoints({double xs = 576, double sm = 768, double md = 992, double lg = 1200, double xl = double.infinity})
}

class TimeDuration {
  TimeDuration(Duration duration) {
    int formula(int unit, int time) {
      if (time > unit) {
        double r = time / unit;
        int q = r.floor();
        int t = q * unit;
        return time - t;
      }
      return time;
    }

    final int monthsUnit = 12;
    final int daysUnit = 30;
    final int hoursUnit = 24;
    final int minutesUnit = 60;
    final int secondsUnit = 60;

    month = formula(monthsUnit, duration.inDays);
    days = formula(daysUnit, duration.inDays);
    hours = formula(hoursUnit, duration.inHours);
    minutes = formula(minutesUnit, duration.inMinutes);
    seconds0 = formula(secondsUnit, duration.inSeconds);
  }

  late final int month;
  late final int days;
  late final int hours;
  late final int minutes;
  late final int seconds0;
}
