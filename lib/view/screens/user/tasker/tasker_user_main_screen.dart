import 'dart:typed_data';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:logger/logger.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/configs/inline_notifier_keys.dart';
import 'package:questa/dsi/data_sync_interface.dart';
import 'package:questa/modules/c_api.dart';
import 'package:questa/modules/c_image_handler_class.dart';
import 'package:questa/modules/c_navigate.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/auto_routes/a_r_app.gr.dart';
import 'package:questa/view/screens/layouts/default_layout.dart';
import 'package:questa/view/widgets/back_button_widget.dart';
import 'package:questa/view/widgets/c_dropdown_select_widget.dart';
import 'package:questa/view/widgets/c_modal_widget.dart';
import 'package:questa/view/widgets/c_toast.dart';
import 'package:questa/view/widgets/divider_widget.dart';
import 'package:questa/view/widgets/icon_button_widget.dart';
import 'package:questa/view/widgets/picture_croper_widge.dart';
import 'package:questa/view/widgets/spinner_widget.dart';
import 'package:run_it/run_it.dart';
import 'package:ui_value/ui_value.dart';

@RoutePage()
class TaskerUserMainScreen extends StatefulWidget {
  const TaskerUserMainScreen({super.key});
  static const String routeId = "10i3W40c1";

  @override
  State<TaskerUserMainScreen> createState() => _TaskerUserMainScreenState();
}

class _TaskerUserMainScreenState extends State<TaskerUserMainScreen> with UiValueMixin {
  late var showAppbarTitle = uiValue(false);
  late var isUploadingCoverPicture = uiValue(false);
  late var isLoadingDetails = uiValue(false);

  ScrollController scrollController = ScrollController();
  MenuController menuAnchorController = MenuController();

  Uint8List? coverPicture;

  Map deatails = {'cover_picture': null};
  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void initState() {
    super.initState();
    loadDetails();
    // scrollController.addListener(() {
    //   if (scrollController.offset > 72 && showAppbarTitle.value == false) {
    //     showAppbarTitle.value = true;
    //   } else if (scrollController.offset < 72 && showAppbarTitle.value == true) {
    //     showAppbarTitle.value = false;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: BackButtonWidget(),
          title: showAppbarTitle.value ? "Profile tasker".t : null,
          actions: [
            MenuAnchor(
              builder: (context, controller, child) {
                return IconButtonWidget(
                  icon: Icon(IconsaxPlusLinear.more),
                  onPressed: () {
                    menuAnchorController = controller;
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                );
              },
              menuChildren: [
                TextButton.icon(
                  onPressed: () {
                    menuAnchorController.close();
                    CRouter(context).goTo(TaskerProfileRoute(taskerId: deatails['tasker_id'] ?? '---'));
                  },
                  icon: Icon(IconsaxPlusLinear.user),
                  label: "Afficher mon profile PRO".t,
                ),
                TextButton.icon(
                  onPressed: () {
                    menuAnchorController.close();
                    CRouter(context).goTo(DeleteTaskerProfileRoute());
                  },
                  icon: Icon(IconsaxPlusLinear.trash),
                  label: "Supprimer ce profile PRO".t,
                ),
              ],
            ),
          ],
        ),

        // BODY.
        body: ListView(
          controller: scrollController,
          padding: EdgeInsets.symmetric(horizontal: 12),
          children: [
            72.gap,
            if (showAppbarTitle.value == false)
              Text(
                "Mon profile \nProfessionel",
                style: context.theme.textTheme.titleLarge?.copyWith(fontFamily: CConsts.FONT_INTER),
              ).animate().fadeIn(),

            // COVER PICTURE.
            9.gap,
            Card.filled(
                  color: CConsts.LIGHT_COLOR,
                  clipBehavior: Clip.hardEdge,
                  child: Builder(
                    builder: (context) {
                      if (deatails['cover_picture'] != null) {
                        return Image.network(
                          CNetworkFilesClass.picture(deatails['cover_picture'], scale: 36),
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(child: SpinnerWidget());
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [Icon(IconsaxPlusLinear.image, size: 45), 9.gap, "Erreur de chargement ...".t],
                              ),
                            );
                          },
                        );
                      }

                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(IconsaxPlusLinear.image, size: 45), 9.gap, "Photo de couverture".t],
                        ),
                      );
                    },
                  ),
                )
                .sized(height: 180, width: double.infinity)
                .cursorClick(onClick: isLoadingDetails.value ? null : selectCoverPicture)
                .asSkeleton(enabled: isLoadingDetails.value),
            if (isUploadingCoverPicture.value) LinearProgressIndicator(borderRadius: BorderRadius.circular(3), minHeight: 1),

            // STARS.
            9.gap,
            Row(
              children: [
                Card.filled(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(IconsaxPlusLinear.star),
                      Text("Cotes"),
                      Text("200", style: context.theme.textTheme.titleLarge),
                    ],
                  ).withPadding(all: 9),
                ).expanded(),
                8.gap,
                Card.filled(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(IconsaxPlusLinear.briefcase),
                      Text("Deals"),
                      Text("200", style: context.theme.textTheme.titleLarge),
                    ],
                  ).withPadding(all: 9),
                ).expanded(),
              ],
            ).sized(height: 126).asSkeleton(enabled: isLoadingDetails.value),
            9.gap,
            Text("Address"),
            Text("Address ref"),

            DividerWidget(alignment: TextAlign.start, child: "Competances".t).withPadding(vertical: 9),
            _InnerSkillsComponent(),

            DividerWidget(alignment: TextAlign.start, child: "Portfolios".t).withPadding(vertical: 9),
            _InnerPortfolioComponent(),

            DividerWidget(alignment: TextAlign.start, child: "Description".t).withPadding(vertical: 9),
            _InnerDescriptionComponent(),

            // SPACER.
            81.gap,
          ],
        ),
      ),
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;
  // METHODS =================================================================================================================
  void selectCoverPicture() {
    FilePicker.platform
        .pickFiles(
          dialogTitle: "Photo de profil",
          type: FileType.custom,
          allowedExtensions: ['png', 'jpeg', 'jpg'],
          compressionQuality: 60,
        )
        .then((image) async {
          if (image != null) {
            var tmp = await image.xFiles.first.readAsBytes();
            // uiUpdate();
            // changePicture();
            PictureCroperWidge.showOnModel(
              context,
              file: tmp,
              aspectRatio: 6 / 4,
              onCrop: (picture) {
                coverPicture = picture;
                uiUpdate();
                uploadCoverPicture();
              },
            );
          }
        }, onError: (e) {});
  }

  void loadDetails() {
    isLoadingDetails.value = true;

    Map<String, dynamic> params = {};
    var req = CApi.request.get('/user/tasker/jNbwX2G49', queryParameters: params);
    req.whenComplete(() => isLoadingDetails.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          // CToast(context).success("".t);
          deatails = res.data['data'] ?? {};
        } else {
          CToast(context).warning("Impossible de recuperer les meta-donnees.".t);
        }
      },
      onError: (e) {
        Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }

  void uploadCoverPicture() {
    if (coverPicture.isNotNull) {
      isUploadingCoverPicture.value = true;

      FormData params = FormData.fromMap({'picture': MultipartFile.fromBytes(coverPicture!, filename: 'picture')});
      var req = CApi.request.post('/user/tasker/fWFEkwLWP', data: params);
      req.whenComplete(() => isUploadingCoverPicture.value = false);
      req.then(
        (res) {
          // Logger().t(res.data);
          if (res.data is Map && res.data['success'] == true) {
            deatails['cover_picture'] = res.data['pid'];
          } else {
            CToast(context).warning("Impossible de faire le mises a jour de la photo de couverture.".t);
          }
        },
        onError: (e) {
          // Logger().e(e);
          CToast(context).error("Probleme de connexion.".t);
        },
      );
    }
  }
}

// * SKILLES *****************************************************************************************************************
class _InnerSkillsComponent extends StatefulWidget {
  const _InnerSkillsComponent();

  @override
  State<_InnerSkillsComponent> createState() => _InnerSkillsComponentState();
}

class _InnerSkillsComponentState extends State<_InnerSkillsComponent> with UiValueMixin {
  late var isLoadingDetails = uiValue(false);

  List skills = [];
  List userSkills = [];

  // WIDGET ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  @override
  void initState() {
    super.initState();
    loadDetails();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isLoadingDetails.value && userSkills.isEmpty)
          Wrap(
            spacing: 4.5,
            runSpacing: 3,
            children: [for (int index = 0; index < 4; index++) Chip(label: "Skill 1".t, onDeleted: () => '')],
          ).asSkeleton(enabled: true)
        else if (userSkills.isEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Ajouter des competances ici.",
                textAlign: TextAlign.center,
                style: context.theme.textTheme.titleMedium,
              ).muted,
            ],
          ),
        Wrap(
          spacing: 4.5,
          runSpacing: 4.5,
          children: [
            ...userSkills.map((e) {
              Map? skill; // = {"id": "", "short_description": '', "name": ""};
              for (int index = 0; index < skills.length; index++) {
                if (skills[index]['id'] == e) {
                  skill = skills[index];
                  break;
                }
              }
              if (skill.isNull) {
                return Chip(label: "Cet competence n'existe pas".t.color(Colors.red), onDeleted: () => remove(skill!['id']));
              }

              return Chip(label: "${skill!['name']}".t, onDeleted: () => remove(skill!['id']));
            }),
          ],
        ).animate().fadeIn(),
        9.gap,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton.icon(
              onPressed: () {
                CModalWidget.fullscreen(
                  context: context,
                  child: CInnerDropdownSelector(
                    expandIt: true,
                    title: "Competence".t,
                    subtitle: "Selectionnez une competence".t,
                    onFinish: (p0) => p0.firstOrNull == null ? '' : add(p0.first.value),
                    options: skills.map((e) {
                      return CDropdownOption(value: e['id'], label: e['name'], subtitle: e['short_description']);
                    }).toList(),
                  ).withPadding(all: 12),
                ).show();
              },
              label: "Ajouter".t,
              icon: Icon(IconsaxPlusLinear.add),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;
  // METHODS =================================================================================================================
  void loadDetails() {
    isLoadingDetails.value = true;

    Map<String, dynamic> params = {};
    var req = CApi.request.post('/user/tasker/34JF1K3Ww', data: params);
    req.whenComplete(() => isLoadingDetails.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          userSkills = res.data['data']['tasker_skills'] ?? [];
          skills = res.data['data']['skills'] ?? [];
        } else {
          CToast(context).warning("Une erreur a eta rencontre lors du chargement des competences.".t);
        }
      },
      onError: (e) {
        Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }

  void add(String id) {
    if (userSkills.contains(id) == false) {
      userSkills.add(id);
      uiUpdate();

      Map<String, dynamic> params = {'taskId': id};
      var req = CApi.request.post('/user/tasker/EB7bAyjWQ', data: params);
      req.whenComplete(() => '');
      req.then(
        (res) {
          // Logger().t(res.data);
          if (res.data is Map && res.data['success'] == true) {
            // CToast(context).success("".t);
          } else {
            CToast(context).warning("Impossible, veiller ressayer plus tard.".t);
            userSkills.removeWhere((element) => element == id);
            uiUpdate();
          }
        },
        onError: (e) {
          Logger().e(e);
          CToast(context).error("Probleme de connexion.".t);
        },
      );
    } else {
      CToast(context).warning("Vous avez deja cette competance".t);
    }
  }

  void remove(String id) {
    if (userSkills.contains(id)) {
      int indexOfItem = userSkills.indexOf(id);
      userSkills.removeWhere((element) => element == id);
      uiUpdate();

      Map<String, dynamic> params = {'taskId': id};
      var req = CApi.request.post('/user/tasker/3JsOMH6EK', data: params);
      req.whenComplete(() => '');
      req.then(
        (res) {
          // Logger().t(res.data);
          if (res.data is Map && res.data['success'] == true) {
            // CToast(context).success("".t);
          } else {
            CToast(context).warning("Impossible, veiller ressayer plus tard.".t);
            userSkills.insert(indexOfItem, id);
            uiUpdate();
          }
        },
        onError: (e) {
          Logger().e(e);
          CToast(context).error("Probleme de connexion.".t);
        },
      );
    } else {
      CToast(context).warning("Vous avez deja cette competance".t);
    }
  }
}

// * PORTFOLIO ***************************************************************************************************************
class _InnerPortfolioComponent extends StatefulWidget {
  const _InnerPortfolioComponent();

  @override
  State<_InnerPortfolioComponent> createState() => _InnerPortfolioComponentState();
}

class _InnerPortfolioComponentState extends State<_InnerPortfolioComponent> with UiValueMixin {
  late var isLoadingDetails = uiValue(false);

  MenuController anchorMenuController = MenuController();
  List portfolioList = [];
  late var loadingItemeKey = uiValue<String?>(null);
  // WIDTE +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  @override
  void initState() {
    super.initState();
    loadDetails();
    Dsi.registerCallback(DsiKeys.UPDATE_PORTFOLIOS_LIST_IN_EDIT.name, (p0) => loadDetails(showLoader: false));
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isLoadingDetails.value && portfolioList.isEmpty)
          ListTile(
            leading: Icon(IconsaxPlusLinear.note),
            title: "name".t,
            subtitle: "Sous titre".t,
            titleAlignment: ListTileTitleAlignment.top,
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            trailing: IconButtonWidget(icon: Icon(IconsaxPlusLinear.more), onPressed: () {}),
          ).asSkeleton(enabled: true)
        else if (portfolioList.isEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Ajouter des portfolios", style: context.theme.textTheme.titleMedium).muted],
          ),

        ...portfolioList.map((e) {
          return ListTile(
            leading: Icon(IconsaxPlusLinear.note),
            title: "${e['title']}".t.bold,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${e['description']}", maxLines: 1, overflow: TextOverflow.ellipsis),
                Chip(
                  padding: EdgeInsets.all(3.6),
                  label: Icon(IconsaxPlusLinear.briefcase, size: 14).stickThis("${e['orders']} deals".t),
                ),
              ],
            ),
            titleAlignment: ListTileTitleAlignment.top,
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            trailing: MenuAnchor(
              builder: (context, controller, child) {
                return IconButtonWidget(
                  icon: loadingItemeKey.value == e['id'] ? SpinnerWidget(size: 18) : Icon(IconsaxPlusLinear.more),
                  onPressed: loadingItemeKey.value == e['id']
                      ? null
                      : () {
                          anchorMenuController = controller;
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            controller.open();
                          }
                        },
                );
              },
              menuChildren: [
                TextButton.icon(
                  onPressed: () {
                    anchorMenuController.close();
                    CRouter(context).goTo(TaskerPortfolioReadRoute(portfolioId: e['id']));
                  },
                  icon: Icon(IconsaxPlusLinear.eye),
                  label: "Voir".t,
                ),
                TextButton.icon(
                  onPressed: () {
                    anchorMenuController.close();
                    CRouter(context).goTo(TaskerPortfolioEditRoute(portfolioId: e['id']));
                  },
                  icon: Icon(IconsaxPlusLinear.edit),
                  label: "Modifier".t,
                ),
                9.gap,
                TextButton.icon(
                  onPressed: () {
                    anchorMenuController.close();
                    _openDeleteAlert(e['id']);
                  },
                  icon: Icon(IconsaxPlusLinear.trash, color: context.theme.colorScheme.error),
                  label: "Supprimer".t,
                ),
              ],
            ),
          );
        }),

        // ADD ACTION.
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton.icon(
              onPressed: () => CRouter(context).goTo(TaskerPortfolioAddRoute()),
              label: "Ajouter".t,
              icon: Icon(IconsaxPlusLinear.add),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;
  // METHODS =================================================================================================================
  void loadDetails({bool showLoader = true}) {
    if (showLoader) isLoadingDetails.value = true;

    Map<String, dynamic> params = {};
    var req = CApi.request.get('/user/tasker/c6xmpwpFj', queryParameters: params);
    req.whenComplete(() => isLoadingDetails.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          portfolioList = res.data['data'] ?? [];
        } else {
          CToast(context).warning("Impossible de recupere les meta donnees des portfolios.".t);
        }
      },
      onError: (e) {
        Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }

  void _openDeleteAlert(String portfolioId) {
    CModalWidget(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Supprimer le portfolio ?", style: context.theme.textTheme.titleLarge),
          9.gap,
          Text("Voulez-vous vraiment supprimer ce portfolio ?"),
          18.gap,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () => Navigator.pop(context), child: "Annuler".t),
              9.gap,
              FilledButton.tonalIcon(
                onPressed: () {
                  Navigator.pop(context);
                  deleteItem(portfolioId);
                },
                icon: Icon(IconsaxPlusLinear.trash),
                label: "Supprimer".t,
              ),
            ],
          ),
        ],
      ).withPadding(all: 12).constrained(maxWidth: 270),
    ).show();
  }

  void deleteItem(String portfolioId) {
    loadingItemeKey.value = portfolioId;

    Map<String, dynamic> params = {'portfolioId': portfolioId};
    var req = CApi.request.post('/user/tasker/Uo3IHz7Q3', data: params);
    req.whenComplete(() => loadingItemeKey.value = null);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          CToast(context).success("Suppression reussie".t);
          portfolioList.removeWhere((element) => element['id'] == portfolioId);
        } else {
          CToast(context).warning("Impossible de supprimer le portfolio".t);
        }
      },
      onError: (e) {
        // Logger().e(e);
        CToast(context).error("Probleme de connexion".t);
      },
    );
  }
}

// * DESCRIPTION *************************************************************************************************************
class _InnerDescriptionComponent extends StatefulWidget {
  const _InnerDescriptionComponent();

  @override
  State<_InnerDescriptionComponent> createState() => _InnerDescriptionComponentState();
}

class _InnerDescriptionComponentState extends State<_InnerDescriptionComponent> with UiValueMixin {
  late var isLoadingDetails = uiValue(false);
  String? description;
  TextEditingController descriptionController = TextEditingController();

  bool somethingWasChanged = false;
  // WIDGET ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  @override
  void initState() {
    super.initState();
    loadDetails();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isLoadingDetails.value && description.isNull)
          Text(
            "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt "
            "ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo "
            "dolores et ea rebum. Stet clita kasd gubergren, no sea takimata",
            style: context.theme.textTheme.bodyMedium,
          ).asSkeleton(enabled: true),

        if (description.isNotNull)
          Text(
            description!,
            maxLines: 9,
            overflow: TextOverflow.ellipsis,
            style: context.theme.textTheme.bodyMedium,
          ).animate().fadeIn(),
        9.gap,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton.icon(
              onPressed: isLoadingDetails.value ? null : _openEditor,
              label: "Edit".t,
              icon: Icon(IconsaxPlusLinear.edit),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;
  // METHODS =================================================================================================================
  void loadDetails() {
    isLoadingDetails.value = true;

    var req = CApi.request.get('/user/tasker/UP8H0LKmh');
    req.whenComplete(() => isLoadingDetails.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          description = res.data['description'];
          descriptionController.text = description ?? '';
        } else {
          CToast(context).warning("Impossible de recuperer la description.".t);
        }
      },
      onError: (e) {
        Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }

  void updateDescription() {
    if (somethingWasChanged) {
      String? tmpDesc = description;
      uiUpdate(() {
        description = descriptionController.text;
      });

      Map<String, dynamic> params = {'description': descriptionController.text};
      var req = CApi.request.post('/user/tasker/JdM9wqook', data: params);
      req.whenComplete(() => uiUpdate(() => somethingWasChanged = false));
      req.then(
        (res) {
          // Logger().t(res.data);
          if (res.data is Map && res.data['success'] == true) {
            // CToast(context).success("".t);
          } else {
            CToast(context).warning("Impossible d'enregistrer les modifications.".t);
            description = tmpDesc;
          }
        },
        onError: (e) {
          Logger().e(e);
          CToast(context).error("Probleme de connexion.".t);
        },
      );
    }
  }

  void _openEditor() {
    CModalWidget.fullscreen(
      context: context,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: "Editer votre description".t.muted,
          leading: IconButtonWidget(
            icon: Icon(Icons.close_rounded),
            onPressed: () {
              Navigator.pop(context);
              updateDescription();
            },
          ).withPadding(all: 9),
          actions: [
            // FilledButton.tonalIcon(
            //   onPressed: () {
            //     updateDescription();
            //     Navigator.pop(context);
            //   },
            //   label: "Enregistrer".t,
            //   icon: Icon(IconsaxPlusLinear.save_add),
            // ),
          ],
        ),

        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12),
          children: [
            72.gap,
            Icon(IconsaxPlusLinear.edit).stickThis(
              Text("Description", style: context.theme.textTheme.titleLarge?.copyWith(fontFamily: CConsts.FONT_INTER)),
            ),
            18.gap,
            TextField(
              controller: descriptionController,
              minLines: 12,
              maxLines: null,
              onChanged: (value) => somethingWasChanged = true,
              decoration: InputDecoration(
                fillColor: CConsts.COLOR_SURFACE,
                border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.none)),
                hintText: "Entre votre description ...",
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.none)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.none)),
              ),
            ),
          ],
        ),
      ),
    ).show();
  }
}
