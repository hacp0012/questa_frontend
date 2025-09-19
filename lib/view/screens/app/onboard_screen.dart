import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:questa/modules/c_store.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/auto_routes/a_r_app.gr.dart';
import 'package:questa/view/screens/layouts/empty_layout.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:questa/view/theme/configs/tc_buttons.dart';

@RoutePage()
class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});
  static const String routeId = "KRAZyTEEYZHYXIMWCE";

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final _introControllerKey = GlobalKey<IntroductionScreenState>();

  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return EmptyLayout(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
              onPressed: () {
                finish();
                // CRouter(context).goTo(MainScreen.routeId);
                context.router.replace(MainScreenRoute());
              },
              child: "Passer".t,
            ),
            9.gap,
          ],
        ),

        // BODY.
        body: IntroductionScreen(
          key: _introControllerKey,

          // ACTIONS.
          overrideDone: (context, onPressed) => FilledButton.tonalIcon(
            onPressed: () {
              finish();
              // CRouter(context).goTo(MainScreen.routeId);
              context.replaceRoute(MainScreenRoute());
            },
            label: "Terminer".t,
            // icon: Icon(IconsaxPlusLinear.check),
            style: TcButtonsLight.blackButtonTheme,
          ),
          overrideNext: (context, onPressed) => FilledButton.tonalIcon(
            onPressed: () {
              _introControllerKey.currentState?.next();
            },
            label: "Suvant".t,
            icon: Icon(IconsaxPlusLinear.next),
            iconAlignment: IconAlignment.end,
          ),
          next: ElevatedButton.icon(onPressed: () {}, label: "Next".t, icon: Icon(IconsaxPlusBroken.next)),

          // CONFIGS.
          showDoneButton: true,
          dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: Theme.of(context).colorScheme.secondary,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          ),

          // CONTENTS.
          pages: [
            PageViewModel(
              title: "Title of introduction page",
              body: "Welcome to the app! This is a description of how it works.",
              image: Image.asset('lib/assets/images/presentation_compressed_1.png'),
            ),
            PageViewModel(
              title: "Title of introduction page",
              body: "Welcome to the app! This is a description of how it works.",
              image: Image.asset('lib/assets/images/presentation_compressed_2.png'),
            ),
          ],
        ),
      ),
    );
  }

  // METHODS =================================================================================================================
  void finish() => CStore.prefs.setBool('first_launched_this_app', false);
  // void finish() => context.router.push(AuthLoginRoute());
  // void finish() => context.router.push(NamedRoute(AuthLoginScreen.routeId));
}
