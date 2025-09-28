part of '../main_screen.dart';

@RoutePage(name: "TasksMainPartRoute")
class TasksMainPart extends StatefulWidget {
  const TasksMainPart({super.key});

  @override
  State<TasksMainPart> createState() => _TasksMainPartState();
}

class _TasksMainPartState extends State<TasksMainPart> with AutomaticKeepAliveClientMixin<TasksMainPart>, UiValueMixin {
  late var isLoadingDetails = uiValue(false);
  late var isLoadingTasks = uiValue(false);

  // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  List tagsList = [];
  List tasksList = [];
  Map details = {};

  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    loadDetails(silent: true);
    loadTasks(silent: true);
  }

  @override
  void initState() {
    super.initState();
    loadDetails();
    loadTasks();
    Dsi.registerCallback(DsiKeys.UPDATE_TASKS_LIST_AT_HOME.name, (p0) => loadTasks());
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: CustomScrollView(
        slivers: [
          AppbarMainScrennPart(),

          // CONTENTS.
          SliverList(
            delegate: SliverChildListDelegate([
              18.gap,
              Row(
                children: [
                  Text(
                    "Explorer \nles taches",
                    style: context.theme.textTheme.titleLarge?.copyWith(
                      fontFamily: CConsts.FONT_INTER,
                      fontWeight: FontWeight.bold,
                      fontSize: 27,
                    ),
                  ).expanded(),
                  9.gap,
                  FilledButton.tonalIcon(
                    // style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(CConsts.LIGHT_COLOR)),
                    style: TcButtonsLight.blackButtonTheme.copyWith(visualDensity: VisualDensity.compact),
                    iconAlignment: IconAlignment.end,
                    onPressed: () => CRouter(context).goTo(TaskersRoute()),
                    icon: Icon(IconsaxPlusBroken.user),
                    label: "Liste taskers".t,
                  ),
                  9.gap,
                  IconButtonWidget(
                    icon: Badge(child: Icon(IconsaxPlusLinear.archive_tick)),
                    onPressed: () {},
                  ),
                ],
              ).withPadding(all: 12),

              // SEARCH.
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 12, vertical: 1),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Chercher ...",
                    prefixIcon: Icon(IconsaxPlusLinear.search_normal),
                    suffixIcon: IconButton(onPressed: () {}, icon: Icon(IconsaxPlusLinear.filter)),
                  ),
                ),
              ),

              // TAGS.
              if (tagsList.isEmpty && isLoadingDetails.value)
                Row(
                  children: [
                    Chip(label: "Marketing".t),
                    9.gap,
                    Chip(label: "Marketing".t),
                  ],
                ).asSkeleton()
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 9),
                    child: Row(
                      children: [
                        Badge(
                          label: "123K".t,
                          backgroundColor: context.theme.colorScheme.primary,
                          offset: Offset(-12, -5),
                          child: IconButtonWidget(
                            isBlack: true,
                            icon: Icon(IconsaxPlusLinear.folder, color: CConsts.LIGHT_COLOR),
                            onPressed: () {},
                          ),
                        ),
                        9.gap,
                        ...tagsList.map((e) {
                          return Chip(label: "${e['name'] ?? 'Sans nom'}".t).withPadding(left: 6).cursorClick(onClick: () {});
                        }),
                      ],
                    ),
                  ),
                ),

              // CARDS.
              if (isLoadingTasks.value && tasksList.isEmpty)
                loader()
              else if (tasksList.isEmpty)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(IconsaxPlusBroken.brifecase_cross, size: 90, color: CConsts.COLOR_GREY_LIGHT),
                      Text("Pas des taches disponible", style: context.theme.textTheme.titleMedium),
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
                ...tasksList.map((e) => _InnerTaskComponent(parent: this, data: e)),

              // SPCAER.
              81.gap,
            ]),
          ),
        ],
      ),
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;

  @override
  bool get wantKeepAlive => true;

  Widget loader() {
    return Card.filled(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      color: CConsts.LIGHT_COLOR,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Poste il y a 1h").muted,
              Spacer(),
              IconButton.outlined(
                icon: Icon(IconsaxPlusLinear.save_2),
                onPressed: () {},
                style: TcButtonsLight.outlinedButton,
              ),
            ],
          ),

          9.gap,
          Text(
            "Agent marketing expert dans le domaine des ventes",
            style: context.theme.textTheme.titleMedium?.copyWith(fontFamily: CConsts.FONT_INTER),
          ),
          9.gap,
          Text("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut la").muted,
          9.gap,
          Row(
            children: [
              "Valuer".t.stickThis("\$10 - \$25".t.bold),
              Spacer(),
              Icon(IconsaxPlusLinear.location).stickThis("Bukavu".t.muted.elipsis.expanded()).expanded(),
            ],
          ),
          9.gap,
          DividerWidget(child: "Disponibilite".t.muted),
          Text("Cette tache est disponible pour 2h", style: context.theme.textTheme.labelSmall?.copyWith(color: Colors.grey)),
          Text("Expression de l'offre a 12H 30 - 12/12/2025", style: context.theme.textTheme.labelSmall?.copyWith()),
          Row(children: []),
        ],
      ).withPadding(all: 12),
    ).asSkeleton();
  }

  // MOETHODS ================================================================================================================
  void openJobDetails(String taskId) {
    // showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true,
    //   showDragHandle: false,
    //   builder: (context) => TaskReadScreen(taskId: taskId),
    // );
    CRouter(context).goTo(TaskReadRoute(taskId: taskId));
  }

  void loadDetails({bool silent = false}) {
    if (!silent) isLoadingDetails.value = true;

    Map<String, dynamic> params = {};
    var req = CApi.request.get('/task/jE1A8s2Dx', queryParameters: params);
    req.whenComplete(() => isLoadingDetails.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          tagsList = res.data['data']?['skills'] ?? [];
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

  void loadTasks({bool silent = false}) {
    if (!silent) isLoadingTasks.value = true;

    Map<String, dynamic> params = {};
    var req = CApi.request.get('/task/WEaFxOk2R', queryParameters: params);
    req.whenComplete(() => isLoadingTasks.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          tasksList = res.data['data'] ?? [];
        } else {
          CToast(context).warning("Impossible de charger les taches.".t);
        }
      },
      onError: (e) {
        Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }
}

// --------- Task Card ------------
class _InnerTaskComponent extends StatefulWidget {
  const _InnerTaskComponent({required this.parent, required this.data});
  final Map data;
  final _TasksMainPartState parent;

  @override
  State<_InnerTaskComponent> createState() => _InnerTaskComponentState();
}

class _InnerTaskComponentState extends State<_InnerTaskComponent> with UiValueMixin {
  Map taskData = {};

  // COMPONENT |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void initState() {
    taskData = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      color: CConsts.LIGHT_COLOR,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TAGS.
          Row(
            children: [
              Text("Poste ${taskData['posted_at'].toString().toDateTime()?.toReadable.ago() ?? 'Sans date'}").muted,
              Spacer(),
              IconButton.outlined(
                icon: Icon(taskData['is_saved'] == true ? IconsaxPlusBold.save_2 : IconsaxPlusLinear.save_2),
                onPressed: () {},
                style: TcButtonsLight.outlinedButton,
              ),
            ],
          ),

          // Title & description.
          9.gap,
          Text(
            "${taskData['title'] ?? "Pas de titre"}",
            style: context.theme.textTheme.titleMedium?.copyWith(fontFamily: CConsts.FONT_INTER),
          ),
          if (taskData['subtitle'] != null) ...[
            9.gap,
            Text("${taskData['subtitle'] ?? "Pas de sous titre"}", maxLines: 2, overflow: TextOverflow.ellipsis).muted,
          ],

          // Audio.
          if (taskData['has_audio'] == true) ...[
            6.gap,
            Row(children: [Icon(IconsaxPlusLinear.microphone, size: 16), 6.gap, Text("A un enregistrement audio")]),
          ],

          // Budget.
          9.gap,
          Builder(
            builder: (context) {
              String symbole = taskData['budget']?['currency'] == 'USD' ? '\$' : 'Fc ';
              return Row(
                children: [
                  "Valeur".t.stickThis(
                    "$symbole${taskData['budget']?['min'].toString().toDouble().toMoney()}"
                            " - $symbole${taskData['budget']?['max'].toString().toDouble().toMoney()}"
                        .t
                        .bold,
                  ),
                  Spacer(),
                  Icon(
                    IconsaxPlusLinear.location,
                    size: 18,
                  ).stickThis("${taskData['town_count'] ?? 0} villes".t.muted.elipsis.expanded()).expanded(),
                ],
              );
            },
          ),

          // Expiration.
          9.gap,
          DividerWidget(child: "Disponibilite".t.muted),
          Text(
            "Cette tache est disponible pour ${taskData['disponibility_hour_stamp'] ?? '~'}h",
            style: context.theme.textTheme.labelSmall?.copyWith(color: Colors.grey),
          ),
          Text(
            "L'offres expire à ${taskData['expir_datatime'].toString().toDateTime()?.toReadable.numeric(format: "{hour}H {minute} - {day}/{month}/{year}")}",
            style: context.theme.textTheme.labelSmall?.copyWith(),
          ),
          Row(children: []),
        ],
      ).withPadding(all: 12),
    ).cursorClick(onClick: () => widget.parent.openJobDetails(taskData['id'] ?? '---'));
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;
  // METHODS =================================================================================================================
}
