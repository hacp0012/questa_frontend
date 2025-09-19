import 'dart:convert';

// import 'package:css_text/css_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/modules/c_misc_class.dart';
import 'package:run_it/run_it.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExtensionsUtilsPacks {}

extension ExtOnAllType<T> on T {
  T onDark(BuildContext context, T dark) {
    if (context.theme.brightness == Brightness.light) return this;
    return dark;
  }
}

extension ExtOnObjects<I> on Object {
  String toJSON() => jsonEncode(this);
  Text get t => toString().toText();
}

extension DurationExtentions on int {
  Duration get sec => Duration(seconds: this);
  Duration get min => Duration(minutes: this);
  Duration get hour => Duration(hours: this);
  Duration get ms => Duration(milliseconds: this);
  Duration get day => Duration(days: this);
  Widget get gap => Gap(toDouble());
}

extension ExtOnDouble on double {
  Widget get gap => Gap(this);
}

extension ExtOnBuildContext on BuildContext {
  ThemeData get theme => Theme.of(this);
}

extension ExtOnDateTime on DateTime {
  PrintableDateHandler get toReadable => PrintableDateHandler(this);
}

extension ExtOnWidget on Widget {
  Widget cursorClick({bool none = false, VoidCallback? onClick, bool inkwell = false}) {
    if (inkwell) {
      return InkWell(onTap: onClick, child: this);
    }
    return MouseRegion(
      cursor: none ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(onTap: onClick, child: this),
    );
  }

  Widget cursorBusy([bool none = false]) =>
      MouseRegion(cursor: none ? SystemMouseCursors.basic : SystemMouseCursors.forbidden, child: this);
  Widget cursorLoading([bool none = false]) =>
      MouseRegion(cursor: none ? SystemMouseCursors.basic : SystemMouseCursors.wait, child: this);
  Widget onTap(Function()? onTap) => GestureDetector(onTap: onTap, child: this);
  Widget tooltip(BuildContext context, String? message) => Tooltip(
    message: message,
    padding: EdgeInsets.symmetric(horizontal: 9, vertical: 2.7),
    textStyle: TextStyle(fontSize: 11.7, color: CConsts.SECONDARY_COLOR.onDark(context, Colors.white)),
    decoration: BoxDecoration(
      color: Colors.white.onDark(context, CConsts.SECONDARY_COLOR),
      borderRadius: BorderRadius.circular(4.5),
      boxShadow: [
        BoxShadow(color: CConsts.SECONDARY_COLOR.withAlpha(45), blurRadius: 12, offset: Offset(0, 4), spreadRadius: 0),
      ],
    ),
    child: this,
  );
  Widget stickThis(Widget widget, {bool useWrap = false, double? marginLeft = 9, double? marginRight, bool? vCenter = true}) {
    Widget child = this;
    List<Widget> children = [];

    if (this is Wrap) {
      children = (this as Wrap).children;
      if (marginLeft.isNotNull) children.add(SizedBox(width: marginLeft));
      children.add(widget);
      if (marginRight.isNotNull) children.add(SizedBox(width: marginRight));
    } else if (this is Row) {
      children = (this as Row).children;
      if (marginLeft.isNotNull) children.add(SizedBox(width: marginLeft));
      children.add(widget);
      if (marginRight.isNotNull) children.add(SizedBox(width: marginRight));
    } else if (this is Column) {
      children = (this as Column).children;
      if (marginLeft.isNotNull) children.add(SizedBox(width: marginLeft));
      children.add(widget);
      if (marginRight.isNotNull) children.add(SizedBox(width: marginRight));
    } else {
      children.add(this);
      if (marginLeft.isNotNull) children.add(SizedBox(width: marginLeft));
      children.add(widget);
      if (marginRight.isNotNull) children.add(SizedBox(width: marginRight));
    }

    // children.add(widget);
    if (useWrap) {
      WrapCrossAlignment crossAxisAlignment = WrapCrossAlignment.center.runOn((it) {
        if (vCenter == false) {
          return WrapCrossAlignment.start;
        } else if (vCenter == null) {
          return WrapCrossAlignment.end;
        }
        return it;
      });
      child = Wrap(crossAxisAlignment: crossAxisAlignment, children: children);
    } else {
      CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center.runOn((it) {
        if (vCenter == false) {
          return CrossAxisAlignment.start;
        } else if (vCenter == null) {
          return CrossAxisAlignment.end;
        }
        return it;
      });

      child = Row(crossAxisAlignment: crossAxisAlignment, mainAxisSize: MainAxisSize.min, children: children);
    }

    return child;
  }

  // Widget cursorClick([bool none = false]) =>
  //     MouseRegion(cursor: none ? SystemMouseCursors.basic : SystemMouseCursors.click, child: this);
  // Widget cursorBusy([bool none = false]) =>
  //     MouseRegion(cursor: none ? SystemMouseCursors.basic : SystemMouseCursors.none, child: this);
  // Widget cursorLoading([bool none = false]) =>
  //     MouseRegion(cursor: none ? SystemMouseCursors.basic : SystemMouseCursors.wait, child: this);

  Widget sized({double? width, double? height, double? all}) {
    return SizedBox(width: all ?? width, height: all ?? height, child: this);
  }

  Widget expanded({int flex = 1}) => Expanded(flex: flex, child: this);
  Widget withPadding({
    double? horizontal,
    double? vertical,
    double? all,
    double? top,
    double? right,
    double? bottom,
    double? left,
  }) {
    EdgeInsets padding = EdgeInsets.zero;

    if (all != null) {
      padding = EdgeInsets.all(all);
    } else if (horizontal != null || vertical != null) {
      padding = EdgeInsets.symmetric(horizontal: horizontal ?? 0, vertical: vertical ?? 0);
    } else if (top != null || right != null || bottom != null || left != null) {
      padding = EdgeInsets.only(top: top ?? 0, right: right ?? 0, bottom: bottom ?? 0, left: left ?? 0);
    }

    return Padding(padding: padding, child: this);
  }

  Widget constrained({
    double maxWidth = double.infinity,
    double maxHeight = double.infinity,
    double minWidth = .0,
    double minHeight = .0,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight, minWidth: minWidth, minHeight: minHeight),
      child: this,
    );
  }

  Widget asSkeleton({bool enabled = true}) => Skeletonizer(enabled: enabled, child: this);
  // Widget onTap(Function? action) => GestureDetector(onTap: () => action?.call(), child: this);
}

extension ExtOnText on Text {
  // RichText asHtml(BuildContext context, [Function linksCallback = defaultLinksCallback]) {
  //   return HTML.toRichText(context, data ?? '', linksCallback: linksCallback);
  // }
  Text get bold {
    TextStyle style = this.style ?? TextStyle();
    return _TextTypographies(this, style.copyWith(fontWeight: FontWeight.bold)).getIt();
  }

  Text get elipsis {
    TextStyle style = this.style ?? TextStyle();
    return _TextTypographies(this, style.copyWith(overflow: TextOverflow.ellipsis)).getIt();
  }

  Text get muted {
    TextStyle style = this.style ?? TextStyle();
    return _TextTypographies(this, style.copyWith(color: Colors.grey.shade600)).getIt();
  }

  Text get center {
    TextStyle style = this.style ?? TextStyle();
    return _TextTypographies(this, style, textAlig: TextAlign.center).getIt();
  }

  Text get italic {
    TextStyle style = this.style ?? TextStyle();
    return _TextTypographies(this, style.copyWith(fontStyle: FontStyle.italic)).getIt();
  }

  Text color(Color color) {
    TextStyle style = this.style ?? TextStyle();
    return _TextTypographies(this, style.copyWith(color: color)).getIt();
  }

  // Text get body {
  //   TextStyle style = this.style ?? TextStyle();
  //   return _TextTypographies(
  //     this,
  //     style.copyWith(fontSize: TcTextTheme.light.bodyMedium?.fontSize, fontWeight: TcTextTheme.light.bodyMedium?.fontWeight),
  //   ).getIt();
  // }

  // Text get label {
  //   TextStyle style = this.style ?? TextStyle();
  //   return _TextTypographies(
  //     this,
  //     style.copyWith(
  //       fontSize: TcTextTheme.light.labelMedium?.fontSize,
  //       fontWeight: TcTextTheme.light.labelMedium?.fontWeight,
  //     ),
  //   ).getIt();
  // }

  // Text get labelSmall {
  //   TextStyle style = this.style ?? TextStyle();
  //   return _TextTypographies(
  //     this,
  //     style.copyWith(fontSize: TcTextTheme.light.labelSmall?.fontSize, fontWeight: TcTextTheme.light.labelSmall?.fontWeight),
  //   ).getIt();
  // }
}

extension ExtOnString on String {
  // RichText asHtml(BuildContext context, [Function linksCallback = defaultLinksCallback]) {
  //   return HTML.toRichText(context, this, linksCallback: linksCallback);
  // }

  int toInt() => int.tryParse(this) ?? 0;
  double toDouble() => double.tryParse(this) ?? 0.0;
  DateTime? toDateTime() => DateTime.tryParse(this);
  // String get asMoney => toDouble().toMoney();
  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
  Text toText({TextStyle? textStyle, TextAlign? textAlign, TextOverflow? overFlow}) {
    return Text(this, overflow: overFlow, style: textStyle, textAlign: textAlign);
  }

  // Text get t => toText();
}

extension ExtOnList on List<Widget> {
  Row toRow({bool min = true, bool? crossTop = false, bool center = false}) => Row(
    mainAxisSize: min ? MainAxisSize.min : MainAxisSize.max,
    crossAxisAlignment: crossTop == true
        ? CrossAxisAlignment.start
        : (crossTop == null ? CrossAxisAlignment.end : CrossAxisAlignment.center),
    mainAxisAlignment: center ? MainAxisAlignment.center : MainAxisAlignment.start,
    children: this,
  );
}

extension ExtOnTextList on List<Text> {
  Text toRichText({TextAlign? textAlign, TextStyle? textStyle}) => Text.rich(
    TextSpan(
      children: map((e) => TextSpan(text: e.data, style: e.style)).toList(),
    ),
    textAlign: textAlign,
    style: textStyle,
  );
}

class _TextTypographies {
  _TextTypographies(this.text, this.style, {TextAlign? textAlig}) {
    _textAlign = textAlig ?? text.textAlign;
    _softWrap = text.softWrap;
  }
  final Text text;
  final TextStyle style;

  TextAlign? _textAlign;
  bool? _softWrap;

  Text getIt() {
    return Text(text.data!, textAlign: _textAlign, softWrap: _softWrap, style: style);
  }
}
