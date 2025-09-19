import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:questa/view/screens/layouts/default_layout.dart';
import 'package:questa/view/widgets/back_button_widget.dart';

@RoutePage()
class TaskResponsesScreen extends StatefulWidget {
  const TaskResponsesScreen({super.key, required this.taskId});
  final String taskId;

  @override
  State<TaskResponsesScreen> createState() => _TaskResponsesScreenState();
}

class _TaskResponsesScreenState extends State<TaskResponsesScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Scaffold(
        appBar: AppBar(leading: BackButtonWidget(), title: Text("Liste des réponses")),

        // BODY.
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12),
          children: [
            //
            const Placeholder(),
          ],
        ),
      ),
    );
  }
}
