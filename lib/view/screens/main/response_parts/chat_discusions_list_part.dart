part of '../main_screen.dart';

class ChatDiscusionsListPart extends StatefulWidget {
  const ChatDiscusionsListPart({super.key});

  @override
  State<ChatDiscusionsListPart> createState() => _ChatDiscusionsListPartState();
}

class _ChatDiscusionsListPartState extends State<ChatDiscusionsListPart>
    with AutomaticKeepAliveClientMixin<ChatDiscusionsListPart>, UiValueMixin {
  late var isLoadingDetails = uiValue(false);
  late var isLoadingChats = uiValue(false);
  late var isUpdatingChatsList = uiValue(false);

  Map detailsData = {};
  List chatsList = [];
  List recentsChatsList = [];
  List oldChatsList = [];
  // COMPONENT |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void initState() {
    super.initState();
    _loadDetails();
    // _loadChats();
  }

  @override
  void dispose() {
    Dsi.disposeCallback(DsiKeys.SKILLS_SELECTOR_PROXY.name);
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        18.gap,
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Liste \ndes discussions", style: context.theme.textTheme.headlineMedium),
                // Text("Reponses aux/a votre request (tache)"),
              ],
            ).expanded(),
            IconButtonWidget(icon: Icon(IconsaxPlusLinear.archive)),
            9.gap,
            IconButtonWidget(icon: Icon(IconsaxPlusLinear.star_1)),
          ],
        ).withPadding(horizontal: 18),

        // FILTERS TAGS.
        12.gap,
        Row(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 6.6,
                children: [
                  6.gap,
                  Chip(
                    color: WidgetStatePropertyAll(CConsts.SECONDARY_COLOR),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    label: Text("Tout", style: TextStyle(color: Colors.white)),
                  ),
                  Chip(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    label: Text("12 ${CConsts.CENTER_DOT} Non lus"),
                  ),
                  Chip(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    label: Text("0 ${CConsts.CENTER_DOT} Tasker"),
                  ),
                  Chip(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    label: Text("1 ${CConsts.CENTER_DOT} Taches"),
                  ),
                ],
              ),
            ).expanded(),
            3.gap,
            IconButtonWidget(icon: Icon(IconsaxPlusLinear.document_filter), onPressed: () {}),
            6.gap,
          ],
        ),

        // LIST.
        24.gap,
        Row(
          spacing: 12,
          children: [
            6.gap,
            Text("Recents", style: TextStyle(fontWeight: FontWeight.bold)).muted,
            FilledButton.tonalIcon(
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 0, horizontal: 12)),
              ),
              onPressed: isLoadingChats.value
                  ? null
                  : () {
                      _loadChats();
                    },
              icon: isLoadingChats.value ? SpinnerWidget(size: 14) : Icon(IconsaxPlusLinear.refresh_2, size: 14),
              label: Text("Recharger"),
            ),
          ],
        ),

        // RECENTS CHATS.
        12.gap,
        Builder(
          builder: (context) {
            if (isLoadingChats.value && recentsChatsList.isEmpty) {
              return _recentsLoader();
            } else if (!isLoadingChats.value && recentsChatsList.isEmpty) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 12,
                  children: [
                    Icon(IconsaxPlusBroken.directbox_receive, color: CConsts.COLOR_GREY_LIGHT, size: 54),
                    Text("Aucun discussion", style: context.theme.textTheme.titleLarge),
                    Text(
                      "Pour lancer une conversation, vous devez creer une tache pouis accepter les candidatures ou "
                      "contacter un tasker depuis la liste des taskers",
                      style: context.theme.textTheme.labelSmall,
                      textAlign: TextAlign.center,
                    ).muted,
                    FilledButton.tonalIcon(
                      onPressed: () {
                        CRouter(context).goTo(TaskSkillsMenuRoute(title: "Créer une tache"));
                        Dsi.registerCallback(DsiKeys.SKILLS_SELECTOR_PROXY.name, (p0) {
                          CRouter(context).goTo(TaskNewTaskRoute(skillId: p0.toString()));
                        });
                      },
                      icon: Icon(IconsaxPlusBroken.add),
                      label: Text("Cree une tache"),
                    ),
                  ],
                ).sized(height: 270),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [...recentsChatsList.map((e) => _InnerInboxTile(data: e))],
            ).animate().fadeIn();
          },
        ),

        18.gap,
        DividerWidget(
          alignment: TextAlign.start,
          child: Text(
            "Anciens : plus de 2 semaines",
            style: TextStyle(fontWeight: FontWeight.bold),
          ).muted.withPadding(left: 12),
        ).withPadding(horizontal: 4.5),

        // OLD CHATS.
        9.gap,
        ...oldChatsList.map((e) => _InnerInboxTile(data: e)),

        // SPACER
        81.gap,
      ],
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;

  @override
  bool get wantKeepAlive => true;

  Widget _recentsLoader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int index = 0; index < 4; index++)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  12.gap,
                  CircleAvatar(backgroundColor: CConsts.LIGHT_COLOR, child: Icon(IconsaxPlusBroken.user)),
                  3.6.gap,
                  Text("Client", style: context.theme.textTheme.labelSmall),
                ],
              ),
              9.gap,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pseudo Utilisateur 1",
                            style: context.theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut la",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          3.gap,
                          Row(
                            children: [
                              Text(
                                "Q: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut la",
                                maxLines: 2,
                                // overflow: TextOverflow.ellipsis,
                                style: context.theme.textTheme.labelSmall,
                              ).muted.elipsis.expanded(),
                            ],
                          ),
                          Row(children: []),
                        ],
                      ).cursorClick(onClick: () {}, inkwell: true).expanded(),
                      9.gap,
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('0000'),
                          4.5.gap,
                          Icon(IconsaxPlusLinear.star_1, size: 18),
                          4.5.gap,
                          Text('12/12/2025', style: context.theme.textTheme.labelSmall),
                        ],
                      ),
                    ],
                  ),

                  // DIVIDER.
                  DividerWidget(),
                ],
              ).expanded(),
            ],
          ).withPadding(horizontal: 9).asSkeleton(),
      ],
    );
  }

  Widget _oldsLoader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int index = 0; index < 2; index++)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  12.gap,
                  CircleAvatar(backgroundColor: CConsts.LIGHT_COLOR, child: Icon(IconsaxPlusBroken.user)),
                  3.6.gap,
                  Text("Client", style: context.theme.textTheme.labelSmall),
                ],
              ),
              9.gap,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pseudo Utilisateur 1",
                            style: context.theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut la",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          3.gap,
                          Row(
                            children: [
                              Text(
                                "Q: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut la",
                                maxLines: 2,
                                // overflow: TextOverflow.ellipsis,
                                style: context.theme.textTheme.labelSmall,
                              ).muted.elipsis.expanded(),
                            ],
                          ),
                          Row(children: []),
                        ],
                      ).cursorClick(onClick: () {}, inkwell: true).expanded(),
                      9.gap,
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('000'),
                          4.5.gap,
                          Icon(IconsaxPlusLinear.star_1, size: 18),
                          4.5.gap,
                          Text('12/12/2025', style: context.theme.textTheme.labelSmall),
                        ],
                      ),
                    ],
                  ),

                  // DIVIDER.
                  DividerWidget(),
                ],
              ).expanded(),
            ],
          ).withPadding(horizontal: 9).asSkeleton(),
      ],
    );
  }

  // METHODS =================================================================================================================
  void _loadDetails() {}

  void _loadChats() {
    isLoadingChats.value = true;

    Map<String, dynamic> params = {};
    var req = CApi.request.get('/chat/C7lgzLI9R', queryParameters: params);
    req.whenComplete(() => isLoadingChats.value = false);
    req.then(
      (res) {
        Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          recentsChatsList = res.data['data'] ?? [];
        } else {
          CToast(context).warning("Impossible de charger les discussions".t);
        }
      },
      onError: (e) {
        Logger().e(e);
        CToast(context).error("Problème de connexion".t);
      },
    );
  }

  void _archiveIt() {}

  void _deleteIt() {}

  void _trackIt() {}
}

// -------------------------------------------------- INBOX TILE -------------------------------------------------------------
class _InnerInboxTile extends StatefulWidget {
  const _InnerInboxTile({super.key, required this.data});
  final Map data;

  @override
  State<_InnerInboxTile> createState() => _InnerInboxTileState();
}

class _InnerInboxTileState extends State<_InnerInboxTile> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            12.gap,
            CircleAvatar(
              backgroundColor: CConsts.LIGHT_COLOR,
              backgroundImage: Image.network(
                CNetworkFilesClass.picture(widget.data['interloc_picture']),
                errorBuilder: (context, error, stackTrace) {
                  return Icon(IconsaxPlusBroken.user);
                },
              ).image,
            ),
            3.6.gap,
            Text(
              run(() {
                if (widget.data['interloc_type'] == 'CLIENT') {
                  return 'Client';
                } else if (widget.data['interloc_type'] == 'TASKER') {
                  return 'Tasker';
                }

                return 'Utilisateur';
              }),
              style: context.theme.textTheme.labelSmall,
            ).elipsis,
          ],
        ),
        9.gap,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 6.6,
                      children: [
                        ChipWidget(
                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          child: Text("Tache", style: context.theme.textTheme.labelMedium),
                        ),
                        ChipWidget(
                          color: CConsts.COLOR_GREY_LIGHT,
                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          child: Text("Tache expire", style: context.theme.textTheme.labelMedium).muted,
                        ),
                        Text("Non deale", style: context.theme.textTheme.labelMedium),
                        ChipWidget(
                          color: CConsts.LOGO_PRIMARY_COLOR,
                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          child: Text(
                            "Dealé",
                            style: context.theme.textTheme.labelMedium?.copyWith(color: CConsts.LIGHT_COLOR),
                          ),
                        ),
                        //
                      ],
                    ),
                    Text(
                      "Pseudo Utilisateur 1",
                      style: context.theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut la"
                      "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut la"
                      "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut la",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    3.gap,
                    Row(
                      children: [
                        Text(
                          "Q: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut la"
                          "Q: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut la"
                          "Q: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut la",
                          maxLines: 2,
                          // overflow: TextOverflow.ellipsis,
                          style: context.theme.textTheme.labelSmall,
                        ).muted.elipsis.expanded(),
                      ],
                    ),
                    Row(children: []),
                  ],
                ).cursorClick(onClick: () {}, inkwell: true).expanded(),
                9.gap,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Badge.count(count: widget.data['response_count'] ?? 0, isLabelVisible: widget.data['response_count'] > 0),
                    4.5.gap,
                    if (widget.data['is_tracked'] == false)
                      Icon(IconsaxPlusLinear.star_1, size: 18)
                    else
                      Icon(IconsaxPlusBold.star_1, size: 18, color: Colors.amber),
                    4.5.gap,
                    Text(
                      '${widget.data['last_response_sent_at'].toString().toDateTime()?.toReadable.numeric(format: "{day}/{month}/{year}\n{hour}:{minute}")}',
                      textAlign: TextAlign.center,
                      style: context.theme.textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),

            // DIVIDER.
            DividerWidget(),
          ],
        ).expanded(),
      ],
    ).withPadding(horizontal: 9);
  }
}
