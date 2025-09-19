import 'dart:async';

import 'package:auto_route/annotations.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/configs/inline_notifier_keys.dart';
import 'package:questa/dsi/data_sync_interface.dart';
import 'package:questa/modules/c_api.dart';
import 'package:questa/modules/c_form_validator.dart';
import 'package:questa/modules/c_image_handler_class.dart';
import 'package:questa/modules/c_s_draft.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/screens/layouts/default_layout.dart';
import 'package:questa/view/widgets/back_button_widget.dart';
import 'package:questa/view/widgets/c_dropdown_select_widget.dart';
import 'package:questa/view/widgets/c_toast.dart';
import 'package:questa/view/widgets/icon_button_widget.dart';
import 'package:questa/view/widgets/picture_croper_widge.dart';
import 'package:questa/view/widgets/spinner_widget.dart';
import 'package:run_it/run_it.dart';
import 'package:ui_value/ui_value.dart';

@RoutePage()
class TaskerPortfolioEditScreen extends StatefulWidget {
  const TaskerPortfolioEditScreen({super.key, @QueryParam() this.portfolioId});
  static const String routeId = "WCALSZM1QOC7L7TH4UVTBIZT1AP";
  final String? portfolioId;

  @override
  State<TaskerPortfolioEditScreen> createState() => _TaskerPortfolioEditScreenState();
}

class _TaskerPortfolioEditScreenState extends State<TaskerPortfolioEditScreen> with UiValueMixin {
  late var isLoading = uiValue(false);

  CDraft draft = CDraft("HIY093A70BVHL4DN3ORF2Da6NKO");
  var formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  CDropdownController skillsController = CDropdownController();
  TextEditingController descriptionController = TextEditingController();

  Map portfolio = {};
  List picturesPids = [];
  List skillsList = [];

  Map<String, Uint8List?> selectedPictures = {
    'picture_1': null,
    'picture_2': null,
    'picture_3': null,
    'picture_4': null,
    'picture_5': null,
    'picture_6': null,
  };
  Map<String, bool> picturesUploadIndicator = {
    'picture_1': false,
    'picture_2': false,
    'picture_3': false,
    'picture_4': false,
    'picture_5': false,
    'picture_6': false,
  };

  Timer? autoSaveTimer;
  bool somethingChange = false;
  bool descriptionWasChanged = false;
  late var isSaving = uiValue(false);
  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void initState() {
    titleController.text = draft.data('title') ?? '';
    descriptionController.text = draft.data('description') ?? '';
    super.initState();
    loadDetails();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    autoSaveTimer?.cancel();
    _save();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(leading: BackButtonWidget(), title: "Modifier".t),

        // BODY.
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12),
          children: [
            72.gap,
            Text(
              "Modifier mon portfolio",
              style: context.theme.textTheme.titleLarge?.copyWith(fontFamily: CConsts.FONT_INTER),
            ),
            18.gap,
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (titleController.text.isNotEmpty) Text("Titre du portfolio").animate().fadeIn(),
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(hintText: "Titre", prefixIcon: Icon(IconsaxPlusLinear.note)),
                    onChanged: (value) => setState(() {
                      somethingChange = true;
                      draft.keep('title', value);
                      autoSave();
                    }),
                    validator: CFormValidator([CFormValidator.required()]).validate,
                  ),
                  9.gap,
                  Wrap(
                    runSpacing: 4.5,
                    spacing: 4.5,
                    children: [
                      for (int index = 0; index < 6; index++)
                        Card.filled(
                          clipBehavior: Clip.hardEdge,
                          child:
                              Center(
                                child: IconButtonWidget(
                                  icon: picturesUploadIndicator['picture_${index + 1}']!
                                      ? SpinnerWidget(size: 18)
                                      : Icon(IconsaxPlusLinear.add),
                                ),
                              ).run((it) {
                                if (picturesPids.elementAtOrNull(index) != null) {
                                  return Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Image.network(
                                          CNetworkFilesClass.picture(picturesPids.elementAtOrNull(index)),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                          onPressed: picturesUploadIndicator['picture_${index + 1}']!
                                              ? null
                                              : () => removePicture(picturesPids.elementAtOrNull(index), index),
                                          icon: picturesUploadIndicator['picture_${index + 1}']!
                                              ? SpinnerWidget(size: 18)
                                              : Icon(Icons.close_rounded),
                                        ).withPadding(all: 4.5),
                                      ),
                                    ],
                                  );
                                }
                                return it;
                              }),
                        ).sized(all: 126).onTap(() {
                          selectPicture(picturesPids.elementAtOrNull(index), index);
                        }),
                    ],
                  ),
                  9.gap,
                  if (skillsController.singleValue.isNotEmpty) Text("Domains").animate().fadeIn(),
                  CDropdownSelectWidget(
                    controller: skillsController,
                    enabled: !isLoading.value,
                    leading: Icon(IconsaxPlusLinear.briefcase),
                    title: "Domaines".t,
                    subtitle: "Selectionne le domaine concerne".t,
                    placeholder: "Domaines",
                    showFilterField: true,
                    showDragHandle: false,
                    onChanged: (value, values) {
                      somethingChange = true;
                      _save(controlSkill: true);
                    },
                    options: skillsList.map((e) {
                      return CDropdownOption(value: e['id'], label: e['name'], subtitle: e['short_description']);
                    }).toList(),
                  ),
                  9.gap,
                  if (descriptionController.text.isNotEmpty) Text("Votre description").animate().fadeIn(),
                  TextFormField(
                    controller: descriptionController,
                    minLines: 4,
                    maxLines: null,
                    decoration: InputDecoration(hintText: "Description ..."),
                    onChanged: (value) {
                      somethingChange = true;
                      descriptionWasChanged = true;
                      draft.keep('description', value);
                      uiUpdate();
                      // autoSave();
                    },
                    validator: CFormValidator([CFormValidator.required()]).validate,
                  ),
                  9.gap,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilledButton.tonalIcon(
                        onPressed: !descriptionWasChanged || isSaving.value
                            ? null
                            : () {
                                descriptionWasChanged = false;
                                _save();
                              },
                        icon: isSaving.value ? SpinnerWidget(size: 18) : Icon(IconsaxPlusLinear.save_2),
                        label: "Enregistrer la description".t,
                      ),
                    ],
                  ),
                ],
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
  // METHODS =================================================================================================================
  void loadDetails() {
    isLoading.value = true;

    Map<String, dynamic> params = {'portfolioId': widget.portfolioId};
    var req = CApi.request.get('/user/tasker/wVCesUJlI', queryParameters: params);
    req.whenComplete(() => isLoading.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          portfolio = res.data['data']['portfolio'] ?? {};
          picturesPids = res.data['data']['pictures'] ?? [];
          skillsList = res.data['data']['skills'] ?? [];

          skillsController.singleValue = portfolio['id_skill'] ?? '';
          titleController.text = portfolio['title'] ?? '';
          descriptionController.text = portfolio['description'] ?? '';
        } else {
          CToast(context).warning("Impossible de charger le portfolio.".t);
        }
      },
      onError: (e) {
        // Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }

  void selectPicture(String? pid, int index) {
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
            // changePicture(pid, index);

            PictureCroperWidge.showOnModel(
              context,
              file: tmp,
              aspectRatio: null,
              onCrop: (picture) {
                selectedPictures['picture_${index + 1}'] = picture;
                uiUpdate();
                changePicture(pid, index);
              },
            );
          }
        }, onError: (e) {});
  }

  void removePicture(String? pid, int index) {
    picturesUploadIndicator['picture_${index + 1}'] = true;
    uiUpdate();

    Map<String, dynamic> params = {'pid': pid};
    var req = CApi.request.post('/user/tasker/EsLT86Rzy', data: params);
    req.whenComplete(() => uiUpdate(() => picturesUploadIndicator['picture_${index + 1}'] = false));
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          picturesPids.removeWhere((element) => element == pid);
        } else {
          CToast(context).warning("Impossible de supprimer la photo.".t);
        }
      },
      onError: (e) {
        // Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }

  void changePicture(String? pid, int index) {
    picturesUploadIndicator['picture_${index + 1}'] = true;
    uiUpdate();

    FormData data = FormData.fromMap({
      'picture': MultipartFile.fromBytes(selectedPictures['picture_${index + 1}']!, filename: 'picture'),
      'pid': pid,
      'portfolioId': widget.portfolioId,
    });
    var req = CApi.request.post('/user/tasker/85SBW2gck', data: data);
    req.whenComplete(
      () => uiUpdate(() {
        selectedPictures['picture_${index + 1}'] = null;
        picturesUploadIndicator['picture_${index + 1}'] = false;
      }),
    );
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          picturesPids = res.data['pids'] ?? [];
          CToast(context).success("Photo mise à jour avec succès.".t);
        } else {
          CToast(context).warning("Un problème est survenu.".t);
        }
      },
      onError: (e) {
        // Logger().e(e);
        CToast(context).error("Erreur de connexion.".t);
      },
    );
  }

  void autoSave() {
    if (formKey.currentState?.validate() ?? false) {
      autoSaveTimer?.cancel();
      autoSaveTimer = Timer(1600.ms, _save);
    } else {
      CToast(context).warning("Certain champs sont vide.".t);
    }
  }

  void _save({bool controlSkill = false}) {
    if (somethingChange) {
      isSaving.value = true;

      Map<String, dynamic> params = {
        'portfolioId': widget.portfolioId,
        'title': titleController.text.trim(),
        'skillId': skillsController.singleValue,
        'controlSkill': controlSkill,
        'description': descriptionController.text.trim(),
      };
      var req = CApi.request.post('/user/tasker/UajIOtShT', data: params);
      req.whenComplete(() => isSaving.value = false);
      req.then(
        (res) {
          // Logger().t(res.data);
          if (res.data is Map && res.data['success'] == true) {
            somethingChange = false;
            Dsi.call(DsiKeys.UPDATE_PORTFOLIOS_LIST_IN_EDIT.name);
          } else {
            if (res.data['message'] != null) {
              CToast(context).warning("${res.data['message']}".t);
            } else {
              CToast(context).warning("Impossible d'enregistrer les modifications.".t);
            }
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
