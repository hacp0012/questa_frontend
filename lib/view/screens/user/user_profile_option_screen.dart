import 'dart:async';

import 'package:auto_route/annotations.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:logger/logger.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/dsi/data_sync_interface.dart';
import 'package:questa/models/user_mv.dart';
import 'package:questa/modules/c_api.dart';
import 'package:questa/modules/c_form_validator.dart';
import 'package:questa/modules/c_image_handler_class.dart';
import 'package:questa/modules/c_misc_class.dart';
import 'package:questa/modules/c_navigate.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/auto_routes/a_r_app.gr.dart';
import 'package:questa/view/widgets/back_button_widget.dart';
import 'package:questa/view/widgets/c_dropdown_select_widget.dart';
import 'package:questa/view/widgets/c_toast.dart';
import 'package:questa/view/widgets/divider_widget.dart';
import 'package:questa/view/widgets/icon_button_widget.dart';
import 'package:questa/view/widgets/picture_croper_widge.dart';
import 'package:questa/view/widgets/spinner_widget.dart';
import 'package:run_it/run_it.dart';
import 'package:ui_value/ui_value.dart';

@RoutePage()
class UserProfileOptionScreen extends StatefulWidget {
  const UserProfileOptionScreen({super.key});
  static const String routeId = "NC4CW28D56JY53S303";

  @override
  State<UserProfileOptionScreen> createState() => _UserProfileOptionScreenState();
}

class _UserProfileOptionScreenState extends State<UserProfileOptionScreen> with UiValueMixin {
  late var isFichingPseudos = uiValue(false);
  late var isScanningGPS = uiValue(false);
  late var isLoadingAvenues = uiValue(false);
  late var isUploadingPicture = uiValue(false);
  late var isSavingContents = uiValue(false);
  late var isChangingPicture = uiValue(false);

  MenuController appbarMenuController = MenuController();
  var formKey = GlobalKey<FormState>();
  Map userData = UserMv().data;
  Timer? autoSaveTimer;

  TextEditingController nameController = TextEditingController();
  TextEditingController pseudoController = TextEditingController();
  CDropdownController avenueController = CDropdownController();
  TextEditingController addressController = TextEditingController();
  TextEditingController gpsCoordsController = TextEditingController();
  TextEditingController phoneCodeController = TextEditingController(text: '243');
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool changeDetected = false;

  List avenuesList = [];
  Uint8List? selectedPicture;

  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void initState() {
    nameController.text = userData['name'] ?? '';
    pseudoController.text = userData['pseudo'] ?? '';
    avenueController.singleValue = ((userData['address'] ?? {}) as Map)['avenue'].toString();
    addressController.text = userData['address_ref'] ?? '';
    gpsCoordsController.text = userData['gps_coord'] ?? '';
    ((userData['telephone'] ?? "") as String).split(',').let((it) {
      phoneCodeController.text = it.firstOrNull ?? '';
      phoneNumberController.text = it.elementAtOrNull(1) ?? '';
    });
    emailController.text = userData['email'] ?? '';

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
    autoSaver();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userData = Dsi.of<UserMv>(context)?.data ?? {};

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: BackButtonWidget(),
        title: const Text('Editer mon profile'),
        actions: [
          // OutlinedButton(onPressed: () {}, child: "Voir".t),
          9.gap,
          MenuAnchor(
            builder: (context, controller, child) {
              return IconButton(
                onPressed: () {
                  appbarMenuController = controller;
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(IconsaxPlusLinear.more),
              );
            },
            menuChildren: [
              TextButton.icon(
                onPressed: () {
                  appbarMenuController.close();
                  CRouter(context).goTo(UserProfileReadRoute(userId: userData['id']));
                },
                label: "Affichier mon profile".t,
                icon: Icon(IconsaxPlusLinear.user),
              ),
              TextButton.icon(onPressed: null, label: "Appareils connectes".t, icon: Icon(IconsaxPlusLinear.devices)),
              TextButton.icon(
                onPressed: () {
                  appbarMenuController.close();
                  CRouter(context).goTo(UserDeleteProfileRoute());
                },
                label: "Supprimer mon compte".t,
                icon: Icon(IconsaxPlusLinear.trash, color: context.theme.colorScheme.error),
              ),
            ],
          ),
        ],
      ),

      // BODY.
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 12),
        children: [
          81.gap,

          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Badge(
                label: isChangingPicture.value ? SpinnerWidget(size: 18) : Icon(IconsaxPlusLinear.camera),
                offset: Offset(-24, -27),
                alignment: Alignment.bottomRight,
                backgroundColor: CConsts.LIGHT_COLOR,
                child: CircleAvatar(
                  radius: 63,
                  backgroundImage: userData['picture'] == null
                      ? null
                      : Image.network(
                          CNetworkFilesClass.picture(userData['picture'], scale: 36, defaultImage: 'logo'),
                          errorBuilder: (context, error, stackTrace) => Icon(IconsaxPlusLinear.user, size: 54),
                        ).image,
                  child: userData['picture'] != null ? null : Icon(IconsaxPlusLinear.user, size: 54),
                ),
              ).onTap(isChangingPicture.value ? null : selectPicture),
              9.gap,
            ],
          ),

          Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                18.gap,
                "NOM".t.muted,
                TextFormField(
                  controller: nameController,
                  validator: CFormValidator([CFormValidator.required(), CFormValidator.min(3)]).validate,
                  decoration: InputDecoration(hintText: "Nom", prefixIcon: Icon(IconsaxPlusLinear.user)),
                  onChanged: (value) => _autoSaver(),
                ),

                18.gap,
                DividerWidget(alignment: TextAlign.start, child: "Pseudo".t),
                9.gap,
                "PSEUDO".t.muted,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: pseudoController,
                      readOnly: true,
                      validator: CFormValidator([CFormValidator.required()]).validate,
                      decoration: InputDecoration(hintText: "Pseudonoym", prefixIcon: Icon(IconsaxPlusLinear.user_tag)),
                      onChanged: (value) => _autoSaver(),
                    ).expanded(),
                    9.gap,
                    IconButtonWidget(icon: Icon(IconsaxPlusLinear.refresh)),
                  ],
                ),

                18.gap,
                DividerWidget(alignment: TextAlign.start, child: "Adresse".t),
                9.gap,
                "VOTRE AVENUE".t.muted,
                CDropdownSelectWidget(
                  controller: avenueController,
                  leading: Icon(IconsaxPlusLinear.map),
                  placeholder: "Avanue",
                  title: "Avenue".t,
                  subtitle: "Selectionner votre avenue".t,
                  showDragHandle: false,
                  showFilterField: true,
                  enabled: !isLoadingAvenues.value,
                  onChanged: (value, values) => _autoSaver(),
                  options: avenuesList.map((e) {
                    return CDropdownOption(
                      value: e['avenue']['id'].toString(),
                      label: "${e['avenue']['name']}",
                      subtitle: "${e['ville']['name']}, ${e['province']['name']}, ${e['pays']['name']}",
                    );
                  }).toList(),
                ),
                9.gap,
                "ADRESSE".t.muted,
                TextFormField(
                  controller: addressController,
                  validator: CFormValidator([CFormValidator.required(), CFormValidator.min(2)]).validate,
                  decoration: InputDecoration(
                    hintText: "Adresse",
                    prefixIcon: Icon(IconsaxPlusLinear.edit),
                    helperText: "Donnez plus des precision a votre adresse.",
                  ),
                  minLines: 1,
                  maxLines: 4,
                  onChanged: (value) => _autoSaver(),
                ),

                9.gap,
                "GPS".t.muted,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: gpsCoordsController,
                      readOnly: true,
                      // validator: CFormValidator([CFormValidator.required()]).validate,
                      decoration: InputDecoration(
                        hintText: "Coordonnes geographique",
                        prefixIcon: Icon(IconsaxPlusLinear.map_1),
                      ),
                      onChanged: (value) => _autoSaver(),
                    ).expanded(),
                    9.gap,
                    IconButtonWidget(icon: Icon(IconsaxPlusLinear.refresh)),
                  ],
                ),

                18.gap,
                DividerWidget(alignment: TextAlign.start, child: "Contacts".t),
                9.gap,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: phoneCodeController,
                      validator: CFormValidator([CFormValidator.required()]).validate,
                      inputFormatters: [CMiscClass.intInputFormater(length: 3)],
                      decoration: InputDecoration(hintText: "Code", prefixIcon: Icon(IconsaxPlusLinear.call)),
                      onChanged: (value) => _autoSaver(),
                    ).expanded(flex: 2),
                    9.gap,
                    TextFormField(
                      controller: phoneNumberController,
                      validator: CFormValidator([CFormValidator.required(), CFormValidator.min(9)]).validate,
                      inputFormatters: [CMiscClass.intInputFormater(length: 9)],
                      decoration: InputDecoration(hintText: "Nom", prefixIcon: Icon(IconsaxPlusLinear.arrow_right)),
                      onChanged: (value) => _autoSaver(),
                    ).expanded(flex: 3),
                  ],
                ),
                9.gap,
                "E-MAIL".t.muted,
                TextFormField(
                  controller: emailController,
                  validator: CFormValidator([CFormValidator.required()]).validate,
                  decoration: InputDecoration(hintText: "Email", prefixIcon: Icon(Icons.mail)),
                  onChanged: (value) => _autoSaver(),
                ),
              ],
            ),
          ),

          //Spacer.
          81.gap,
        ],
      ),
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;
  // METHODS =================================================================================================================
  void loadDetails() {
    isLoadingAvenues.value = true;

    Map<String, dynamic> params = {};
    var req = CApi.request.get('/user/LHQsiyM0V', queryParameters: params);
    req.whenComplete(() => isLoadingAvenues.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          avenuesList = res.data['data']['avenues'] ?? [];
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

  void _autoSaver() {
    if (autoSaveTimer.isNotNull) autoSaveTimer?.cancel();

    autoSaveTimer = Timer(1600.ms, () => autoSaver());
    changeDetected = true;
  }

  void autoSaver() {
    if ((formKey.currentState?.validate() ?? false) && avenueController.singleValue.isNotEmpty && changeDetected) {
      isSavingContents.value = true;

      Map<String, dynamic> params = {
        'name': nameController.text,
        'pseudo': pseudoController.text,
        'avenueId': avenueController.singleValue,
        'addressRef': addressController.text,
        'gpsCoord': gpsCoordsController.text,
        'telephone': "${pseudoController.text},${phoneCodeController.text}",
        'email': emailController.text,
      };
      var req = CApi.request.post('/user/h2QVCUY38', data: params);
      req.whenComplete(() => isSavingContents.value = false);
      req.then(
        (res) {
          // Logger().t(res.data);
          if (res.data is Map && res.data['success'] == true) {
            if (res.data['user_data'] != null) {
              Dsi.of<UserMv>(context)?.data = res.data['user_data'];
            }
          } else {
            CToast(context).warning("Une erreur est survenu lors de l'enregistrement de vos modifications.".t);
          }
        },
        onError: (e) {
          // Logger().e(e);
          CToast(context).error("Probleme de connexion.".t);
        },
      );
    } else {
      CToast(context, 1.sec).warning("Vous avez de champs obligatoris.".t);
    }

    // SIgnal change.
    changeDetected = false;
  }

  void gpsCoords() {}

  void pseudosGen() {}

  void selectPicture() {
    FilePicker.platform
        .pickFiles(
          dialogTitle: "Photo de profil",
          type: FileType.custom,
          allowedExtensions: ['png', 'jpeg', 'jpg'],
          compressionQuality: 60,
        )
        .then((image) async {
          if (image.isNotNull) {
            Uint8List tmp = await image!.xFiles.first.readAsBytes();
            PictureCroperWidge.showOnModel(
              context,
              file: tmp,
              aspectRatio: 1,
              onCrop: (picture) {
                selectedPicture = picture;
                changePicture();
              },
            );
          }
        }, onError: (e) {});
  }

  void changePicture() {
    isChangingPicture.value = true;

    FormData data = FormData.fromMap({'picture': MultipartFile.fromBytes(selectedPicture!, filename: 'picture')});
    var req = CApi.request.post('/user/gRv1SfVqr', data: data);
    req.whenComplete(() => isChangingPicture.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          CToast(context).success("Photo de profil mise à jour avec succès.".t);
          Dsi.of<UserMv>(context)?.load();
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
}
