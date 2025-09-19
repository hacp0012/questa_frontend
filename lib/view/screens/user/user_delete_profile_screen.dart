import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:logger/logger.dart';
import 'package:questa/modules/c_api.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/theme/configs/tc_buttons.dart';
import 'package:questa/view/widgets/back_button_widget.dart';
import 'package:questa/view/widgets/c_modal_widget.dart';
import 'package:questa/view/widgets/c_toast.dart';
import 'package:questa/view/widgets/spinner_widget.dart';
import 'package:ui_value/ui_value.dart';

@RoutePage()
class UserDeleteProfileScreen extends StatefulWidget {
  const UserDeleteProfileScreen({super.key});

  @override
  State<UserDeleteProfileScreen> createState() => _UserDeleteProfileScreenState();
}

class _UserDeleteProfileScreenState extends State<UserDeleteProfileScreen> with UiValueMixin {
  late var isDesactivating = uiValue(false);

  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButtonWidget(), centerTitle: true, title: "Prfil Utilisateur".t),

      // BODY.
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(IconsaxPlusBroken.trash_square, size: 144, color: context.theme.colorScheme.error),
            24.gap,
            Text("Suppression du compte".toUpperCase(), style: context.theme.textTheme.headlineMedium),
            18.gap,
            Text(
              "Vous êtes sur le point de supprimer définitivement votre compte Questa. Cette action est irréversible."
              "Elle entraînera :\n"
              "- La suppression de votre profil utilisateur et de votre profil Tasker (le cas échéant)\n"
              "- La perte de toutes vos données, historiques et préférences\n"
              "- L'arrêt immédiat de toutes les notifications et interactions sur la plateforme \n\n"
              "Souhaitez-vous vraiment continuer ?",
              textAlign: TextAlign.center,
              style: context.theme.textTheme.bodyMedium,
            ),
            27.gap,
            FilledButton.tonalIcon(
              style: isDesactivating.value ? null : TcButtonsLight.blackButtonTheme,
              onPressed: isDesactivating.value ? null : _showAttentionDialog,
              icon: isDesactivating.value ? SpinnerWidget(size: 14) : Icon(IconsaxPlusLinear.trash),
              label: "SUPPRIMER LE PROFILE".t,
            ),
          ],
        ).withPadding(horizontal: 12),
      ),
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;
  // METHODS =================================================================================================================
  void _showAttentionDialog() {
    CModalWidget(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Supprimer", style: context.theme.textTheme.titleLarge),
          18.gap,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () => Navigator.pop(context), child: "Annuler".t),
              9.gap,
              FilledButton.tonalIcon(
                style: TcButtonsLight.blackButtonTheme,
                onPressed: () {
                  Navigator.pop(context);
                  startDesactivation();
                },
                icon: Icon(IconsaxPlusLinear.trash),
                label: "OUI SUPPRIMER".t,
              ),
            ],
          ),
        ],
      ).withPadding(all: 12),
    ).show();
  }

  void startDesactivation() {
    isDesactivating.value = true;

    Map<String, dynamic> params = {};
    var req = CApi.request.delete('/user/0K5FS3Fiq', queryParameters: params);
    req.whenComplete(() => isDesactivating.value = false);
    req.then(
      (res) {
        Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          CToast(context).success("Profile Supprimer avec succes.".t);
          // CRouter(context).replace(MainScreenRoute());
        } else {
          CToast(context).warning("Impossible de faire la desactivation du profile.".t);
        }
      },
      onError: (e) {
        Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }
}
