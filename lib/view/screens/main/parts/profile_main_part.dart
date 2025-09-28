part of '../main_screen.dart';

@RoutePage(name: "ProfileMainPartRoute")
class ProfileMainPart extends StatefulWidget {
  const ProfileMainPart({super.key});

  @override
  State<ProfileMainPart> createState() => _ProfileMainPartState();
}

class _ProfileMainPartState extends State<ProfileMainPart> with AutomaticKeepAliveClientMixin<ProfileMainPart>, UiValueMixin {
  Map userData = {};

  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);

    Dsi.registerCallback("011f9r791715724485632d097R4", (p0) => '');
  }

  @override
  void dispose() {
    Dsi.disposeCallback('011f9r791715724485632d097R4');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userData = Dsi.of<UserMv>(context)!.data;

    super.build(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Image.asset("lib/assets/icons/logo_text_secondary_color.png", height: 45),
      ),

      // BODY.
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 12),
        children: [
          72.gap,
          Row(
            children: [
              CircleAvatar(
                radius: 54,
                backgroundImage: userData['picture'] == null
                    ? null
                    : Image.network(
                        CNetworkFilesClass.picture(userData['picture'], scale: 36, defaultImage: 'logo'),
                        errorBuilder: (context, error, stackTrace) => Icon(IconsaxPlusLinear.user, size: 54),
                      ).image,
                child: userData['picture'] != null ? null : Icon(IconsaxPlusLinear.user, size: 54),
              ).cursorClick(
                onClick: userData['picture'] == null
                    ? null
                    : () {
                        PhotoViewerWidget.fullscreenModal(context, urls: [CNetworkFilesClass.picture(userData['picture'])]);
                      },
              ),
              9.gap,
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${userData['name'] ?? 'N/A'}",
                    style: context.theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  9.gap,
                  FilledButton.tonalIcon(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(CConsts.LIGHT_COLOR),
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: () {
                      CRouter(context).goTo(UserProfileOptionRoute());
                    },
                    label: Text("Modifier le profile"),
                    icon: Icon(IconsaxPlusLinear.edit),
                  ),
                  3.6.gap,
                  if (userData['id_tasker'] == null)
                    Text(
                      "Vous n'avez pas de profile TASKER (Professionel) Veille en cree une si besoin.",
                      style: context.theme.textTheme.labelSmall,
                    ).muted,
                ],
              ).expanded(),
            ],
          ),

          27.gap,
          Visibility(
            visible: userData['id_tasker'] != null,
            child: Container(
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: CConsts.LIGHT_COLOR,
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  colors: [CConsts.COLOR_GREY_LIGHT, CConsts.COLOR_GREY_LIGHT.withAlpha(60)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: ListTile(
                onTap: () {
                  if (userData['tasker_profile_state'] == 'INWAIT_FOR_IDS') {
                    // OPEN ASK FOR ID's
                    CRouter(context).goTo(TaskerValidationIdsRoute());
                    return;
                  } else if (userData['tasker_profile_state'] == 'INPROCESS') {
                    CModalWidget(
                      context,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Attention", style: context.theme.textTheme.titleLarge),
                          9.gap,
                          Text(
                            "Votre demande de mise à jour vers le profil Tasker a été reçue avec succès. \n"
                            "Après examen, vous recevrez une notification vous invitant à compléter "
                            "votre portfolio ainsi que d'autres informations utiles. \n"
                            "Ce processus peut prendre jusqu'à 72 heures.",
                            style: context.theme.textTheme.bodyLarge,
                          ),
                          9.gap,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [TextButton(onPressed: () => Navigator.pop(context), child: "Fermer".t)],
                          ),
                        ],
                      ).withPadding(all: 12),
                    ).show();
                    return;
                  } else {
                    CRouter(context).goTo(TaskerUserMainRoute());
                  }
                },
                leading: Icon(IconsaxPlusLinear.diamonds),
                title: Text(
                  "Profile tasker ${CConsts.CENTER_DOT} PRO",
                  style: context.theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                subtitle: Builder(
                  builder: (context) {
                    if (userData['tasker_profile_state'] == 'INWAIT_FOR_IDS') {
                      return "En attente d'information d'identification pesonnelle.".t;
                    } else if (userData['tasker_profile_state'] == 'INPROCESS') {
                      return "En preocessus de validation.".t;
                    }
                    return Text("12 vue ${CConsts.CENTER_DOT} 3 J'aimes ${CConsts.CENTER_DOT} Complet");
                  },
                ),
              ),
            ),
          ),

          18.gap,
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 4.5,
            runSpacing: 4.5,
            children: [
              Card.filled(
                color: CConsts.LIGHT_COLOR,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(IconsaxPlusBroken.bag, size: 36),
                    9.gap,
                    Text(
                      "Mes taches",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ).sized(all: 90),
              Card.filled(
                color: CConsts.LIGHT_COLOR,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(IconsaxPlusBroken.coin, size: 36),
                    9.gap,
                    Text(
                      "Credits",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ).sized(all: 90),
              Card.filled(
                color: CConsts.LIGHT_COLOR,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(IconsaxPlusBroken.notification_1, size: 36),
                    9.gap,
                    Text(
                      "Notifications",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ).sized(all: 90),
              if (userData['id_tasker'] == null)
                Card.outlined(
                  color: CConsts.LIGHT_COLOR,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(IconsaxPlusBroken.user_octagon, size: 27),
                      9.gap,
                      Text(
                        "Tasker",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text("Creer profile", style: context.theme.textTheme.labelSmall),
                    ],
                  ),
                ).sized(all: 90).cursorClick(onClick: () => CRouter(context).goTo(TaskerRegisterRoute())),
              Card.filled(
                color: CConsts.LIGHT_COLOR,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(IconsaxPlusBroken.share, size: 36),
                    9.gap,
                    Text(
                      "Partager",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ).sized(all: 90).cursorClick(onClick: () => CRouter(context).goTo(ShareAppRoute())),
            ],
          ),

          18.gap,
          ListTile(
            visualDensity: VisualDensity.compact,
            dense: false,
            leading: Icon(IconsaxPlusBroken.setting),
            title: Text("Paramettres"),
            onTap: () {},
          ),
          ListTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            leading: Icon(IconsaxPlusBroken.note_21),
            title: Text("Politiques"),
            subtitle: "Politiques et conditions d'utilisation.".t,
            onTap: () => CRouter(context).goTo(PrivacyPolicyRoute()),
          ),
          ListTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            leading: Icon(IconsaxPlusBroken.info_circle),
            title: Text("A propos").stickThis("${CConsts.CENTER_DOT} ${CConsts.APP_VERSION}".t.muted),
            subtitle: "(c)${DateTime.now().year} Questa - Tous droits réservés".t,
            onTap: () => CRouter(context).goTo(AboutAppRoute()),
          ),

          // SPACER.
          81.gap,
        ],
      ),
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;

  @override
  bool get wantKeepAlive => true;
}
