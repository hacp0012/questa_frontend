// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CConsts {
  static const String APP_NAME = "Famille Chretienne";

  static const Color PRIMARY_COLOR = Color(0xffD2E83F);
  static const Color LOGO_PRIMARY_COLOR = Color(0xff7da513);
  static const Color SECONDARY_COLOR = Color(0xff222125);
  static const Color COLOR_GREEN_LIGHT = Color(0xffEDEBA9);
  static const Color COLOR_GREY_LIGHT = Color(0x76b6bfb1); //.withAlpha(90);
  static const Color COLOR_BLUE_LIGHT = Color(0xffD5DDED);
  static const Color COLOR_SURFACE = Color(0xffF1F0F0);
  static const Color LIGHT_COLOR = Colors.white;

  static const String FONT_INTER = 'Inter';
  static const String FONT_RALEWAY = 'Raleway';
  static const String FONT_DMSANS = 'DMSans';
  static const String FONT_COMFORTAA = 'Comfortaa';
  static const String FONT_ISTOK = 'IstokWeb';
  static const String FONT_ALBERT = 'AlbertSans';

  static const double DEFAULT_RADIUS = 12;
  static const String CENTER_DOT = '•';

  // * SHARED PREFERENCEIES ENCRYPTION KEY : key length 16 * /
  static const String ENCRYPTION_KEY = "j1cc5k315582469Q";

  // * URL * /
  static const String DEV_URL = "http://localhost";
  static const String PROD_URL = "https://myquesta.net";
  static const String QLINKS_API_URL = "https://qlinks.me";

  static const String API_URL = kDebugMode ? DEV_URL : PROD_URL;

  // APP //
  static const String APP_VERSION = '1.0.0+23';
}
