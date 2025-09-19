import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:questa/dsi/data_sync_interface.dart';
import 'package:questa/models/user_mv.dart';
import 'package:questa/modules/audio_player_handler.dart';
import 'package:questa/view/auto_routes/a_r_app.dart';
import 'package:questa/view/theme/theme_configs.dart';

import 'auto_routes/a_r_auth_reevaluate.dart';

class AppSetup extends StatefulWidget {
  const AppSetup({super.key});

  @override
  State<AppSetup> createState() => _AppSetupState();
}

class _AppSetupState extends State<AppSetup> {
  var router = ARApp();
  // INITALIZE THE APP. ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void initState() {
    super.initState();

    Dsi.registerModel<ARApp>(ARApp());
    Dsi.registerModel<ARAuthReevaluate>(ARAuthReevaluate());

    AudioPlayerHandler.inst.initialize();
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the font scale factor from MediaQuery
    // final double fontScaleFactor = MediaQuery.textScaleFactorOf(context);

    // Adjust the font scale factor if needed, for example, cap it at a certain value
    // final double adjustedFontScaleFactor = fontScaleFactor > 1.5 ? 1.5 : fontScaleFactor; s

    return DsiTreeObserver(
      models: [UserMv()],
      child: MaterialApp.router(
        title: "Questa",
        debugShowCheckedModeBanner: false,
        theme: ThemeConfigs.lightTheme,
        darkTheme: ThemeConfigs.darkTheme,
        themeMode: ThemeMode.light,
        routerConfig: Dsi.model<ARApp>()!.config(reevaluateListenable: Dsi.model<ARAuthReevaluate>()!),
        // routerConfig: router.config(/*reevaluateListenable: Dsi.model<ARAuthReevaluate>()!*/),
        builder: (context, child) {
          // Apply the font scale factor to the app's text
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(.9)),
            child: child!,
          );
        },
        // LANGUAGE.
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('fr'), // French
          Locale('en'), // English
        ],
        locale: const Locale('fr'),
      ),
    );
  }
}
