import 'package:auto_route/annotations.dart';
import 'package:easy_money_formatter/easy_money_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:logger/logger.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/modules/c_api.dart';
import 'package:questa/modules/c_image_handler_class.dart';
import 'package:questa/modules/c_misc_class.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/theme/configs/tc_buttons.dart';
import 'package:questa/view/widgets/audio_player_widget.dart';
import 'package:questa/view/widgets/c_modal_widget.dart';
import 'package:questa/view/widgets/c_toast.dart';
import 'package:questa/view/widgets/divider_widget.dart';
import 'package:questa/view/widgets/icon_button_widget.dart';
import 'package:questa/view/widgets/photo_viewer_widget.dart';
import 'package:questa/view/widgets/spinner_widget.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:ui_value/ui_value.dart';

@RoutePage()
class TaskReadScreen extends StatefulWidget {
  const TaskReadScreen({super.key, @QueryParam() this.taskId});
  final String? taskId;

  @override
  State<TaskReadScreen> createState() => _TaskReadScreenState();
}

class _TaskReadScreenState extends State<TaskReadScreen> with UiValueMixin {
  late var isLoadingDetails = uiValue(false);

  late var isCanPostulate = uiValue(true); // Reset to false
  late var postulationProcess = uiValue(false);
  String? valueMessage; // This message is shown when user have postulated on this task.
  Map taskData = {};
  List pictures = [];
  List documents = [];
  List townsNames = [];
  String? audioPid;

  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void initState() {
    super.initState();
    _postulateState();
    loadTask();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButtonWidget(
          icon: Icon(IconsaxPlusLinear.arrow_left),
          onPressed: () => Navigator.pop(context),
        ).withPadding(all: 9),
        centerTitle: true,
        title: "Detatils de la tache".t,
        actions: [IconButtonWidget(icon: Icon(IconsaxPlusLinear.more))],
      ),

      body: Builder(
        builder: (context) {
          if (isLoadingDetails.value && taskData.isEmpty) {
            return loader();
          } else if (taskData.isEmpty) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(IconsaxPlusBroken.slash, size: 72, color: CConsts.COLOR_GREY_LIGHT),
                  12.gap,
                  Text("Pas de tache disponible"),
                  6.gap,
                  FilledButton.tonalIcon(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded),
                    label: "Fermer".t,
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: EdgeInsets.all(12),
            children: [
              60.gap,
              // TITLE.
              Row(
                children: [
                  Text(
                    "${taskData['title'] ?? 'Sans titre'}",
                    style: context.theme.textTheme.titleMedium?.copyWith(
                      fontFamily: CConsts.FONT_INTER,
                      fontWeight: FontWeight.bold,
                    ),
                  ).expanded(),
                  IconButton.outlined(
                    icon: Icon(taskData['is_saved'] == true ? IconsaxPlusBold.save_2 : IconsaxPlusLinear.save_2),
                    onPressed: () {},
                    style: TcButtonsLight.outlinedButton,
                  ),
                ],
              ),

              // Details.
              9.gap,
              Text("Poste ${taskData['posted_at'].toString().toDateTime()?.toReadable.ago()}").muted,
              Row(
                children: [
                  Icon(IconsaxPlusLinear.clock_1, size: 14),
                  4.5.gap,
                  "Expire dans ${taskData['expire_in'] ?? '~'} heures".t.muted,
                  4.5.gap,
                  Text(
                    taskData['expire_at'].toString().toDateTime()?.toReadable.numeric(
                          format: "{hour}h {minute} {day}/{month}/{year}",
                        ) ??
                        '~',
                  ).bold,
                ],
              ),
              Builder(
                builder: (context) {
                  String currency = switch (taskData['budget']?['currency']) {
                    'CDF' => 'Fc',
                    'USD' => '\$',
                    _ => '\$',
                  };
                  return Row(
                    children: [
                      Icon(IconsaxPlusLinear.money, size: 14),
                      4.5.gap,
                      "Valeur".t.muted,
                      4.5.gap,
                      Text(
                        "$currency ${taskData['budget']?['min']?.toString().toDouble().toMoney() ?? '~'} - $currency ${taskData['budget']?['max']?.toString().toDouble().toMoney() ?? '~'}",
                      ).bold,
                    ],
                  );
                },
              ),
              9.gap,
              DividerWidget(alignment: TextAlign.start, child: "Details".t.muted),
              9.gap,

              // PUCTURES.
              Visibility(
                visible: pictures.isNotEmpty,
                child: ResponsiveGridRow(
                  children: [
                    ...pictures.map((e) {
                      return ResponsiveGridCol(
                        xs: 6,
                        sm: 6,
                        md: 4,
                        child:
                            ClipRRect(
                                  borderRadius: BorderRadiusGeometry.circular(18),
                                  child: Image.network(CNetworkFilesClass.picture(e), fit: BoxFit.cover).sized(height: 126),
                                )
                                .withPadding(all: 9)
                                .cursorClick(
                                  onClick: () {
                                    PhotoViewerWidget.fullscreenModal(
                                      context,
                                      title: "${taskData['title'] ?? 'Tache'}",
                                      urls: [CNetworkFilesClass.picture(e)],
                                    );
                                  },
                                ),
                      );
                    }),
                  ],
                ),
              ),

              // AUDIO.
              if (audioPid == null) ...[9.3.gap, AudioPlayerWidget()],

              // DESCRIPTIONS.
              9.3.gap,
              Text("${taskData['description'] ?? "Pas de description fournis"}"),

              // TOWNS.
              12.gap,
              Wrap(
                spacing: 4.5,
                runSpacing: 4.5,
                children: townsNames.map((e) => Chip(avatar: Icon(IconsaxPlusLinear.location), label: "$e".t)).toList(),
              ),

              9.3.gap,
              DividerWidget(alignment: TextAlign.start, child: "Documments".t.muted),

              // DOCUMENTS.
              9.3.gap,
              ...documents.map((e) {
                return ListTile(
                  dense: true,
                  leading: Icon(IconsaxPlusLinear.document, color: Colors.blue),
                  title: "${e['name'] ?? 'Sans nom'}".t,
                  contentPadding: EdgeInsets.symmetric(horizontal: 6),
                  subtitle: Text(
                    "${e['ext'] ?? 'Sans extension'} ${CConsts.CENTER_DOT} ${CMiscClass.numberAbrev(e['size'].toString().toDouble())}",
                  ),
                  trailing: IconButtonWidget(
                    onPressed: () => _downloadDocument(e['pid']),
                    icon: Icon(IconsaxPlusLinear.document_download),
                  ),
                );
              }),

              // INFOS.
              9.gap,
              Icon(IconsaxPlusLinear.info_circle).stickThis(
                "Pour l'instant vous ne pouvez voir le profile de "
                        "celui qui a publier cette tache. Vous le verre une fois votre candidature valide."
                    .t
                    .muted
                    .expanded(),
                vCenter: false,
              ),

              // SPACER.
              81.gap,
            ],
          );
        },
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (valueMessage != null) ...[Text(valueMessage ?? "").muted.animate().fadeIn(), 6.gap],
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: (!isCanPostulate.value || postulationProcess.value) ? null : _openPostulate,
                    style: !isCanPostulate.value ? null : TcButtonsLight.blackButtonTheme,
                    icon: postulationProcess.value ? SpinnerWidget(size: 18, color: CConsts.LIGHT_COLOR) : null,
                    label: "Postuler".t,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;

  Widget loader() {
    return ListView(
      padding: EdgeInsets.all(12),
      children: [
        60.gap,
        Row(
          children: [
            Text(
              "Agent marketing expert dans le domaine des ventes",
              style: context.theme.textTheme.titleMedium?.copyWith(
                fontFamily: CConsts.FONT_INTER,
                fontWeight: FontWeight.bold,
              ),
            ).expanded(),
            IconButton.outlined(icon: Icon(IconsaxPlusLinear.save_2), onPressed: () {}, style: TcButtonsLight.outlinedButton),
          ],
        ),
        9.gap,
        Text("Poste il y a 1h").muted,
        Row(
          children: [
            Icon(IconsaxPlusLinear.clock_1, size: 14),
            4.5.gap,
            "Expir a ".t.muted,
            4.5.gap,
            "12h 30 - 12/12/2024".t.bold,
          ],
        ),
        Row(children: [Icon(IconsaxPlusLinear.money, size: 14), 4.5.gap, "Valeur".t.muted, 4.5.gap, "\$1 - \$20".t.bold]),
        9.gap,
        DividerWidget(alignment: TextAlign.start, child: "Details".t.muted),
        9.gap,
        Text(
          "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor "
          "invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos "
          "et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata "
          "sanctus est Lorem ipsum dolor sit amet."
          '\n\n'
          "Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie "
          "consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et "
          "accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit "
          "augue duis dolore te feugait nulla facilisi."
          '\n\n'
          "Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper susc",
        ),

        9.gap,
        DividerWidget(alignment: TextAlign.start, child: "Documments".t.muted),
        9.gap,
        ListTile(
          dense: true,
          leading: Icon(IconsaxPlusLinear.document, color: Colors.blue),
          title: "accumsan et iusto odio dignissim".t,
          subtitle: "PDF".t,
          trailing: IconButtonWidget(onPressed: () {}, icon: Icon(IconsaxPlusLinear.document_download)),
        ),

        // INFOS.
        9.gap,
        Icon(IconsaxPlusLinear.info_circle).stickThis(
          "Pour l'instant vous ne pouvez voir le profile de "
                  "celui qui a publier cette tache. Vous le verre une fois votre candidature valide."
              .t
              .muted
              .expanded(),
          vCenter: false,
        ),

        // SPACER.
        81.gap,
      ],
    ).asSkeleton();
  }

  // METHODS =================================================================================================================
  void loadTask() {
    isLoadingDetails.value = true;

    Map<String, dynamic> params = {'taskId': widget.taskId};
    var req = CApi.request.get('/task/XMAHdEd62', queryParameters: params);
    req.whenComplete(() => isLoadingDetails.value = false);
    req.then(
      (res) {
        Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          taskData = res.data['data'] ?? {};
          audioPid = taskData['audio'];
          pictures = taskData['pictures'] ?? [];
          documents = taskData['documents'] ?? [];
          townsNames = taskData['town_name'] ?? [];
        } else {
          CToast(context).warning("Impossible de trouver la tache".t);
        }
      },
      onError: (e) {
        Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }

  void _postulateState() {
    postulationProcess.value = true;

    Map<String, dynamic> params = {'taskId': widget.taskId};
    var req = CApi.request.get('/task/6xt2JInlK', queryParameters: params);
    req.whenComplete(() => postulationProcess.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          valueMessage = res.data['value_message'];
          isCanPostulate.value = res.data['can'] ?? false;
        } else {
          CToast(context).warning("Ne parviens pas a verifier l'etat.".t);
        }
      },
      onError: (e) {
        Logger().e(e);
      },
    );
  }

  void _downloadDocument(String pid) {
    // CApi.request.download(CNetworkFilesClass.file(pid), 'savePath');
  }

  void _postulate({required String message}) {
    postulationProcess.value = true;

    Map<String, dynamic> params = {'taskId': widget.taskId, 'message': message};
    var req = CApi.request.post('/task/DBHPEfaJv', data: params);
    req.whenComplete(() => postulationProcess.value = false);
    req.then(
      (res) {
        Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          CToast(context).success("Postule avec succes.".t);
          isCanPostulate.value = false;
          _postulateState();
        } else {
          CToast(context).warning("Ne parviens pas a postuler.".t);
        }
      },
      onError: (e) {
        Logger().e(e);
      },
    );
  }

  void _openPostulate() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _InnerTaskReadPostulate(taskId: widget.taskId, parent: this);
      },
    );
  }
}

// ------------------------------------- POSTULATE ---------------------------------------------------------------------------
class _InnerTaskReadPostulate extends StatefulWidget {
  const _InnerTaskReadPostulate({required this.taskId, required this.parent});
  final String? taskId;
  final _TaskReadScreenState parent;

  @override
  State<_InnerTaskReadPostulate> createState() => _InnerTaskReadPostulateState();
}

class _InnerTaskReadPostulateState extends State<_InnerTaskReadPostulate> {
  TextEditingController messageController = TextEditingController();

  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Postuler", style: context.theme.textTheme.titleLarge),
        12.gap,
        Visibility(
          visible: messageController.text.isNotEmpty,
          replacement: Text("Vous pouvez jointez un texte pour votre candidature"),
          child: Card.filled(
            margin: EdgeInsets.zero,
            color: CConsts.LIGHT_COLOR,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Votre message joint",
                  style: context.theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ).muted,
                12.gap,
                Text(messageController.text),
              ],
            ).withPadding(all: 6),
          ).sized(width: double.infinity),
        ),
        12.gap,
        FilledButton.tonalIcon(
          onPressed: () {
            _openPostTexte();
          },
          icon: Icon(IconsaxPlusLinear.text),
          label: "Postuler avec un texte joint".t,
        ),
        12.gap,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: () => Navigator.pop(context), child: "Fermer".t),
            12.gap,
            FilledButton.tonalIcon(
              onPressed: () {
                _postulate();
                Navigator.pop(context);
              },
              icon: Icon(IconsaxPlusLinear.send_1),
              style: TcButtonsLight.blackButtonTheme,
              label: "Postuler".t,
            ).expanded(),
          ],
        ),
      ],
    ).withPadding(all: 12);
  }

  // METHODS =================================================================================================================
  void _openPostTexte() {
    CModalWidget(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Ecrir votre requete", style: context.theme.textTheme.titleMedium),
          12.gap,
          TextField(
            controller: messageController,
            maxLines: 7,
            minLines: 4,
            decoration: InputDecoration(hintText: "Votre message..."),
          ),
          12.gap,
          Row(
            children: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text("Annuler")),
              12.gap,
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    messageController.clear();
                  });
                  Navigator.pop(context);
                },
                icon: Icon(IconsaxPlusLinear.broom),
                label: "Vider".t,
              ),
              12.gap,
              FilledButton.tonalIcon(
                onPressed: () {
                  setState(() {});
                  Navigator.pop(context);
                },
                icon: Icon(IconsaxPlusLinear.send),
                label: "Terminer".t,
              ),
            ],
          ),
        ],
      ).withPadding(all: 6),
    ).show(persistant: true, insetPadding: EdgeInsets.symmetric(horizontal: 12));
  }

  void _postulate() {
    widget.parent._postulate(message: messageController.text);
  }
}
