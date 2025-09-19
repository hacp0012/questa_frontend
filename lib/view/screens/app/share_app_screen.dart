import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:questa/modules/c_navigate.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/auto_routes/a_r_app.gr.dart';
import 'package:questa/view/screens/layouts/default_layout.dart';
import 'package:questa/view/widgets/back_button_widget.dart';
import 'package:ui_value/ui_value.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_web_player/youtube_web_player.dart';

@RoutePage()
class ShareAppScreen extends StatefulWidget {
  const ShareAppScreen({super.key, this.isShared = false});
  final bool isShared;

  @override
  State<ShareAppScreen> createState() => _ShareAppScreenState();
}

class _ShareAppScreenState extends State<ShareAppScreen> with UiValueMixin {
  YoutubeWebPlayerController? youtubeVideoController;
  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(leading: BackButtonWidget(), title: null),

        // BODY.
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12),
          children: [
            72.gap,

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('lib/assets/icons/logo_text_q_primary_color.png', height: 81),
                9.gap,
                Text("Partager l'app", style: context.theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),

            9.gap,
            Text("Télécharger la médiathèque de la Questa", style: context.theme.textTheme.titleMedium).center,
            18.gap,

            // ANDROID
            Icon(Icons.android, size: 36, color: Colors.green),
            Text("Android", style: context.theme.textTheme.titleLarge).center,
            18.gap,
            Text("Utilisateur d'Android ?").center,
            9.gap,
            Row(
              children: [
                FilledButton.icon(
                  icon: Icon(Icons.download),
                  label: "Play Store".t,
                  onPressed: openAndroidPlayStore,
                ).expanded(),
              ],
            ),

            // IOS
            9.gap,
            // Divider(),
            18.gap,
            Icon(Icons.apple, size: 36, color: Colors.grey.shade700),
            Text("IOS (IPhone)", style: context.theme.textTheme.titleLarge).center,
            18.gap,
            Text("Utilisateur de Iphone (IOS) ?").center,
            9.gap,
            Row(
              children: [
                FilledButton.icon(icon: Icon(IconsaxPlusLinear.share), label: "Ouvrir".t, onPressed: openIosPWA).expanded(),
              ],
            ),
            9.gap,
            Text(
              "Visualisez ce petit tutoriel pour voir comment installer l'application sur votre téléphone avant "
              "d'ouvrir le lien ci-dessus.",
            ).center,
            9.gap,
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(9),
              child: AspectRatio(
                aspectRatio: 4 / 2.5,
                child: YoutubeWebPlayer(
                  isAutoPlay: true,
                  controller: youtubeVideoController,
                  videoId: '-qskAdmXE8g',
                  isIframeAllowFullscreen: true,
                  isAllowsInlineMediaPlayback: false,
                  videoStartTimeSeconds: 35,
                  background: Colors.black,
                ),
              ),
            ),

            // SPACER.
            81.gap,
          ],
        ),
      ),
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;
  // METHOD ==================================================================================================================
  void openAndroidPlayStore() => launchUrl(
    Uri.parse("https://play.google.com/store/apps/details?id=org.cfc_media.twa"),
    mode: LaunchMode.externalApplication,
  );

  void openIosPWA() => CRouter(context).replace(MainScreenRoute());
}
