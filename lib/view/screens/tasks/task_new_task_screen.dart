import 'dart:typed_data';

import 'package:auto_route/annotations.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:logger/logger.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/configs/inline_notifier_keys.dart';
import 'package:questa/dsi/data_sync_interface.dart';
import 'package:questa/modules/audio_player_handler.dart';
import 'package:questa/modules/c_api.dart';
import 'package:questa/modules/c_misc_class.dart';
import 'package:questa/modules/c_navigate.dart';
import 'package:questa/modules/c_s_draft.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/screens/layouts/default_layout.dart';
import 'package:questa/view/theme/configs/tc_buttons.dart';
import 'package:questa/view/widgets/back_button_widget.dart';
import 'package:questa/view/widgets/c_dropdown_select_widget.dart';
import 'package:questa/view/widgets/c_modal_widget.dart';
import 'package:questa/view/widgets/c_toast.dart';
import 'package:questa/view/widgets/picture_croper_widge.dart';
import 'package:questa/view/widgets/spinner_widget.dart';
import 'package:run_it/run_it.dart';
import 'package:ui_value/ui_value.dart';
import 'package:record/record.dart';

@RoutePage(name: 'TaskNewTaskRoute')
class TaskNewTaskScreen extends StatefulWidget {
  const TaskNewTaskScreen({super.key, @QueryParam() this.skillId, @QueryParam() this.taskName});
  final String? skillId;
  final String? taskName;

  @override
  State<TaskNewTaskScreen> createState() => _TaskNewTaskScreenState();
}

class _TaskNewTaskScreenState extends State<TaskNewTaskScreen> with UiValueMixin {
  late var isLoading = uiValue(false);
  late var isCreating = uiValue(false);
  CDraft draft = CDraft('D51P2E7Sa701Hd4q31');

  MenuController menuController = MenuController();
  final _audioRecorder = AudioRecorder();

  Uint8List? _audioRecorded;
  String _currency = 'USD';
  final DateTime _taskTimeout = DateTime.now();
  DateTimeRange<DateTime>? _flexibleTaskDate;
  // final TextEditingController _taskTimeoutController = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _minPrice = TextEditingController();
  final TextEditingController _maxPrice = TextEditingController();
  final CDropdownController _emergencyLevel = CDropdownController(value: 'IMMEDIATE');
  final CDropdownController _visibilityScop = CDropdownController();
  final List<Map<String, dynamic>> _selectedPictures = [];
  final List<Map<String, dynamic>> _selectedDocuments = [];

  List _townsList = [];
  Map _currentSkill = {};
  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    _description.text = draft.data('description') ?? '';
    _minPrice.text = draft.data('min_price') ?? '';
    _maxPrice.text = draft.data('max_price') ?? '';

    super.initState();
    // AudioPlayerHandler.inst.loadFromStream(_audioRecorded!);
    loadDetail();

    _openUserWarningDialogMessage();
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    AudioPlayerHandler.inst.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(leading: BackButtonWidget(), actions: []), // BODY.
        // BODY.
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12),
          children: [
            72.gap,

            Row(
              children: [
                Icon(IconsaxPlusBroken.briefcase, size: 45, color: CConsts.LOGO_PRIMARY_COLOR),
                9.gap,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Publier une tâche",
                      style: context.theme.textTheme.titleLarge?.copyWith(
                        fontFamily: CConsts.FONT_COMFORTAA,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    "${widget.taskName ?? _currentSkill['name'] ?? 'Questa'}".t.muted,
                  ],
                ),
              ],
            ),

            // FIELDS.
            18.gap,
            "Description".t.muted,
            TextField(
              controller: _description,
              maxLines: 6,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 9),
                hintText: "Décrivez la tâche à réaliser...",
              ),
              onChanged: (value) => draft.keep('description', value),
            ),
            9.gap,
            _InnerAudioRecorder(this),

            // SET.
            18.gap,
            "Niveau d'urgence".t.muted,
            CDropdownSelectWidget(
              controller: _emergencyLevel,
              leading: Icon(IconsaxPlusLinear.chart),
              title: "Niveau d'urgence".t,
              placeholder: "Sélectionnez le niveau d'urgence",
              showDragHandle: false,
              showFilterField: false,
              options: [
                CDropdownOption(value: 'IMMEDIATE', label: 'Immédiat', subtitle: "À accomplir dans maximum 2 heures"),
                CDropdownOption(value: "TODAY", label: "Aujourd'hui", subtitle: "À accomplir au plus tard aujourd'hui"),
                CDropdownOption(value: "SHORT_TERM", label: "Très court terme", subtitle: "À accomplir dans 2 à 7 jours"),
                CDropdownOption(value: "FLEXIBLE", label: "Flexible/à convenir", subtitle: "Délai à convenir avec le Tasker"),
              ],
              onChanged: (value, values) async {
                await Future.delayed(270.ms);
                if (value == 'FLEXIBLE') {
                  showDateRangePicker(
                    context: context,
                    currentDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(360.days),
                  ).then((value) {
                    _flexibleTaskDate = value;
                    uiUpdate();
                  });
                } else {
                  uiUpdate(() {
                    _flexibleTaskDate = null;
                  });
                }
              },
            ),
            6.gap,
            if (_flexibleTaskDate != null)
              Card.filled(
                margin: EdgeInsets.zero,
                child: Text(
                  "Disponible du "
                  "${_flexibleTaskDate?.start.toReadable.numeric()} au "
                  "${_flexibleTaskDate?.end.toReadable.numeric()}",
                  textAlign: TextAlign.center,
                ).withPadding(all: 6.6),
              ).animate().fadeIn(),

            9.gap,
            "Zone de prestation".t.muted,
            CDropdownSelectWidget(
              controller: _visibilityScop,
              leading: Icon(IconsaxPlusLinear.eye),
              showFilterField: true,
              title: "Ville de prestation".t,
              subtitle: "Sélectionnez la ville de prestation".t,
              placeholder: "Sélectionnez la ville",
              showDragHandle: false,
              isMultiSelector: true,
              options: _townsList.map((e) {
                return CDropdownOption(
                  value: '${e['ville']?['id'] ?? '---'}',
                  label: "${e['ville']?['name']}",
                  subtitle: "${e['province']?['name'] ?? 'Pas de province'}, ${e['pays']?['name'] ?? 'Sans pays'}",
                );
              }).toList(),
            ),

            // MONEY.
            18.gap,
            Row(
              children: [
                "Budget".t.muted,
                Spacer(),
                MenuAnchor(
                  builder: (context, controller, child) {
                    return OutlinedButton.icon(
                      onPressed: () {
                        menuController = controller;
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                      icon: Icon(IconsaxPlusLinear.coin),
                      label: "Devise [$_currency]".t,
                    );
                  },
                  menuChildren: [
                    TextButton.icon(
                      onPressed: () {
                        menuController.close();
                        uiUpdate(() => _currency = 'USD');
                      },
                      icon: _currency == 'USD' ? Icon(Icons.check) : null,
                      label: "USD - Dollar américain".t,
                    ),
                    TextButton.icon(
                      onPressed: () {
                        menuController.close();
                        uiUpdate(() => _currency = 'CDF');
                      },
                      icon: _currency == 'CDF' ? Icon(Icons.check) : null,
                      label: "CDF - Franc congolais".t,
                    ),
                  ],
                ),
              ],
            ),
            12.gap,
            Row(
              children: [
                TextField(
                  controller: _maxPrice,
                  decoration: InputDecoration(hint: "Prix min".t, prefix: _currency.t),
                  inputFormatters: [CMiscClass.doubleInputFormater()],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.end,
                  onChanged: (value) => draft.keep('min_price', value),
                ).expanded(),
                9.gap,
                TextField(
                  controller: _minPrice,
                  decoration: InputDecoration(hint: "Prix max".t, prefix: _currency.t),
                  inputFormatters: [CMiscClass.doubleInputFormater()],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.end,
                  onChanged: (value) => draft.keep('max_price', value),
                ).expanded(),
              ],
            ),

            18.gap,
            "Joindre des fichiers".t.muted,
            Text(
              "Si des images ou des fichiers peuvent mieux décrire la tâche à réaliser, ajoutez-les ci-dessous.",
              style: context.theme.textTheme.labelSmall,
            ),
            9.gap,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 4.5,
              children: [
                ..._selectedPictures.map((e) {
                  return Chip(
                    avatar: CircleAvatar(backgroundImage: Image.memory(e['data']).image),
                    label: "${e['name']}".t,
                    onDeleted: () {
                      setState(() {
                        _selectedPictures.remove(e);
                      });
                    },
                  );
                }),
                ..._selectedDocuments.map((e) {
                  return Chip(
                    avatar: Icon(IconsaxPlusLinear.document),
                    label: "${e['name']}".t,
                    onDeleted: () {
                      setState(() {
                        _selectedDocuments.remove(e);
                      });
                    },
                  );
                }),
              ],
            ),
            9.gap,
            Row(
              children: [
                MenuAnchor(
                  builder: (context, controller, child) {
                    return OutlinedButton.icon(
                      onPressed: () {
                        menuController = controller;
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                      icon: Icon(IconsaxPlusLinear.add_circle),
                      label: "Joindre des fichiers".t,
                    );
                  },
                  menuChildren: [
                    TextButton.icon(
                      onPressed: () {
                        menuController.close();
                        selectPicture();
                      },
                      label: "Fichier image".t,
                      icon: Icon(IconsaxPlusLinear.image),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        menuController.close();
                        selectDocument();
                      },
                      label: "Fichier document".t,
                      icon: Icon(IconsaxPlusLinear.document),
                    ),
                  ],
                ),
              ],
            ),

            18.gap,
            Row(
              children: [
                FilledButton.tonal(
                  style: TcButtonsLight.blackButtonTheme,
                  onPressed: () {
                    startSaving();
                  },
                  child: "Publier la tâche".t,
                ).expanded(),
              ],
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
  void loadDetail() {
    isLoading.value = true;

    Map<String, dynamic> params = {'taskId': widget.skillId};
    var req = CApi.request.post('/task/uVnuG6tM4', data: params);
    req.whenComplete(() => isLoading.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          _townsList = res.data['data']['towns'] ?? [];
          _currentSkill = res.data['data']['skill'] ?? {};
          uiUpdate();
        } else {
          CToast(context).warning("Impossible de récupérer les métadonnées.".t);
        }
      },
      onError: (e) {
        Logger().e(e);
        CToast(context).error("Problème de connexion.".t);
      },
    );
  }

  void selectPicture() {
    FilePicker.platform
        .pickFiles(
          dialogTitle: "Sélectionner une image.",
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
                // selectedPictures['picture_${index + 1}'] = picture;
                // changePicture(pid, index);
                _selectedPictures.add({'name': image.xFiles.first.name, 'data': picture});
                uiUpdate();
              },
            );
          }
        }, onError: (e) {});
  }

  void selectDocument() {
    FilePicker.platform
        .pickFiles(
          dialogTitle: "Sélectionner un document.",
          type: FileType.custom,
          allowedExtensions: ['doc', 'pdf', 'docx'],
          compressionQuality: 60,
        )
        .then((document) async {
          if (document != null) {
            var tmp = await document.xFiles.first.readAsBytes();
            // changePicture(pid, index);
            _selectedDocuments.add({'name': document.xFiles.first.name, 'data': tmp});
            uiUpdate();
          }
        }, onError: (e) {});
  }

  void startSaving() {
    var tmpDateTime = DateTime.now();
    if (_taskTimeout.run((it) {
              if (it.day == tmpDateTime.day && it.month == tmpDateTime.month) return true;
              return false;
            }) &&
            _description.text.isEmpty ||
        _minPrice.text.isEmpty ||
        _maxPrice.text.isEmpty) {
      CToast(context).warning("Veuillez remplir les champs : Description, nivau d'urgence et le prix.".t);
      return;
    }

    _InnerPoster.openSaver(context, this);
  }

  void _openUserWarningDialogMessage() async {
    await Future.delayed(1830.ms);
    CModalWidget(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(IconsaxPlusBroken.award, color: CConsts.COLOR_GREY_LIGHT, size: 45)],
          ),
          12.gap,
          Text(
            "Pour une meilleure prise en charge, veuillez ne pas mentionner votre nom ou numéro de téléphone "
            "dans la description ou l’audio. Ces informations seront automatiquement transmises au Tasker une fois "
            "le marché conclu. Pour les tâches techniques, merci de fournir uniquement les informations générales "
            "dans la description. Les détails spécifiques pourront être partagés une fois la mise en relation établie, "
            "après la conclusion du marché.",
          ),
          9.3.gap,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () => CRouter(context).goBack(), child: "Non".t),
              Spacer(),
              OutlinedButton(onPressed: () => Navigator.pop(context), child: "Ok pour moi".t),
            ],
          ),
        ],
      ).withPadding(all: 12).sized(width: 363),
    ).show(persistant: true);
  }
}

// ********************************************* SAVING **********************************************************************
class _InnerPoster extends StatefulWidget {
  const _InnerPoster(this.parent);
  final _TaskNewTaskScreenState parent;

  @override
  State<_InnerPoster> createState() => __InnerPosterState();

  static void openSaver(BuildContext context, _TaskNewTaskScreenState parent) {
    CModalWidget(context, child: _InnerPoster(parent).sized(width: 207)).show(persistant: true);
  }
}

class __InnerPosterState extends State<_InnerPoster> with UiValueMixin {
  late var isStarting = uiValue(false);

  late var isFinished = uiValue(false);
  Map infos = {'file_name': '', 'percentage': 0, 'total_count': 0, 'current_count': 0, 'state_name': ''};
  String? taskId;
  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void initState() {
    super.initState();
    start();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (isFinished.value) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline_outlined, size: 36, color: Colors.green),
          12.gap,
          Text("Terminer"),
        ],
      ).withPadding(all: 12).animate().fadeIn();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SpinnerWidget(size: 36),
        12.gap,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            "${infos['percentage']}%".t,
            '${infos['state_name']}'.t.muted,
            "${infos['current_count']}/${infos['total_count']}".t,
          ],
        ),
        9.gap,
        "${infos['file_name']}".t.muted.elipsis,
      ],
    ).withPadding(all: 12);
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;
  // METHODS =================================================================================================================
  void start() {
    _taskPost();
  }

  void _taskPost() {
    // isStarting.value = true;
    uiUpdate(() {
      infos = {
        'file_name': 'Creation de la tache...',
        'state_name': 'tache',
        'percentage': 0,
        'total_count': 1 + widget.parent._selectedDocuments.length + widget.parent._selectedPictures.length,
        'current_count': 1,
      };
    });

    var parent = widget.parent;
    Map<String, dynamic> params = {
      'skillId': parent.widget.skillId,
      'scopTowns': parent._visibilityScop.values,
      'description': parent._description.text,
      'emergencyLevel': parent._emergencyLevel.singleValue,
      'currency': parent._currency,
      'maxPrice': parent._maxPrice.text,
      'minPrice': parent._minPrice.text,
      'startFlexibleDate': parent._flexibleTaskDate?.start.toIso8601String(),
      'endFlexibleDate': parent._flexibleTaskDate?.end.toIso8601String(),
    };
    var req = CApi.request.post('/task/i1BHgnVSi', data: params);
    req.whenComplete(() => isStarting.value = false);
    req.then(
      (res) {
        Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          taskId = res.data['id'];
          _audioPost(taskId ?? '---');
        } else {
          String? message;
          if (res.data['message'] != null) message = res.data['message'];
          CToast(context).warning((message ?? "Impossible de cree la tache.").t);

          // Close pop up.
          Navigator.pop(context);
        }
      },
      onError: (e) {
        Logger().e(e);
        CToast(context).error("Probleme de connnexion.".t);
      },
    );
  }

  void _documentPost(String taskId) async {
    if (widget.parent._selectedDocuments.isEmpty) {
      _picturePost(taskId);
      return;
    }

    uiUpdate(() {
      infos['state_name'] = 'Documents';
      infos['percentage'] = 0;
      // infos['current_count']++;
    });

    for (var element in widget.parent._selectedDocuments) {
      uiUpdate(() {
        infos['file_name'] = element['name'];
        infos['percentage'] = 0;
        infos['current_count']++;
      });

      FormData params = FormData.fromMap({
        'taskId': taskId,
        'document': MultipartFile.fromBytes(element['data'], filename: element['name']),
      });

      try {
        var res = await CApi.request.post(
          '/task/IqjR1XcdZ',
          data: params,
          onSendProgress: (count, total) {
            uiUpdate(() => infos['percentage'] = (count / total * 100).round());
          },
        );

        Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          // uiUpdate(() => infos['current_count']++);
        } else {
          CToast(context).warning("Impossible de televerser le document ${element['name']}".t);
        }
      } catch (e) {
        Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      }
    }

    _picturePost(taskId);
  }

  void _picturePost(String taskId) async {
    if (widget.parent._selectedPictures.isEmpty) {
      _finish();
      return;
    }

    uiUpdate(() {
      infos['state_name'] = 'Photos';
      infos['percentage'] = 0;
      // infos['current_count']++;
    });

    for (var element in widget.parent._selectedPictures) {
      uiUpdate(() {
        infos['file_name'] = element['name'];
        infos['percentage'] = 0;
        infos['current_count']++;
      });

      FormData params = FormData.fromMap({
        'taskId': taskId,
        'picture': MultipartFile.fromBytes(element['data'], filename: element['name']),
      });

      try {
        var res = await CApi.request.post(
          '/task/O0ZmctsRw',
          data: params,
          onSendProgress: (count, total) {
            uiUpdate(() => infos['percentage'] = (count / total * 100).round());
          },
        );

        Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          // uiUpdate(() => infos['current_count']++);
        } else {
          CToast(context).warning("Impossible de televerser la photo ${element['name']}".t);
        }
      } catch (e) {
        Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      }
    }

    _finish();
  }

  void _audioPost(String taskId) {
    if (widget.parent._audioRecorded == null) {
      _documentPost(taskId);
      return;
    }

    uiUpdate(() {
      infos['file_name'] = 'Contenue audio';
      infos['state_name'] = 'Enregistrement';
      infos['percentage'] = 0;
      infos['current_count']++;
    });

    var parent = widget.parent;
    FormData params = FormData.fromMap({
      'taskId': taskId,
      'audioDescription': parent._audioRecorded == null
          ? null
          : MultipartFile.fromBytes(parent._audioRecorded!, filename: 'audioDescription'),
    });

    var req = CApi.request.post(
      '/task/D51P2E7Sa701Hd4q31',
      data: params,
      onSendProgress: (count, total) {
        uiUpdate(() => infos['percentage'] = (count / total * 100).round());
      },
    );
    req.then(
      (res) {
        Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          // _documentPost(taskId);
        } else {
          CToast(context).warning("Impossible de televerser l'audio".t);
        }
        _documentPost(taskId);
      },
      onError: (e) {
        Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
        _documentPost(taskId);
      },
    );
  }

  void _finish() async {
    uiUpdate(() {
      widget.parent.draft.free();
      widget.parent.setState(() {});
      isFinished.value = true;
    });
    Dsi.call(DsiKeys.UPDATE_MY_TASKS_LIST_AT_HOME.name);
    await Future.delayed(2000.ms);
    Navigator.pop(context);
  }
}

// ******************************************* AUDIO RECOORDER ***************************************************************
class _InnerAudioRecorder extends StatefulWidget {
  const _InnerAudioRecorder(this.parent);
  final _TaskNewTaskScreenState parent;

  @override
  State<_InnerAudioRecorder> createState() => __InnerAudioRecorderState();
}

class __InnerAudioRecorderState extends State<_InnerAudioRecorder> with UiValueMixin {
  late var isRecording = uiValue(false);
  late var isPlaying = uiValue(false);
  final _audioRecorder = AudioRecorder();

  Uint8List? _audioRecorded;
  Uint8List? _audioRecordedTmp;
  // METHODS |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void initState() {
    super.initState();
    AudioPlayerHandler.inst.player?.playingStream.listen((event) {
      // print(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (_audioRecorded == null)
              "Ou faites un audio à la place".t.elipsis
            else ...[
              IconButton(
                onPressed: _playToggle,
                icon: isPlaying.value ? Icon(IconsaxPlusLinear.pause) : Icon(IconsaxPlusLinear.play),
              ).animate().fadeIn(),
              6.6.gap,
              IconButton(onPressed: _stop, icon: Icon(IconsaxPlusLinear.stop)).animate().fadeIn(),
              12.gap,
              IconButton(onPressed: _cancel, icon: Icon(Icons.close_rounded)).animate().fadeIn(),
            ],

            Spacer(),
            if (isRecording.value == false)
              FilledButton.tonalIcon(
                onPressed: _starRecording,
                icon: Icon(IconsaxPlusLinear.microphone),
                label: "Faire un audio".t,
                style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(CConsts.LIGHT_COLOR)),
              )
            else ...[
              "En cours...".t,
              6.6.gap,
              IconButton(
                onPressed: _stopRecording,
                icon: Icon(IconsaxPlusBold.stop_circle, color: Colors.redAccent),
              ).animate().fadeIn(),
            ],
          ],
        ),
      ],
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;
  // METHODS =================================================================================================================
  void _starRecording() async {
    if (isPlaying.value) {
      _stop();
    }

    // Check and request permission if needed
    if (await _audioRecorder.hasPermission()) {
      _audioRecorded = null;
      widget.parent._audioRecorded = null;
      uiUpdate();

      _audioRecordedTmp = null;
      final stream = await _audioRecorder.startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
      stream.listen((data) {
        _audioRecordedTmp = data;
      });

      isRecording.value = true;
    } else {
      CToast(context).error("Enregistrement audio non supporter ou non authorise.".t);
    }
  }

  void _stopRecording() async {
    await _audioRecorder.stop();
    _audioRecorded = _audioRecordedTmp;
    widget.parent._audioRecorded = _audioRecordedTmp;
    if (_audioRecorded != null) {
      // await AudioPlayerHandler.inst.player?.stop();
      // await AudioPlayerHandler.inst.loadFromStream(_audioRecorded!);
    }
    isRecording.value = false;
  }

  void _playToggle() async {
    if (isPlaying.value) {
      await AudioPlayerHandler.inst.player?.pause();
      isPlaying.value = false;
    } else {
      await AudioPlayerHandler.inst.player?.play();
      await AudioPlayerHandler.inst.player?.seek(Duration.zero);
      isPlaying.value = true;
    }
  }

  void _stop() async {
    await AudioPlayerHandler.inst.player?.stop();
    isPlaying.value = false;
  }

  void _cancel() {
    _stop();
    widget.parent._audioRecorded = null;
    _audioRecorded = null;
    _audioRecordedTmp = null;
    uiUpdate();
  }
}
