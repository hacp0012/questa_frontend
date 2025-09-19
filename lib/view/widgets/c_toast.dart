import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:run_it/run_it.dart';

class CToast {
  CToast(this.context, [this.duration]);
  BuildContext context;
  Duration? duration;

  void success(Widget content) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Icon(
          IconsaxPlusLinear.tick_circle,
          size: 27,
        ).stickThis(content is Text ? content.color(Colors.black87).expanded() : content),
        showCloseIcon: true,
        backgroundColor: Colors.green.shade100,
        closeIconColor: Colors.black87,
        dismissDirection: DismissDirection.horizontal,
        duration: duration ?? Duration(milliseconds: 4000),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12)),
        padding: EdgeInsets.all(4.5),
      ),
    );
  }

  void error(Widget content) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Builder(
          builder: (context) {
            return Icon(
              IconsaxPlusLinear.warning_2,
              size: 27,
            ).stickThis(content is Text ? content.color(Colors.black87).expanded() : content);
          },
        ),
        showCloseIcon: true,
        backgroundColor: Colors.red.shade100,
        closeIconColor: Colors.black87,
        dismissDirection: DismissDirection.horizontal,
        duration: duration ?? Duration(milliseconds: 4000),
        clipBehavior: Clip.antiAlias,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12)),
        padding: EdgeInsets.all(4.5),
      ),
    );
  }

  void warning(Widget content) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Icon(
          IconsaxPlusLinear.danger,
          size: 27,
        ).stickThis(content is Text ? content.color(Colors.black87).expanded() : content),
        showCloseIcon: true,
        closeIconColor: Colors.black87,
        backgroundColor: Colors.amber.shade100,
        dismissDirection: DismissDirection.horizontal,
        duration: duration ?? Duration(milliseconds: 4000),
        clipBehavior: Clip.antiAlias,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(9),
        elevation: 18,
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12)),
        padding: EdgeInsets.all(4.5),
      ),
    );
  }

  void show(Widget content, {Icon? icon, VoidCallback? action, String? actionLabel}) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: (icon ?? Container()).stickThis(content is Text ? content.color(Colors.black87).expanded() : content),
        showCloseIcon: action.isNotNull ? false : true,
        closeIconColor: Colors.black87,
        backgroundColor: Colors.blue.shade100,
        dismissDirection: DismissDirection.horizontal,
        duration: duration ?? Duration(milliseconds: 4000),
        clipBehavior: Clip.antiAlias,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12)),
        padding: EdgeInsets.all(4.5),
        action: action.isNull
            ? null
            : SnackBarAction(
                backgroundColor: context.theme.colorScheme.surface,
                textColor: context.theme.colorScheme.primary,
                label: actionLabel ?? 'Action',
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  action?.call();
                },
              ),
      ),
    );
  }
}
