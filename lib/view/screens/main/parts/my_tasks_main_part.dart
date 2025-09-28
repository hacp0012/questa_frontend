part of '../main_screen.dart';

@RoutePage(name: "MyTasksMainPartRoute")
class MyTasksMainPart extends StatefulWidget {
  const MyTasksMainPart({super.key});
  static const String routeId = "811l1132t10L136ucm";

  @override
  State<MyTasksMainPart> createState() => _MyTasksMainPartState();
}

class _MyTasksMainPartState extends State<MyTasksMainPart> with AutomaticKeepAliveClientMixin<MyTasksMainPart>, UiValueMixin {
  late var isLoadingDetails = uiValue(false);
  late var isLoadingMines = uiValue(false);
  late var isLoadingDealeds = uiValue(false);

  List minesList = [];
  List dealedsList = [];
  Map detailsData = {};

  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void initState() {
    super.initState();

    loadDetails();
    loadMyTasks();
    Dsi.registerCallback(DsiKeys.UPDATE_MY_TASKS_LIST_AT_HOME.name, (p0) => loadMyTasks());
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScrollView(
      slivers: [
        AppbarMainScrennPart(),

        // BODY.
        SliverList(
          delegate: SliverChildListDelegate([
            Row(
              children: [
                Text(
                  "Mes \ntaches",
                  style: context.theme.textTheme.titleLarge?.copyWith(
                    fontFamily: CConsts.FONT_INTER,
                    fontWeight: FontWeight.bold,
                    fontSize: 27,
                  ),
                ).expanded(),
                9.gap,
                FilledButton.tonalIcon(
                  style: TcButtonsLight.blackButtonTheme,
                  onPressed: () {
                    CRouter(context).goTo(TaskSkillsMenuRoute(title: "Selectionnez un domain"));
                    Dsi.registerCallback(TaskSkillsMenuScreen.onSelectCallbackKey, (p0) {
                      CRouter(context).replace(TaskNewTaskRoute(skillId: p0.toString()));
                    });
                  },
                  icon: Icon(IconsaxPlusLinear.add, color: CConsts.LIGHT_COLOR),
                  label: "Publier tache".t,
                ),
                // IconButtonWidget(
                //   isBlack: true,
                //   icon: Icon(IconsaxPlusLinear.add, color: CConsts.LIGHT_COLOR),
                //   onPressed: () {
                //     CRouter(context).goTo(TaskSkillsMenuRoute(title: "Selectionnez un domain"));
                //     Dsi.registerCallback(TaskSkillsMenuScreen.onSelectCallbackKey, (p0) {
                //       CRouter(context).replace(TaskNewTaskRoute(taskId: p0.toString()));
                //     });
                //   },
                // ),
                // 9.gap,
                // IconButtonWidget(icon: Icon(IconsaxPlusLinear.search_normal), onPressed: () {}),
              ],
            ).withPadding(all: 12),

            // OPTIONS BUTTONS.
            18.gap,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    Badge(
                      backgroundColor: context.theme.colorScheme.primary,
                      label: CMiscClass.numberAbrev(detailsData['tasks_count'] ?? 0).t,
                      child: IconButtonWidget(
                        icon: Icon(IconsaxPlusLinear.folder),
                        onPressed: () => loadMyTasks(silent: true),
                      ),
                    ),
                    9.gap,
                    Chip(label: "Mes offres".t),
                    9.gap,
                    Chip(label: "Deals (services)".t),
                  ],
                ).withPadding(vertical: 4.5),
              ),
            ),

            // CARDS.
            if (isLoadingMines.value && minesList.isEmpty)
              _InnageMyTasksMyOfferWidget.holder(context)
            else if (minesList.isEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(IconsaxPlusBroken.brifecase_cross, size: 90, color: CConsts.COLOR_GREY_LIGHT),
                    Text("Vous n'avez pas encore de taches", style: context.theme.textTheme.titleMedium),
                    12.gap,
                    FilledButton.tonalIcon(
                      onPressed: () {
                        CRouter(context).goTo(TaskSkillsMenuRoute(title: "Selectionnez un domain"));
                        Dsi.registerCallback(TaskSkillsMenuScreen.onSelectCallbackKey, (p0) {
                          CRouter(context).replace(TaskNewTaskRoute(skillId: p0.toString()));
                        });
                      },
                      icon: Icon(IconsaxPlusBroken.add),
                      label: "Publier une tache".t,
                    ),
                  ],
                ),
              ).sized(height: 180)
            else
              ...minesList.map((e) {
                return _InnageMyTasksMyOfferWidget(parent: this, data: e).animate().fadeIn();
              }),
            DividerWidget(
              alignment: TextAlign.start,
              child: "Deals en cours".t.muted,
            ).withPadding(horizontal: 18, vertical: 9),
            _InnerMyTaskDealsWidget(),

            // SPACER.
            27.gap,
          ]),
        ),
      ],
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;

  @override
  bool get wantKeepAlive => true;
  // METHODS =================================================================================================================
  void loadDetails() {
    isLoadingDetails.value = true;

    Map<String, dynamic> params = {};
    var req = CApi.request.get('/task/MBxD0zfaAa', queryParameters: params);
    req.whenComplete(() => isLoadingDetails.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          detailsData = res.data['data'] ?? {};
        } else {
          // CToast(context).warning("".t);
        }
      },
      onError: (e) {
        Logger().e(e);
      },
    );
  }

  void loadMyTasks({bool silent = false}) {
    if (!silent) isLoadingMines.value = true;

    Map<String, dynamic> params = {};
    var req = CApi.request.get('/task/rBWkJQaP4', queryParameters: params);
    req.whenComplete(() => isLoadingMines.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          minesList = res.data['data'] ?? [];
        } else {
          CToast(context).warning("Impossible de charger vos taches".t);
        }
      },
      onError: (e) {
        Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }

  void loadTasks() {}
}

// --------- MY OFFERS ------------
class _InnageMyTasksMyOfferWidget extends StatefulWidget {
  const _InnageMyTasksMyOfferWidget({required this.parent, required this.data});
  final _MyTasksMainPartState parent;
  final Map data;

  @override
  State<_InnageMyTasksMyOfferWidget> createState() => _InnageMyTasksMyOfferWidgetState();

  static Widget holder(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      padding: EdgeInsets.all(9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [CConsts.COLOR_BLUE_LIGHT, CConsts.COLOR_BLUE_LIGHT.withAlpha(200)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(child: Icon(IconsaxPlusBroken.user)),
              IconButtonWidget(icon: "+5".t),
              Spacer(),
              IconButtonWidget(icon: Icon(IconsaxPlusLinear.more)),
            ],
          ),
          18.gap,
          Text("Plublier il y'a 4h").muted,
          Row(
            children: [
              Text("Besoin d'un maitre avocatier", style: context.theme.textTheme.titleLarge).expanded(),
              9.gap,
              Text("Widget", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          18.gap,
          Row(
            children: [
              Card.filled(
                color: CConsts.LIGHT_COLOR,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        IconButton.outlined(
                          style: ButtonStyle(side: WidgetStatePropertyAll(BorderSide(color: CConsts.COLOR_GREY_LIGHT))),
                          onPressed: () {},
                          icon: Icon(IconsaxPlusBroken.hashtag_up, color: CConsts.COLOR_GREY_LIGHT),
                        ),
                        9.gap,
                        "Total vue".t.expanded(),
                      ],
                    ),
                    9.gap,
                    Text(
                      "123",
                      style: context.theme.textTheme.titleLarge?.copyWith(fontSize: 36, fontWeight: FontWeight.normal),
                    ),
                  ],
                ).withPadding(all: 9),
              ).expanded(),
              9.gap,
              Card.filled(
                color: CConsts.LIGHT_COLOR,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        IconButton.outlined(
                          style: ButtonStyle(side: WidgetStatePropertyAll(BorderSide(color: CConsts.COLOR_GREY_LIGHT))),
                          onPressed: () {},
                          icon: Icon(IconsaxPlusLinear.clock, color: CConsts.COLOR_GREY_LIGHT),
                        ),
                        9.gap,
                        "Exprir dans".t.expanded(),
                      ],
                    ),
                    9.gap,
                    Text(
                      "3 heures",
                      style: context.theme.textTheme.titleLarge?.copyWith(fontSize: 30, fontWeight: FontWeight.normal),
                    ),
                  ],
                ).withPadding(all: 9),
              ).expanded(),
            ],
          ),
        ],
      ),
    ).asSkeleton();
  }
}

class _InnageMyTasksMyOfferWidgetState extends State<_InnageMyTasksMyOfferWidget> with UiValueMixin {
  MenuController menuController = MenuController();

  Map taskData = {};
  // COMPONENT |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void initState() {
    taskData = widget.data['task'] ?? {};
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      padding: EdgeInsets.all(9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [CConsts.COLOR_BLUE_LIGHT, CConsts.COLOR_BLUE_LIGHT.withAlpha(200)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              /*CircleAvatar(child: Icon(IconsaxPlusBroken.user)),
              IconButtonWidget(icon: "+5".t),*/
              "Tache".t,
              6.gap,
              Chip(
                avatar: CircleAvatar(radius: 27, child: Icon(IconsaxPlusLinear.user, size: 14)),
                label: "${CMiscClass.numberAbrev(widget.data['views_count'] ?? 0)} Vus".t,
              ),
              Spacer(),
              MenuAnchor(
                builder: (context, controller, child) {
                  menuController = controller;
                  return IconButtonWidget(
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                    icon: Icon(IconsaxPlusLinear.more),
                  );
                },
                menuChildren: [
                  TextButton.icon(onPressed: () {}, icon: Icon(IconsaxPlusLinear.edit), label: Text("Modifier")),
                  TextButton.icon(onPressed: () {}, icon: Icon(IconsaxPlusLinear.undo), label: Text("Reposter")),
                  TextButton.icon(onPressed: () {}, icon: Icon(IconsaxPlusLinear.trash), label: Text("Supprimer")),
                ],
              ),
            ],
          ),
          18.gap,

          // Date.
          Text(
            "Plublier ${taskData['created_at'].toString().toDateTime()?.toReadable.ago() ?? "Aucune date de publication"}",
          ).muted,

          // Description & tag.
          Row(
            children: [
              Text(
                "${widget.data['description'] ?? 'Sans description'}",
                style: context.theme.textTheme.titleLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ).expanded(),
              9.gap,
              Text(EmergencyLevelText(taskData['emergency_level']).text, style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),

          // Audio record.
          if (widget.data['has_audio'] == true) ...[
            6.gap,
            Icon(
              IconsaxPlusLinear.microphone,
              size: 24,
            ).stickThis(Text("Enregistrement audio", style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          18.gap,
          Row(
            children: [
              Card.filled(
                    color: CConsts.LIGHT_COLOR,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            IconButton.outlined(
                              style: ButtonStyle(side: WidgetStatePropertyAll(BorderSide(color: CConsts.COLOR_GREY_LIGHT))),
                              onPressed: () => CRouter(
                                context,
                              ).goTo(TaskPostulationResponsesRoute(taskId: widget.data['task']?['id'] ?? '---')),
                              icon: Icon(IconsaxPlusBroken.sms_notification, color: CConsts.COLOR_GREY_LIGHT),
                            ),
                            9.gap,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                "Reponses".t,
                                Text("En candidatures", style: context.theme.textTheme.labelMedium).muted,
                              ],
                            ).expanded(),
                          ],
                        ),
                        // 6.gap,
                        Text(
                          "${widget.data['responses_count'] ?? 0}",
                          style: context.theme.textTheme.titleLarge?.copyWith(fontSize: 36, fontWeight: FontWeight.normal),
                        ),
                        Text("Entrées"),
                      ],
                    ).withPadding(all: 9),
                  )
                  .cursorClick(
                    inkwell: true,
                    onClick: () {
                      CRouter(context).goTo(TaskPostulationResponsesRoute(taskId: widget.data['task_id'] ?? '---'));
                    },
                  )
                  .expanded(),
              9.gap,
              Card.filled(
                color: CConsts.LIGHT_COLOR,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        IconButton.outlined(
                          style: ButtonStyle(side: WidgetStatePropertyAll(BorderSide(color: CConsts.COLOR_GREY_LIGHT))),
                          onPressed: () {},
                          icon: Icon(IconsaxPlusLinear.clock, color: CConsts.COLOR_GREY_LIGHT),
                        ),
                        9.gap,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            "Exprir dans".t,
                            Text(
                              taskData['emergency_level'] == 'FLEXIBLE' ? "Delai flexible" : "Delai normal",
                              style: context.theme.textTheme.labelMedium,
                            ).muted,
                          ],
                        ).expanded(),
                      ],
                    ),
                    9.gap,
                    Text(
                      "${widget.data['expire_in_hours'] ?? 0} heures",
                      style: context.theme.textTheme.titleLarge?.copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.normal,
                        color: widget.data['is_expired'] == true ? context.theme.colorScheme.error : null,
                      ),
                    ),
                    Text(widget.data['expir_date'].toString().toDateTime()?.toReadable.numeric() ?? "Aucune date de fin"),
                  ],
                ).withPadding(all: 9),
              ).expanded(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;
  // METHODS =================================================================================================================
}

// --------- DEAL --------------
class _InnerMyTaskDealsWidget extends StatefulWidget {
  const _InnerMyTaskDealsWidget();

  @override
  State<_InnerMyTaskDealsWidget> createState() => _InnerMyTaskDealsWidgetState();
}

class _InnerMyTaskDealsWidgetState extends State<_InnerMyTaskDealsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      padding: EdgeInsets.all(9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [CConsts.COLOR_GREY_LIGHT, CConsts.COLOR_GREY_LIGHT.withAlpha(60)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text("Dealé", style: context.theme.textTheme.titleLarge),
              // CircleAvatar(child: Icon(IconsaxPlusBroken.user)),
              // IconButtonWidget(icon: "+5".t),
              Spacer(),
              IconButtonWidget(icon: Icon(IconsaxPlusLinear.more)),
            ],
          ),
          18.gap,
          Text("Plublier il y'a 4h").muted.stickThis(Text("Dealé il y'a 2h")),
          Row(
            children: [
              Text("Depanneur automobile", style: context.theme.textTheme.titleLarge).expanded(),
              9.gap,
              Text("Widget", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          18.gap,
          Row(
            children: [
              Card.filled(
                color: CConsts.LIGHT_COLOR,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        IconButton.outlined(
                          style: ButtonStyle(side: WidgetStatePropertyAll(BorderSide(color: CConsts.COLOR_GREY_LIGHT))),
                          onPressed: () {},
                          icon: Icon(IconsaxPlusBroken.hashtag_up, color: CConsts.COLOR_GREY_LIGHT),
                        ),
                        9.gap,
                        "Total vue".t.expanded(),
                      ],
                    ),
                    9.gap,
                    Text(
                      "123",
                      style: context.theme.textTheme.titleLarge?.copyWith(fontSize: 36, fontWeight: FontWeight.normal),
                    ),
                  ],
                ).withPadding(all: 9),
              ).expanded(),
              9.gap,
              Card.filled(
                color: CConsts.LIGHT_COLOR,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        IconButton.outlined(
                          style: ButtonStyle(side: WidgetStatePropertyAll(BorderSide(color: CConsts.COLOR_GREY_LIGHT))),
                          onPressed: () {},
                          icon: Icon(IconsaxPlusLinear.activity, color: CConsts.COLOR_GREY_LIGHT),
                        ),
                        9.gap,
                        "Actives".t.expanded(),
                      ],
                    ),
                    9.gap,
                    Text(
                      "+123%",
                      style: context.theme.textTheme.titleLarge?.copyWith(fontSize: 36, fontWeight: FontWeight.normal),
                    ),
                  ],
                ).withPadding(all: 9),
              ).expanded(),
            ],
          ),
        ],
      ),
    );
  }
}
