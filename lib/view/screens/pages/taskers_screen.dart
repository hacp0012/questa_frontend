import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/screens/layouts/default_layout.dart';
import 'package:questa/view/widgets/back_button_widget.dart';

@RoutePage()
class TaskersScreen extends StatefulWidget {
  const TaskersScreen({super.key});

  @override
  State<TaskersScreen> createState() => _TaskersScreenState();
}

class _TaskersScreenState extends State<TaskersScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(leading: BackButtonWidget(), title: Text("Les taskers")),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12),
          children: [
            72.gap,
            TextField(
              decoration: InputDecoration(prefixIcon: Icon(IconsaxPlusLinear.search_normal), hintText: "Chercher ..."),
            ),
            12.gap,
            const Placeholder(),
          ],
        ),
      ),
    );
  }
}
