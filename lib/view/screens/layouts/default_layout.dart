import 'package:flutter/material.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:statusbarmanager/statusbarmanager.dart';

class DefaultContainer extends StatefulWidget {
  const DefaultContainer({super.key, required this.child, this.navBarColor, this.statusBarColor});
  final Widget child;
  final Color? statusBarColor;
  final Color? navBarColor;

  @override
  State<DefaultContainer> createState() => _DefaultContainerState();
}

class _DefaultContainerState extends State<DefaultContainer> {
  @override
  Widget build(BuildContext context) {
    return StatusBarManager(
      translucent: false,
      statusBarColor: widget.statusBarColor ?? context.theme.colorScheme.surface,
      navigationBarColor: widget.navBarColor ?? context.theme.colorScheme.surface,
      child: widget.child,
    );
  }
}
