import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/modules/c_api.dart';
import 'package:questa/modules/c_image_handler_class.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/screens/layouts/default_layout.dart';
import 'package:questa/view/widgets/back_button_widget.dart';
import 'package:questa/view/widgets/c_toast.dart';
import 'package:questa/view/widgets/photo_viewer_widget.dart';
import 'package:questa/view/widgets/spinner_widget.dart';
import 'package:ui_value/ui_value.dart';

@RoutePage()
class UserProfileReadScreen extends StatefulWidget {
  const UserProfileReadScreen({super.key, @QueryParam() this.userId});
  final String? userId;

  @override
  State<UserProfileReadScreen> createState() => _UserProfileReadScreenState();
}

class _UserProfileReadScreenState extends State<UserProfileReadScreen> with UiValueMixin {
  late var isLoading = uiValue(true);

  Map userData = {};

  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    super.initState();

    loadDetails();
    // if (widget.userId.isNotNull) {
    // } else {
    //   context.back();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(leading: BackButtonWidget(), title: const Text('Profile utilisateur')),

        // BODY.
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12),
          children: [
            72.gap,
            Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        colors: [CConsts.COLOR_GREY_LIGHT, CConsts.COLOR_GREY_LIGHT.withAlpha(30)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 81,
                        backgroundImage: Image.network(
                          CNetworkFilesClass.picture(userData['picture']),
                          errorBuilder: (context, error, stackTrace) => Icon(IconsaxPlusBroken.user),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress != null) return child;
                            return SpinnerWidget();
                          },
                        ).image,
                      ).onTap(
                        isLoading.value
                            ? null
                            : () {
                                PhotoViewerWidget.fullscreenModal(
                                  context,
                                  title: "Photo de profil",
                                  urls: [CNetworkFilesClass.picture(userData['picture'])],
                                );
                              },
                      ),
                      9.gap,
                      SelectableText("@${userData['pseudo'] ?? ''}"),
                    ],
                  ),
                ),
              ],
            ).sized(height: 207).asSkeleton(enabled: isLoading.value),
            12.gap,
            Text(
              "${userData['name'] ?? 'Sans nom'}",
              style: context.theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ).asSkeleton(enabled: isLoading.value),
            "${userData['address']?['ville']['name'] ?? 'Ne fourni pas son ville'}".t.bold.muted,

            24.gap,
            Icon(IconsaxPlusLinear.map, size: 14).stickThis("Adresse de reference".t.muted),
            Text(
              "${userData['address_ref'] ?? 'N/A'}",
              style: context.theme.textTheme.bodyLarge,
            ).asSkeleton(enabled: isLoading.value),
            6.gap,
            Icon(IconsaxPlusLinear.map_1, size: 14).stickThis("Adresse".t.muted),
            if (userData['address'] != null)
              Text(
                "${userData['address']?['avenue']['name']}, "
                "${userData['address']?['quartier']['name']}, "
                "${userData['address']?['ville']['name']}, "
                "${userData['address']?['province']['name']}, ${CConsts.CENTER_DOT} "
                "${userData['address']?['pays']['name']}",
                style: context.theme.textTheme.bodyLarge,
              ).asSkeleton(enabled: isLoading.value)
            else
              "Ne fourni pas d'adresse".t.muted,

            12.gap,
            Card.filled(
              color: CConsts.LIGHT_COLOR,
              margin: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(IconsaxPlusLinear.personalcard, size: 18).stickThis("CONTACTS".t.muted),
                  4.5.gap,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${userData['telephone'] ?? 'N/A'}".replaceAll(',', '-'),
                        style: context.theme.textTheme.bodyLarge,
                      ),
                      IconButton(onPressed: () {}, icon: Icon(IconsaxPlusLinear.call)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${userData['email'] ?? 'Ne fourni pas de mail'}", style: context.theme.textTheme.bodyLarge),
                      IconButton(onPressed: () {}, icon: Icon(IconsaxPlusLinear.directbox_send)),
                    ],
                  ),
                ],
              ).withPadding(all: 12),
            ).asSkeleton(enabled: isLoading.value),

            // SPACER.
            81.gap,
          ],
        ),
      ),
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;
  // METHOS ==================================================================================================================
  void loadDetails() {
    isLoading.value = true;

    Map<String, dynamic> params = {'userId': widget.userId ?? '---'};
    var req = CApi.request.get('/user/OhVZ6ocpN', queryParameters: params);
    req.whenComplete(() => isLoading.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          userData = res.data['data'] ?? {};
        } else {
          CToast(context).warning("Impossible de recuperer le donnees utilisateur.".t);
          context.back();
        }
      },
      onError: (e) {
        // Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }
}
