part of '../main_screen.dart';

class ChatDiscusionsListPart extends StatefulWidget {
  const ChatDiscusionsListPart({super.key});

  @override
  State<ChatDiscusionsListPart> createState() => _ChatDiscusionsListPartState();
}

class _ChatDiscusionsListPartState extends State<ChatDiscusionsListPart>
    with AutomaticKeepAliveClientMixin<ChatDiscusionsListPart>, UiValueMixin {
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
                Text("Discussions", style: context.theme.textTheme.titleLarge),
                // Text("Reponses aux/a votre request (tache)"),
              ],
            ).expanded(),
            IconButtonWidget(icon: Icon(IconsaxPlusLinear.archive)),
            9.gap,
            IconButtonWidget(icon: Icon(IconsaxPlusLinear.star_1)),
          ],
        ).withPadding(horizontal: 18),

        // LIST.
        18.gap,
        ...List.generate(4, (index) => listTileUser(index)),

        18.gap,
        DividerWidget(alignment: TextAlign.start, child: "Anciens : plus de 2 semaines".t.muted).withPadding(horizontal: 4.5),

        9.gap,
        ...List.generate(5, (index) => listTileTask(index)),

        // SPACER
        81.gap,
      ],
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;

  @override
  bool get wantKeepAlive => true;

  Widget listTileTask(int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            9.gap,
            CircleAvatar(backgroundColor: CConsts.LIGHT_COLOR, child: Icon(IconsaxPlusBroken.note_1)),
            3.6.gap,
            Text("terminé", style: context.theme.textTheme.labelSmall),
          ],
        ),
        9.gap,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (index > 0) DividerWidget(),

            Row(
              children: [
                InkWell(
                  onTap: () {
                    CRouter(context).goTo(ChatRoute());
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Mom du tache 1$index", style: context.theme.textTheme.titleMedium),
                      Text(
                        "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut la",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ).expanded(),
                9.gap,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Badge.count(count: 123),
                    4.5.gap,
                    Icon(IconsaxPlusLinear.star_1, size: 18),
                    4.5.gap,
                    Text('12/12/2025', style: context.theme.textTheme.labelSmall),
                  ],
                ),
              ],
            ),
          ],
        ).expanded(),
      ],
    ).withPadding(horizontal: 9);
  }

  Widget listTileUser(int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            9.gap,
            CircleAvatar(backgroundColor: CConsts.LIGHT_COLOR, child: Icon(IconsaxPlusBroken.user)),
            3.6.gap,
            Text("terminé", style: context.theme.textTheme.labelSmall),
          ],
        ),
        9.gap,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (index > 0) DividerWidget(),

            Row(
              children: [
                InkWell(
                  onTap: () {
                    CRouter(context).goTo(ChatRoute());
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pseudo Utilisateur 1$index", style: context.theme.textTheme.titleMedium),
                      Text(
                        "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut la",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ).expanded(),
                9.gap,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Badge.count(count: 123),
                    4.5.gap,
                    Icon(IconsaxPlusLinear.star_1, size: 18),
                    4.5.gap,
                    Text('12/12/2025', style: context.theme.textTheme.labelSmall),
                  ],
                ),
              ],
            ),
          ],
        ).expanded(),
      ],
    ).withPadding(horizontal: 9);
  }
}
