import 'package:auto_route/auto_route.dart';
import 'package:crop_image/crop_image.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:questa/dsi/data_sync_interface.dart';
import 'package:questa/models/user_mv.dart';
import 'package:questa/modules/c_api.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/screens/layouts/default_layout.dart';
import 'package:questa/view/widgets/back_button_widget.dart';
import 'package:questa/view/widgets/c_toast.dart';
import 'package:questa/view/widgets/picture_croper_widge.dart';
import 'package:questa/view/widgets/spinner_widget.dart';
import 'package:run_it/run_it.dart';
import 'package:ui_value/ui_value.dart';

@RoutePage()
class TaskerValidationIdsScreen extends StatefulWidget {
  const TaskerValidationIdsScreen({super.key});
  static const String routeId = 'Ws6M2A3P8XM3N0390P32jkP184A';

  @override
  State<TaskerValidationIdsScreen> createState() => _TaskerValidationIdsScreenState();
}

class _TaskerValidationIdsScreenState extends State<TaskerValidationIdsScreen> with UiValueMixin {
  late var isSending = uiValue(false);
  late var isUploadingSelfi = uiValue(false);
  late var isUploadingIdCard = uiValue(false);

  Uint8List? takedSelfi;
  Uint8List? selectedIdCardPicture;

  Map<String, bool> picturesUploadIndicator = {'selfi': false, 'card': false};
  final CropController cropController = CropController(aspectRatio: 6 / 4);

  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(leading: BackButtonWidget(), title: Icon(IconsaxPlusLinear.shield).stickThis("Identités".t)),

        // bDOY.
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12),
          children: [
            72.gap,

            Text(
              "Vos informations et photos seront conservées de manière sécurisée et utilisées uniquement pour la "
              "vérification de votre identité.",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),

            18.gap,
            Text("PHOTO SELFIE"),
            Text("La photo doit être claire, prise dans un cadre clair.").muted,
            Card.outlined(
              clipBehavior: Clip.hardEdge,
              child: Visibility(
                visible: takedSelfi == null,
                replacement: takedSelfi == null ? SizedBox.shrink() : Image.memory(takedSelfi!, fit: BoxFit.cover),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [Icon(IconsaxPlusLinear.image), 9.gap, "Prendre la photo".t.muted],
                  ),
                ),
              ),
            ).sized(height: 270).cursorClick(onClick: () => takeSelfi()),

            32.gap,
            Text("PHOTO PIÈCE D'IDENTITÉ"),
            Text("La photo doit être claire, prise dans un cadre clair.").muted,
            Card.outlined(
              clipBehavior: Clip.hardEdge,
              child: Visibility(
                visible: selectedIdCardPicture == null,
                replacement: selectedIdCardPicture == null
                    ? SizedBox.shrink()
                    : Image.memory(selectedIdCardPicture!, fit: BoxFit.cover),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [Icon(IconsaxPlusLinear.image), 9.gap, "Prendre la photo".t.muted],
                  ),
                ),
              ),
            ).sized(height: 270).cursorClick(onClick: () => selectIdCardPicture()),

            27.gap,
            Icon(
              IconsaxPlusLinear.info_circle,
            ).stickThis("Après la soumission de votre requête, votre identité sera vérifiée.".t.expanded()),
            9.gap,
            ElevatedButton(
              onPressed: isSending.value ? null : sendRequest,
              child: isSending.value ? SpinnerWidget(size: 18) : "Envoyer pour validation".t,
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
  void takeSelfi() {
    if (isSending.value) return;
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
                takedSelfi = picture;
                uiUpdate();
              },
            );
          }
        }, onError: (e) {});
  }

  void selectIdCardPicture() {
    if (isSending.value) return;
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
                selectedIdCardPicture = picture;
                uiUpdate();
              },
            );
          }
        }, onError: (e) {});
  }

  void sendRequest() {
    if (selectedIdCardPicture.isNull || takedSelfi.isNull) {
      CToast(context).warning("Les element demande doivent etre fournis.".t);
      return;
    }

    isSending.value = true;

    Map<String, dynamic> params = {};
    var req = CApi.request.post('/user/tasker/FSGBUrTNs', data: params);
    req.whenComplete(() => '');
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true && res.data['validation_id'] != null) {
          String id = res.data['validation_id'];
          sendIdCardPictures(id);
          sendSelefiPicture(id);
        } else {
          CToast(context).warning("Impossible d'envoyer votre requette de demande de validation.".t);
        }
      },
      onError: (e) {
        // Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }

  void sendIdCardPictures(String requestId) async {
    if (selectedIdCardPicture.isNull) {
      return;
    }
    isUploadingIdCard.value = true;

    FormData params = FormData.fromMap({
      'picture': MultipartFile.fromBytes(selectedIdCardPicture!, filename: 'picture'),
      'requestId': requestId,
    });

    var req = CApi.request.post('/user/tasker/pvlc9dPoQ', data: params);
    req.whenComplete(() {
      isUploadingIdCard.value = false;
      getBack();
    });
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          CToast(context, 1.sec).success("La photo de la carte d'identite envoye avec succes.".t);
        } else {
          CToast(context, 1.sec).warning("La photo n'a pas pu envoye avec succes.".t);
        }
      },
      onError: (e) {
        // Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }

  void sendSelefiPicture(String requestId) {
    if (takedSelfi.isNull) {
      return;
    }
    isUploadingSelfi.value = true;

    FormData params = FormData.fromMap({
      'picture': MultipartFile.fromBytes(takedSelfi!, filename: 'picture'),
      'requestId': requestId,
    });

    var req = CApi.request.post('/user/tasker/NfNfWKFbG', data: params);
    req.whenComplete(() {
      isUploadingSelfi.value = false;
      getBack();
    });
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          CToast(context, 1.sec).success("Photo envoye.".t);
        } else {
          CToast(context, 1.sec).warning("La photo n'a pas pu envoye avec succes.".t);
        }
      },
      onError: (e) {
        // Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }

  void getBack() {
    if (isUploadingIdCard.value == false && isUploadingSelfi.value == false) {
      context.back();
      CToast(context).success("Requete envoyer. En attente de validation.".t);
      Dsi.model<UserMv>()!.load();
    }
  }
}
