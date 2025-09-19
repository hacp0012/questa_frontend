import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:logger/logger.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/modules/c_api.dart';
import 'package:questa/modules/c_navigate.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/auto_routes/a_r_app.gr.dart';
import 'package:questa/view/theme/configs/tc_buttons.dart';
import 'package:questa/view/widgets/back_button_widget.dart';
import 'package:questa/view/widgets/c_modal_widget.dart';
import 'package:questa/view/widgets/c_toast.dart';
import 'package:questa/view/widgets/spinner_widget.dart';
import 'package:ui_value/ui_value.dart';

@RoutePage()
class DeleteTaskerProfileScreen extends StatefulWidget {
  const DeleteTaskerProfileScreen({super.key});

  @override
  State<DeleteTaskerProfileScreen> createState() => _DeleteTaskerProfileScreenState();
}

class _DeleteTaskerProfileScreenState extends State<DeleteTaskerProfileScreen> with UiValueMixin {
  late var isDesactivating = uiValue(false);

  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButtonWidget(), centerTitle: true, title: "Prfile Tasker".t),

      // BODY.
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(IconsaxPlusBroken.profile_remove, size: 144, color: CConsts.SECONDARY_COLOR),
            9.gap,
            Text("Desactiver", style: context.theme.textTheme.headlineMedium),
            18.gap,
            Text("Commodo culpa sunt sunt ipsum pariatur fugiat. " * 8, textAlign: TextAlign.center),
            27.gap,
            FilledButton.tonalIcon(
              style: isDesactivating.value ? null : TcButtonsLight.blackButtonTheme,
              onPressed: isDesactivating.value ? null : _showAttentionDialog,
              icon: isDesactivating.value ? SpinnerWidget(size: 14) : Icon(IconsaxPlusLinear.trash),
              label: "DESACTIVER LE PROFILE".t,
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
          Text("Desactiver", style: context.theme.textTheme.titleLarge),
          18.gap,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () => Navigator.pop(context), child: "Fermer".t),
              9.gap,
              FilledButton.tonalIcon(
                style: TcButtonsLight.blackButtonTheme,
                onPressed: () {
                  Navigator.pop(context);
                  startDesactivation();
                },
                icon: Icon(IconsaxPlusLinear.trash),
                label: "OUI DESACTIVER".t,
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
    var req = CApi.request.post('/user/tasker/9kR9E3Q1T', data: params);
    req.whenComplete(() => isDesactivating.value = false);
    req.then(
      (res) {
        Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          CToast(context).success("Profile desactive avec succes.".t);
          CRouter(context).replace(MainScreenRoute());
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
