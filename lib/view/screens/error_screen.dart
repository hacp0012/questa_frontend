import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:questa/modules/c_navigate.dart';
import 'package:questa/view/screens/layouts/default_layout.dart';
import 'package:questa/view/theme/configs/tc_buttons.dart';

@RoutePage()
class ErrorScreen extends StatefulWidget {
  const ErrorScreen({super.key, required this.routeState});

  final GoRouterState routeState;

  static const String routeName = 'error';

  @override
  createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  // Data --------------------------------------------------------------------------------------------------------------------

  // View ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text("Erreur survenue")),

        // Body.
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.xmark_octagon, size: 9 * 18, color: Theme.of(context).colorScheme.error),

              // Text.
              const SizedBox(height: 9),
              Text(
                "ERREUR",
                style: TextStyle(fontSize: 9 * 5, color: Theme.of(context).colorScheme.error),
              ),
              const Padding(
                padding: EdgeInsets.all(27),
                child: Text(
                  "La page que vous vous tenter de visiter n'est pas disponible. Tenter de refaire le processus.",
                  textAlign: TextAlign.center,
                ),
              ),

              // Button.
              FilledButton.tonalIcon(
                onPressed: () {
                  CRouter(context).goBack();
                  context.back();
                },
                style: TcButtonsLight.blackButtonTheme,
                icon: const Icon(IconsaxPlusLinear.arrow_left),
                label: const Text("Retour"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
