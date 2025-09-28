import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:logger/logger.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/configs/inline_notifier_keys.dart';
import 'package:questa/dsi/data_sync_interface.dart';
import 'package:questa/modules/c_api.dart';
import 'package:questa/modules/c_image_handler_class.dart';
import 'package:questa/modules/c_misc_class.dart';
import 'package:questa/modules/c_navigate.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/auto_routes/a_r_app.gr.dart';
import 'package:questa/view/screens/layouts/default_layout.dart';
import 'package:questa/view/widgets/back_button_widget.dart';
import 'package:questa/view/widgets/c_toast.dart';
import 'package:ui_value/ui_value.dart';

@RoutePage()
class TaskersScreen extends StatefulWidget {
  const TaskersScreen({super.key});

  @override
  State<TaskersScreen> createState() => _TaskersScreenState();
}

class _TaskersScreenState extends State<TaskersScreen> with UiValueMixin {
  late var isLoadingDetails = uiValue(false);
  late var isLoadingTaskers = uiValue(false);

  List skillsList = [];
  List taskersList = [];

  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void initState() {
    super.initState();
    _loadDetails();
    _loadTaskersList();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    Dsi.disposeCallback(DsiKeys.SKILLS_SELECTOR_PROXY.name);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: BackButtonWidget(),
          title: Text("Les taskers"),
          actions: [FilledButton.tonalIcon(onPressed: () {}, icon: Icon(IconsaxPlusLinear.save_2), label: "Mes favoris".t)],
        ),

        // BODY.
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(2.seconds);
          },
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 1),
            children: [
              72.gap,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(IconsaxPlusLinear.search_normal),
                      hintText: "Chercher ...",
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(IconsaxPlusLinear.search_normal),
                      ).withPadding(all: 3),
                    ),
                  ),
                ],
              ).withPadding(horizontal: 11),

              // TAGS
              12.gap,
              Visibility(
                visible: skillsList.isNotEmpty && !isLoadingDetails.value,
                replacement: Chip(label: "label".t).asSkeleton(),
                child: Row(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          12.gap,
                          Chip(
                            avatar: Icon(Icons.circle_outlined, size: 14, color: context.theme.colorScheme.primary),
                            label: "Tout".t.color(CConsts.LIGHT_COLOR),
                            color: WidgetStatePropertyAll(context.theme.colorScheme.secondary),
                          ),
                          12.gap,
                          ...skillsList.map((e) {
                            return Chip(label: "${e['name'] ?? 'N/A'}".t).withPadding(right: 6).cursorClick(onClick: () {});
                          }),
                          36.gap,
                        ],
                      ),
                    ).expanded(),
                    6.gap,
                    TextButton(onPressed: _openSkillsList, child: "Tout".t),
                  ],
                ).animate().fadeIn().slideX(),
              ),

              // LIST.
              if (isLoadingTaskers.value)
                _loader()
              else if (taskersList.isEmpty)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(IconsaxPlusBroken.user, size: 72, color: CConsts.COLOR_GREY_LIGHT),
                      12.gap,
                      Text("Aucun tasker disponible"),
                    ],
                  ),
                ).sized(height: 360)
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    12.gap,
                    ...taskersList.map((e) {
                      return Card.filled(
                        color: CConsts.LIGHT_COLOR,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // AVATAR
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // PICTURE.
                                CircleAvatar(
                                  radius: 20.10,
                                  backgroundImage: Image.network(
                                    CNetworkFilesClass.picture(e['user_picture']),
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(IconsaxPlusLinear.user);
                                    },
                                  ).image,
                                ),

                                // LIKES.
                                6.6.gap,
                                Icon(IconsaxPlusLinear.like, size: 14),
                                Text(
                                  CMiscClass.numberAbrev(e['likes_count'].toString().toDouble()),
                                  style: context.theme.textTheme.labelMedium,
                                ),
                              ],
                            ),

                            // CONTENTS.
                            12.gap,
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${e['user_pseudo'] ?? "Pseudo non precise"}",
                                  style: context.theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),

                                // NOTES.
                                Wrap(
                                  spacing: 6.6,
                                  runSpacing: 6.6,
                                  children: [
                                    Chip(
                                      label: CMiscClass.numberAbrev(e['starts_count'].toString().toDouble()).t,
                                      avatar: Icon(Icons.star, color: Colors.amber),
                                      color: WidgetStatePropertyAll(context.theme.colorScheme.surface),
                                    ),
                                    Chip(
                                      avatar: Icon(IconsaxPlusLinear.briefcase, size: 14, color: Colors.blue),
                                      label: "Taches ${CMiscClass.numberAbrev(e['deals_count'].toString().toDouble())}".t,
                                      // color: WidgetStatePropertyAll(context.theme.colorScheme.surface),
                                    ),
                                  ],
                                ),
                                6.6.gap,

                                // USER SKILLS.
                                Text(
                                  "${e['skills_names'] ?? 'N/A'}",
                                ).muted.elipsis.tooltip(context, "DOMAINES DES COMPETENCES\n${e['skills_names']}"),

                                // TOWN NAME.
                                6.6.gap,
                                Row(
                                  children: [
                                    Icon(IconsaxPlusLinear.location, size: 14, color: Colors.grey),
                                    6.6.gap,
                                    Text("${e['town_name'] ?? "Ville non precisee"}"),
                                  ],
                                ),
                              ],
                            ).expanded(),
                          ],
                        ).withPadding(all: 6.6),
                      ).cursorClick(
                        inkwell: true,
                        onClick: () {
                          CRouter(context).goTo(TaskerProfileRoute(taskerId: e['tasker_id'] ?? '---'));
                        },
                      );
                    }),
                  ],
                ).withPadding(horizontal: 11),

              // SPACER.
              81.gap,
            ],
          ),
        ),
      ),
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;

  Widget _loader() {
    return Card.filled(
      child: Row(children: [CircleAvatar(radius: 36), Text("Lorem ipsum")]).withPadding(vertical: 12),
    ).asSkeleton();
  }

  // METHODS =================================================================================================================
  void _loadTaskersList() {
    isLoadingTaskers.value = true;

    Map<String, dynamic> params = {};
    var req = CApi.request.get('/questa/dTP90oEjm', queryParameters: params);
    req.whenComplete(() => isLoadingTaskers.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          taskersList = res.data['data'] ?? [];
        } else {
          CToast(context).warning("Impossible de charger les meta donnees.".t);
        }
      },
      onError: (e) {
        Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }

  void _loadDetails() {
    isLoadingDetails.value = true;

    Map<String, dynamic> params = {};
    var req = CApi.request.get('/questa/WyAqwrDK0', queryParameters: params);
    req.whenComplete(() => isLoadingDetails.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          skillsList = res.data['data']?['skills'] ?? [];
        } else {
          CToast(context).warning("Impossible de charger les meta donnees.".t);
        }
      },
      onError: (e) {
        Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }

  void _openSkillsList() {
    CRouter(context).goTo(TaskSkillsMenuRoute());
    Dsi.registerCallback(DsiKeys.SKILLS_SELECTOR_PROXY.name, (selected) {
      CRouter(context).goBack();
    });
  }
}
