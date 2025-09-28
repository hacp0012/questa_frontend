import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:logger/logger.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/modules/c_api.dart';
import 'package:questa/modules/c_image_handler_class.dart';
import 'package:questa/modules/c_misc_class.dart';
import 'package:questa/modules/c_navigate.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/auto_routes/a_r_app.gr.dart';
import 'package:questa/view/screens/layouts/default_layout.dart';
import 'package:questa/view/theme/configs/tc_buttons.dart';
import 'package:questa/view/widgets/back_button_widget.dart';
import 'package:questa/view/widgets/c_toast.dart';
import 'package:questa/view/widgets/chip_widget.dart';
import 'package:questa/view/widgets/spinner_widget.dart';
import 'package:ui_value/ui_value.dart';

@RoutePage()
class TaskPostulationResponsesScreen extends StatefulWidget {
  const TaskPostulationResponsesScreen({super.key, required this.taskId});
  final String taskId;

  @override
  State<TaskPostulationResponsesScreen> createState() => _TaskPostulationResponsesScreenState();
}

class _TaskPostulationResponsesScreenState extends State<TaskPostulationResponsesScreen> with UiValueMixin {
  late var isLoadingDetails = uiValue(false);
  late var isLoadingPostulations = uiValue(false);

  Map taskData = {};
  List requestsList = [];
  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void initState() {
    super.initState();
    _loadingResponses();
    _loadingDetails();
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
        appBar: AppBar(leading: BackButtonWidget(), title: Text("Candudatures a la tache")),

        // BODY.
        body: Builder(
          builder: (context) {
            if (requestsList.isEmpty && isLoadingPostulations.value == false) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(IconsaxPlusLinear.sms_tracking, color: CConsts.COLOR_GREY_LIGHT, size: 54),
                    12.gap,
                    Text("Aucun", style: context.theme.textTheme.titleLarge),
                    Text("postulat pour le moment", style: context.theme.textTheme.titleMedium),
                  ],
                ),
              );
            } else if (isLoadingPostulations.value) {
              return _loader();
            }

            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 12),
              children: [
                72.gap,

                // TASK
                Card.filled(
                  margin: EdgeInsets.zero,
                  color: CConsts.LIGHT_COLOR,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(IconsaxPlusBroken.briefcase, size: 21),
                          6.gap,
                          Text("Tache", style: context.theme.textTheme.titleLarge),
                          12.gap,
                          ChipWidget(
                            color: context.theme.colorScheme.surface,
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            child: Row(
                              children: [
                                Icon(IconsaxPlusLinear.eye, size: 18),
                                3.9.gap,
                                Text("Vus"),
                                4.8.gap,
                                Text(CMiscClass.numberAbrev(taskData['views_count'].toString().toDouble())),
                              ],
                            ),
                          ),
                        ],
                      ),
                      6.gap,
                      Text("${taskData['description'] ?? ''}", style: TextStyle(fontWeight: FontWeight.bold)),
                      6.gap,
                      Text("Publie ${taskData['posted_at'].toString().toDateTime()?.toReadable.ago()}"),
                      Text("Expire en ${taskData['expire_in_hours']} heurs"),
                      Text(
                        "Expire le ${taskData['expir_data'].toString().toDateTime()?.toReadable.numeric(format: "{day}/{month}/{year} a {hour}h {minute}")}",
                      ),
                    ],
                  ).withPadding(all: 12),
                ),
                12.gap,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FilledButton.tonal(
                      onPressed: () {
                        CRouter(context).goTo(TaskReadRoute(taskId: widget.taskId));
                      },
                      child: Text("Details de la tache"),
                    ),
                    FilledButton.icon(
                      onPressed: () {},
                      icon: Icon(IconsaxPlusLinear.messages),
                      label: Text("Discussions"),
                      style: TcButtonsLight.blackButtonTheme,
                    ),
                  ],
                ),

                // INFOS.
                24.gap,
                Row(
                  children: [
                    Icon(IconsaxPlusLinear.sms_tracking),
                    12.gap,
                    Text("${requestsList.length} Candudatures", style: context.theme.textTheme.titleLarge).bold.muted,
                  ],
                ),

                // RESPONSES.
                12.gap,
                ...requestsList.map((e) {
                  return Card.filled(
                    margin: EdgeInsets.symmetric(vertical: 4.8),
                    color: CConsts.LIGHT_COLOR,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: Image.network(CNetworkFilesClass.picture(e['user_picture'])).image,
                            ),
                          ],
                        ),
                        12.gap,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("${e['user_name'] ?? ''}", style: TextStyle(fontWeight: FontWeight.bold)),
                            ChipWidget(
                              color: context.theme.colorScheme.surface,
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star, size: 14, color: Colors.amber),
                                  6.gap,
                                  Text(CMiscClass.numberAbrev(e['count_stars'].toString().toDouble())),
                                  12.gap,
                                  Icon(IconsaxPlusLinear.briefcase, size: 12),
                                  6.gap,
                                  Text(CMiscClass.numberAbrev(e['count_deals'].toString().toDouble())),
                                  12.gap,
                                  Icon(IconsaxPlusLinear.like_1, size: 12),
                                  6.gap,
                                  Text(CMiscClass.numberAbrev(e['count_likes'].toString().toDouble())),
                                ],
                              ),
                            ),
                            Icon(
                              IconsaxPlusLinear.location,
                              size: 13,
                            ).stickThis(Text("${e['town_name'] ?? 'N/A'}").elipsis.expanded(), marginLeft: 6),
                            Text(
                              "Envoye ${e['send_at'].toString().toDateTime()?.toReadable.numeric(format: "{day}/{month}/{year} a {hour}h {minute}")}",
                              style: context.theme.textTheme.labelMedium,
                            ).muted,
                          ],
                        ).expanded(),
                      ],
                    ).withPadding(all: 6.6),
                  ).cursorClick(
                    onClick: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return _InnerValidatedRequest(taskId: e['request_id'].toString(), parent: this);
                        },
                      );
                    },
                    inkwell: true,
                  );
                }),

                // SPACER.
                81.gap,
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _loader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        72.gap,

        // TASK
        Card.filled(
          margin: EdgeInsets.zero,
          color: CConsts.LIGHT_COLOR,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(IconsaxPlusBroken.briefcase, size: 21),
                  6.gap,
                  Text("Tache", style: context.theme.textTheme.titleLarge),
                ],
              ),
              6.gap,
              Text("Description heres..."),
              6.gap,
              Text("posted at"),
              Text("Expire houre"),
              Text("Expire at"),
            ],
          ).withPadding(all: 12),
        ),
        12.gap,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FilledButton.tonal(onPressed: () {}, child: Text("Details de la tache")),
            FilledButton.icon(
              onPressed: () {},
              icon: Icon(IconsaxPlusLinear.messages),
              label: Text("Discussions"),
              style: TcButtonsLight.blackButtonTheme,
            ),
          ],
        ),

        // INFOS.
        24.gap,
        Row(
          children: [
            Icon(IconsaxPlusLinear.sms_tracking),
            12.gap,
            Text("12 Candudatures", style: context.theme.textTheme.titleLarge).bold.muted,
          ],
        ),

        // RESPONSES.
        12.gap,
        ...List.generate(2, (index) {
          return Card.filled(
            margin: EdgeInsets.symmetric(vertical: 4.8),
            color: CConsts.LIGHT_COLOR,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(mainAxisSize: MainAxisSize.min, children: [CircleAvatar(radius: 18)]),
                12.gap,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Pseudo Utilisateur", style: TextStyle(fontWeight: FontWeight.bold)),
                    ChipWidget(
                      color: context.theme.colorScheme.surface,
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.amber),
                          6.gap,
                          Text("12 K"),
                          12.gap,
                          Icon(IconsaxPlusLinear.briefcase, size: 12),
                          6.gap,
                          Text("12 K"),
                          12.gap,
                          Icon(IconsaxPlusLinear.like_1, size: 12),
                          6.gap,
                          Text("12 K"),
                        ],
                      ),
                    ),
                    Icon(IconsaxPlusLinear.location, size: 13).stickThis(Text("Bukavu").elipsis.expanded(), marginLeft: 6),
                    Text("Envoye 10/12/1212 a 17h 5", style: context.theme.textTheme.labelMedium).muted,
                  ],
                ).expanded(),
              ],
            ).withPadding(all: 6.6),
          ).cursorClick(onClick: () {}, inkwell: true);
        }),
      ],
    ).withPadding(horizontal: 12).asSkeleton();
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;

  // METHODS =================================================================================================================
  void _loadingDetails() {}

  void _loadingResponses({bool silent = false}) {
    if (silent == false) isLoadingPostulations.value = true;

    Map<String, dynamic> params = {'taskId': widget.taskId};
    var req = CApi.request.get('/task/M42jjqLFi', queryParameters: params);
    req.whenComplete(() => isLoadingPostulations.value = false);
    req.then(
      (res) {
        Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          taskData = res.data['data']?['task'] ?? {};
          requestsList = res.data['data']?['postulations'] ?? [];
        } else {
          CToast(context).warning("Impossible de recuperer les informations".t);
        }
      },
      onError: (e) {
        Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }

  void _removeItem(String postId) {
    uiUpdate(() {
      requestsList.removeWhere((element) {
        return element['request_id'].toString() == postId;
      });
    });
    // _loadingDetails();
  }
}

// ========================================= POSTED VALIDATED ================================================================
class _InnerValidatedRequest extends StatefulWidget {
  const _InnerValidatedRequest({required this.taskId, required this.parent});
  final String? taskId;
  final _TaskPostulationResponsesScreenState parent;

  @override
  State<_InnerValidatedRequest> createState() => _InnerValidatedRequestState();
}

class _InnerValidatedRequestState extends State<_InnerValidatedRequest> with UiValueMixin {
  late var isLoadingDetails = uiValue(false);
  late var isAccepting = uiValue(false);
  late var isRejecting = uiValue(false);

  Map details = {};
  // WIDGET ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Builder(
        builder: (context) {
          if (isLoadingDetails.value) {
            return _load();
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Postulate", style: context.theme.textTheme.titleLarge),
                  TextButton(onPressed: () => Navigator.pop(context), child: "Fermer".t),
                ],
              ),
              12.gap,
              Text("Poste il y a 1h").muted,
              if (details['message'] != null) ...[
                6.gap,
                Card.filled(
                  color: CConsts.LIGHT_COLOR,
                  margin: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Message joint a ce postulat", style: context.theme.textTheme.labelMedium).muted,
                      6.gap,
                      Text("${details['message'] ?? "N'a pas de message..."}"),
                    ],
                  ).withPadding(all: 6),
                ).sized(width: double.infinity),
              ],
              12.gap,
              Text(
                "Si vous accepte ce candidature, le message qui est au dessu sera transmis dans votre boit de "
                "discussion comme point d'entre de votre conversation. Si aucun message n'est fourni, un message texte "
                "sera fourni a la place.",
              ).muted,
              18.gap,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: (isLoadingDetails.value || isRejecting.value || isAccepting.value) ? null : _reject,
                    icon: isRejecting.value
                        ? SpinnerWidget(size: 18)
                        : Icon(IconsaxPlusLinear.trash, color: CConsts.LIGHT_COLOR),
                    label: "Rejecter".t.color(CConsts.LIGHT_COLOR),
                    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(context.theme.colorScheme.error)),
                  ).expanded(),
                  12.gap,
                  FilledButton.tonalIcon(
                    onPressed: (isLoadingDetails.value || isRejecting.value || isAccepting.value) ? null : _validete,
                    icon: isAccepting.value
                        ? SpinnerWidget(size: 18, color: CConsts.LIGHT_COLOR)
                        : Icon(IconsaxPlusLinear.card_tick_1),
                    label: "Accepter".t,
                    style: TcButtonsLight.blackButtonTheme,
                  ),
                ],
              ),
              12.gap,
            ],
          ).withPadding(all: 12).animate().fadeIn();
        },
      ),
    );
  }

  Widget _load() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Postulate", style: context.theme.textTheme.titleLarge),
            TextButton(onPressed: () => Navigator.pop(context), child: "Annuller".t),
          ],
        ),
        12.gap,
        Text("Poste il y a 1h").muted,
        6.gap,
        Card.filled(
          color: CConsts.LIGHT_COLOR,
          margin: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Message integrer", style: context.theme.textTheme.titleMedium).muted,
              6.gap,
              Text(
                "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut "
                "labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores "
                "et ea rebum. Stet clita kasd gubergren, no sea takimata",
              ),
            ],
          ).withPadding(all: 6),
        ),
        12.gap,
        Text(
          "Si vous accepte ce candidature, le message qui est au dessu sera transmis dans votre boit de "
          "discussion comme point d'entre de votre conversation. Si aucun message n'est fourni, un message texte "
          "sera fourni a la place.",
        ).muted,
        18.gap,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FilledButton.tonalIcon(
              onPressed: () {},
              icon: Icon(Icons.close_rounded),
              label: "Fermer".t.color(CConsts.LIGHT_COLOR),
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(context.theme.colorScheme.error)),
            ).expanded(),
            12.gap,
            FilledButton.tonalIcon(
              onPressed: isLoadingDetails.value ? null : () {},
              icon: Icon(IconsaxPlusLinear.card_tick_1),
              label: "Accepter".t,
              style: TcButtonsLight.blackButtonTheme,
            ),
          ],
        ),
        12.gap,
      ],
    ).withPadding(all: 12).asSkeleton();
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;
  // METHODS =================================================================================================================
  void _loadDetails() {
    isLoadingDetails.value = true;

    Map<String, dynamic> params = {'postId': widget.taskId ?? '---'};
    var req = CApi.request.get('/task/PtUuacnud', queryParameters: params);
    req.whenComplete(() => isLoadingDetails.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          details = res.data['data']?['postulation'] ?? {};
        } else {
          CToast(context).warning("Impossible de recuperer les informations".t);
        }
      },
      onError: (e) {
        Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }

  void _validete() {
    isAccepting.value = true;

    Map<String, dynamic> params = {'postId': details['id'] ?? '---'};
    var req = CApi.request.post('/task/QNUEdbKix', data: params);
    req.whenComplete(() => isAccepting.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          CToast(context).success("Candidature acceptee avec succes".t);
          widget.parent._removeItem(widget.taskId ?? "---");
          Navigator.pop(context);
        } else {
          CToast(context).warning("Impossible de valider la requete.".t);
        }
      },
      onError: (e) {
        Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }

  void _reject() {
    isRejecting.value = true;

    Map<String, dynamic> params = {'postId': widget.taskId ?? '---'};
    var req = CApi.request.post('/task/d7LUXFIGa', data: params);
    req.whenComplete(() => isRejecting.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          CToast(context).success("Postulation rejete avec succes".t);
          widget.parent._removeItem(widget.taskId ?? "---");
          Navigator.pop(context);
        } else {
          CToast(context).warning("Impossible de recuperer les informations".t);
        }
      },
      onError: (e) {
        Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }
}
