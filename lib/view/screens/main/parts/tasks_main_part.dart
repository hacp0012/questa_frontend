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

  List tasksList = [];
  Map details = {};

  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void initState() {
    super.initState();
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
    return CustomScrollView(
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
                    Chip(label: "Marketing".t),
                    9.gap,
                    Chip(label: "Vente".t),
                    9.gap,
                    Chip(label: "Finance".t),
                    9.gap,
                    Chip(label: "Marketing".t),
                    9.gap,
                    Chip(label: "Commerce".t),
                    9.gap,
                    Chip(label: "Menages".t),
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: false,
      builder: (context) => _InnerTasksJobDetail(taskId: taskId),
    );
  }

  void loadDetails() {}

  void loadTasks() {
    isLoadingTasks.value = true;
    Map<String, dynamic> params = {};
    var req = CApi.request.get('/task/WEaFxOk2R', queryParameters: params);
    req.whenComplete(() => isLoadingTasks.value = false);
    req.then(
      (res) {
        Logger().t(res.data);
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
    taskData = widget.data['task'] ?? {};
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
          Row(
            children: [
              Text("Poste ${taskData['created_at'].toString().toDateTime()?.toReadable.ago() ?? 'Sans date'}").muted,
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
            "${taskData['title'] ?? "Pas de titre"}",
            style: context.theme.textTheme.titleMedium?.copyWith(fontFamily: CConsts.FONT_INTER),
          ),
          if (taskData['description'] != null) ...[9.gap, Text("${taskData['description'] ?? "Pas de description"}").muted],
          9.gap,
          Builder(
            builder: (context) {
              String symbole = taskData['currency'] == 'USD' ? '\$' : 'Fc ';
              return Row(
                children: [
                  "Valeur".t.stickThis(
                    "$symbole${taskData['min_price'].toString().toDouble().toMoney()}"
                            " - $symbole${taskData['max_price'].toString().toDouble().toMoney()}"
                        .t
                        .bold,
                  ),
                  Spacer(),
                  Icon(IconsaxPlusLinear.location).stickThis("Bukavu".t.muted.elipsis.expanded()).expanded(),
                ],
              );
            },
          ),
          9.gap,
          DividerWidget(child: "Disponibilite".t.muted),
          Text(
            "Cette tache est disponible pour ${widget.data['expire_in_hours'] ?? '~'}h",
            style: context.theme.textTheme.labelSmall?.copyWith(color: Colors.grey),
          ),
          Text("Expression de l'offre a 12H 30 - 12/12/2025", style: context.theme.textTheme.labelSmall?.copyWith()),
          Row(children: []),
        ],
      ).withPadding(all: 12),
    ).cursorClick(onClick: () => widget.parent.openJobDetails(taskData['id'] ?? '---'));
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;
  // METHODS =================================================================================================================
}

// --------- JON DETAIL -----------
class _InnerTasksJobDetail extends StatefulWidget {
  const _InnerTasksJobDetail({required this.taskId});
  final String taskId;

  @override
  State<_InnerTasksJobDetail> createState() => _InnerTasksJobDetailState();
}

class _InnerTasksJobDetailState extends State<_InnerTasksJobDetail> with UiValueMixin {
  late var isLoadingDetails = uiValue(false);
  Map taskData = {};

  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
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
              Row(
                children: [
                  Text(
                    "Agent marketing expert dans le domaine des ventes",
                    style: context.theme.textTheme.titleMedium?.copyWith(
                      fontFamily: CConsts.FONT_INTER,
                      fontWeight: FontWeight.bold,
                    ),
                  ).expanded(),
                  IconButton.outlined(
                    icon: Icon(IconsaxPlusLinear.save_2),
                    onPressed: () {},
                    style: TcButtonsLight.outlinedButton,
                  ),
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
              Row(
                children: [Icon(IconsaxPlusLinear.money, size: 14), 4.5.gap, "Valeur".t.muted, 4.5.gap, "\$1 - \$20".t.bold],
              ),
              9.gap,
              DividerWidget(alignment: TextAlign.start, child: "Details".t.muted),
              9.gap,
              ResponsiveGridRow(
                children: [
                  for (int i = 0; i < 3; i++)
                    ResponsiveGridCol(
                      xs: 6,
                      sm: 6,
                      md: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(18),
                        child: Image.asset('lib/assets/images/register_wellcome.png', fit: BoxFit.cover).sized(height: 126),
                      ).withPadding(all: 9),
                    ),
                ],
              ),
              9.gap,
              Text("${taskData['description'] ?? "Pas de description fournis"}"),

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
          );
        },
      ),

      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: FilledButton(onPressed: () {}, style: TcButtonsLight.blackButtonTheme, child: "Postuler".t),
            ),
          ),
        ],
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
  void loadDetails() {
    isLoadingDetails.value = true;

    Map<String, dynamic> params = {'taskId': widget.taskId};
    var req = CApi.request.get('/task/XMAHdEd62', queryParameters: params);
    req.whenComplete(() => isLoadingDetails.value = false);
    req.then(
      (res) {
        Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          taskData = res.data['data']?['task'] ?? {};
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
}
