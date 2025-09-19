import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:logger/logger.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/configs/inline_notifier_keys.dart';
import 'package:questa/dsi/data_sync_interface.dart';
import 'package:questa/modules/c_api.dart';
import 'package:questa/modules/c_form_validator.dart';
import 'package:questa/modules/c_navigate.dart';
import 'package:questa/modules/c_s_draft.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/screens/layouts/default_layout.dart';
import 'package:questa/view/theme/configs/tc_buttons.dart';
import 'package:questa/view/widgets/back_button_widget.dart';
import 'package:questa/view/widgets/c_dropdown_select_widget.dart';
import 'package:questa/view/widgets/c_toast.dart';
import 'package:questa/view/widgets/icon_button_widget.dart';
import 'package:questa/view/widgets/picture_croper_widge.dart';
import 'package:questa/view/widgets/spinner_widget.dart';
import 'package:run_it/run_it.dart';
import 'package:ui_value/ui_value.dart';

@RoutePage()
class TaskerPortfolioAddScreen extends StatefulWidget {
  const TaskerPortfolioAddScreen({super.key});
  static const String routeId = "5yd04c6qn171j961I78991rrk5o";

  @override
  State<TaskerPortfolioAddScreen> createState() => _TaskerPortfolioAddScreenState();
}

class _TaskerPortfolioAddScreenState extends State<TaskerPortfolioAddScreen> with UiValueMixin {
  CDraft draft = CDraft("HIY093A70BVHL4DN3ORF2Da6NKO");
  TextEditingController titleController = TextEditingController();
  CDropdownController skillController = CDropdownController();
  TextEditingController descriptionController = TextEditingController();

  Map<String, Uint8List?> pictures = {
    'picture_1': null,
    'picture_2': null,
    'picture_3': null,
    'picture_4': null,
    'picture_5': null,
    'picture_6': null,
  };

  var formKey = GlobalKey<FormState>();
  late var isCreating = uiValue(false);
  late var isLoadingDetails = uiValue(false);
  List skillsList = [];
  Map<String, bool> picturesUploadIndicator = {
    'picture_1': false,
    'picture_2': false,
    'picture_3': false,
    'picture_4': false,
    'picture_5': false,
    'picture_6': false,
  };
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
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: BackButtonWidget(),
          title: "Nouvelle".t,
          // actions: ["7/7".t.muted, 9.gap SpinnerWidget(size: 18)],
        ),

        // BODY.
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12),
          children: [
            72.gap,
            Text("Ajouter portfolio", style: context.theme.textTheme.titleLarge?.copyWith(fontFamily: CConsts.FONT_INTER)),
            18.gap,
            Form(
              key: formKey,
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (titleController.text.isNotEmpty) Text("Titre du portfolio").animate().fadeIn(),
                  TextFormField(
                    controller: titleController,
                    validator: CFormValidator([CFormValidator.required()]).validate,
                    decoration: InputDecoration(hintText: "Titre", prefixIcon: Icon(IconsaxPlusLinear.note)),
                    onChanged: (value) => setState(() => draft.keep('title', value)),
                  ),

                  // PICTURES.
                  9.gap,
                  Wrap(
                    runSpacing: 4.5,
                    spacing: 4.5,
                    children: [
                      for (int index = 0; index < 6; index++)
                        Card.filled(
                          clipBehavior: Clip.hardEdge,
                          child: Center(child: IconButtonWidget(icon: Icon(IconsaxPlusLinear.add))).run((it) {
                            if (pictures['picture_${index + 1}'] != null) {
                              return Stack(
                                children: [
                                  Positioned.fill(child: Image.memory(pictures['picture_${index + 1}']!, fit: BoxFit.cover)),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      onPressed: isCreating.value
                                          ? null
                                          : () => setState(() => pictures['picture_${index + 1}'] = null),
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
                          if (isCreating.value == false) selectPicture("picture_${index + 1}");
                        }),
                    ],
                  ),
                  27.gap,
                  if (skillController.singleValue.isNotEmpty) Text("Domains").animate().fadeIn(),
                  CDropdownSelectWidget(
                    controller: skillController,
                    leading: Icon(IconsaxPlusLinear.briefcase),
                    enabled: isLoadingDetails.value == false,
                    placeholder: "Sélectionnez le domaine de competance",
                    title: "Domain".t,
                    subtitle: "Choisissez le domaines de competance.".t,
                    showFilterField: true,
                    showDragHandle: false,
                    onChanged: (value, values) => uiUpdate(),
                    options: skillsList.map((e) {
                      return CDropdownOption(value: e['id'], label: "${e['name']}", subtitle: "${e['short_description']}");
                    }).toList(),
                  ),
                  9.gap,
                  if (descriptionController.text.isNotEmpty) Text("Votre description").animate().fadeIn(),
                  TextFormField(
                    controller: descriptionController,
                    minLines: 4,
                    maxLines: null,
                    decoration: InputDecoration(hintText: "Description ..."),
                    validator: CFormValidator([CFormValidator.required()]).validate,
                    onChanged: (value) => setState(() => draft.keep('description', value)),
                  ),
                ],
              ),
            ),

            // SAVE.
            27.gap,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FilledButton.tonalIcon(
                  onPressed: isLoadingDetails.value || isCreating.value ? null : startCreating,
                  icon: isCreating.value ? SpinnerWidget(size: 18) : Icon(IconsaxPlusLinear.add),
                  label: "AJOUTER LE PORTFOLIO".t,
                  style: TcButtonsLight.blackButtonTheme,
                ),
              ],
            ),

            // SPCER.
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
    isLoadingDetails.value = true;

    Map<String, dynamic> params = {};
    var req = CApi.request.get('/user/tasker/rJhvHZav4', queryParameters: params);
    req.whenComplete(() => isLoadingDetails.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          skillsList = res.data['data']['skills'] ?? [];
        } else {
          CToast(context).warning("Impossible de charger les meta donnees de la page.".t);
        }
      },
      onError: (e) {
        // Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }

  void selectPicture(String key) {
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
            PictureCroperWidge.showOnModel(
              context,
              file: tmp,
              aspectRatio: null,
              onCrop: (picture) {
                pictures[key] = picture;
                uiUpdate();
              },
            );
          }
        }, onError: (e) {});
  }

  void startCreating() {
    if (formKey.currentState!.validate() && skillController.singleValue.isNotEmpty) {
      isCreating.value = true;

      _creationPortfolioItem();
    } else {
      CToast(context, 1800.ms).warning("Certains champs sont obligatoir.".t);
    }
  }

  void _creationPortfolioItem() {
    Map<String, dynamic> params = {
      'title': titleController.text,
      'skillId': skillController.singleValue,
      'description': descriptionController.text,
    };
    var req = CApi.request.post('/user/tasker/iZ5N44jGq', data: params);
    req.whenComplete(() => '');
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          CToast(context).success("Etap 1 effectue avec succes.".t);

          _uploadingPictures(res.data['portfolio_id']);
        } else {
          if (res.data['message'] != null) {
            CToast(context, 4.seconds).warning("${res.data['message']}".t);
          } else {
            CToast(context).warning("Une erreur c'est produit lors de la creation.".t);
          }
          isCreating.value = false;
        }
      },
      onError: (e) {
        // Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }

  Future<void> _uploadingPictures(String portfolioId) async {
    for (int index = 0; index < pictures.keys.length; index++) {
      String key = pictures.keys.toList()[index];
      if (pictures[key] != null) {
        picturesUploadIndicator[key] = true;
        uiUpdate();

        try {
          FormData params = FormData.fromMap({
            'picture': MultipartFile.fromBytes(pictures[key]!, filename: 'picture'),
            'portfolioId': portfolioId,
          });
          Response res = await CApi.request.post('/user/tasker/0ebC0HVk4', data: params);
          // Logger().t(res.data);
          if (res.data is Map && res.data['success'] == true) {
            CToast(context).success("Photo No.${index + 1} televerse avec succès.".t);
          } else {
            CToast(context).warning("La photo No.${index + 1} n'a pas pus etre televerse.".t);
          }
          picturesUploadIndicator[key] = false;
          uiUpdate();
        } catch (e) {
          Logger().e(e);
          picturesUploadIndicator[key] = false;
          uiUpdate();
        }
      }
    }

    await Future.delayed(1600.ms);
    _cleanAndBack();
  }

  void _cleanAndBack() {
    isCreating.value = false;
    draft.free();
    Dsi.call(DsiKeys.UPDATE_PORTFOLIOS_LIST_IN_EDIT.name);
    CRouter(context).goBack();
  }

  /*void changePicture() {
    // isChangingPicture.value = true;

    FormData data = FormData.fromMap({'picture': MultipartFile.fromBytes(selectedPicture!, filename: 'picture')});
    var req = CApi.request.post('/user/gRv1SfVqr', data: data);
    // req.whenComplete(() => isChangingPicture.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          CToast(context).success("Photo de profil mise à jour avec succès.".t);
          // UserMv().load(onFinish: () => uiUpdate(() => userData = UserMv().data));
        } else {
          CToast(context).warning("Un problème est survenu.".t);
        }
      },
      onError: (e) {
        // Logger().e(e);
        CToast(context).error("Erreur de connexion.".t);
      },
    );
  }*/
}
