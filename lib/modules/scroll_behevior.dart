import 'dart:ui';

import 'package:flutter/material.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {PointerDeviceKind.touch, PointerDeviceKind.mouse};

  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return Scrollbar(
      controller: details.controller,
      thumbVisibility: true,
      trackVisibility: false,
      // thickness: 6.3,
      child: child,
    );
  }
}
