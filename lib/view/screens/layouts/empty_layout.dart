import 'package:flutter/material.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:statusbarmanager/statusbarmanager.dart';

class EmptyLayout extends StatefulWidget {
  const EmptyLayout({super.key, required this.child});
  final Widget child;

  @override
  State<EmptyLayout> createState() => _EmptyLayoutState();
}

class _EmptyLayoutState extends State<EmptyLayout> {
  @override
  Widget build(BuildContext context) {
    return StatusBarManager(
      translucent: false,
      statusBarColor: context.theme.colorScheme.surface,
      navigationBarColor: context.theme.colorScheme.surface,
      child: widget.child,
    );
  }
}
