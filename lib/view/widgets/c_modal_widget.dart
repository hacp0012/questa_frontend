import 'package:flutter/material.dart';

class CModalWidget {
  CModalWidget(this.context, {required this.child});

  CModalWidget.fullscreen({required this.context, required this.child}) {
    _isFullscreen = true;
  }

  final BuildContext context;
  final Widget child;
  EdgeInsets? insetPadding;
  bool _isFullscreen = false;
  Alignment alignment = Alignment.center;
  bool persistant = false;
  bool unRoute = false;
  bool useSafearea = true;

  void show({
    bool? persistant,
    Alignment? alignment,
    bool? isFullscreen,
    bool unRoute = false,
    bool useSafearea = true,
    EdgeInsets? insetPadding,
  }) {
    this.alignment = alignment ?? Alignment.center;
    _isFullscreen = isFullscreen ?? _isFullscreen;
    this.persistant = persistant ?? false;
    this.unRoute = unRoute;
    this.useSafearea = useSafearea;
    this.insetPadding = insetPadding;

    if (_isFullscreen) {
      _fullscreenModal();
    } else {
      _modal();
    }
  }

  void _fullscreenModal() {
    showDialog(
      context: context,
      barrierDismissible: !persistant,
      useRootNavigator: !unRoute,
      useSafeArea: useSafearea,
      builder: (context) => Dialog.fullscreen(insetAnimationCurve: Curves.ease, child: child),
    );
  }

  void _modal() {
    showDialog(
      context: context,
      barrierLabel: "lorem ipsum",
      barrierDismissible: !persistant,
      useRootNavigator: !unRoute,
      builder: (context) => Dialog(
        insetAnimationCurve: Curves.ease,
        alignment: alignment,
        insetPadding: insetPadding,
        // shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(9)),
        child: child,
      ),
    );
  }

  /// Close modal.
  static void close(BuildContext context) {
    Navigator.of(context).pop();
  }
}
