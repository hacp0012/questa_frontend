part of '../main_screen.dart';

class ResposesToTasksPart extends StatefulWidget {
  const ResposesToTasksPart({super.key});

  @override
  State<ResposesToTasksPart> createState() => _ResposesToTasksPartState();
}

class _ResposesToTasksPartState extends State<ResposesToTasksPart>
    with AutomaticKeepAliveClientMixin<ResposesToTasksPart>, UiValueMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      // padding: EdgeInsets.symmetric(horizontal: 4.5),
      children: [
        18.gap,
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Reponses", style: context.theme.textTheme.titleLarge),
                Text("Reponses aux/a votre request (tache)"),
              ],
            ).expanded(),
            9.gap,
            "12".t.bold,
          ],
        ).withPadding(horizontal: 18),
        18.gap,
        ...List.generate(9, (index) {
          return Card.filled(
            color: CConsts.LIGHT_COLOR,
            // color: Colors.transparent,
            child: ListTile(
              dense: true,
              visualDensity: VisualDensity.compact,
              leading: CircleAvatar(child: Icon(IconsaxPlusBroken.user)),
              title: Text("Pseudo24$index"),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text("Lorem ipsum dolor sit amet, consetetur s").elipsis, Text("12/12/2025").muted.bold],
              ),
              onTap: () {
                ResponsePostulatReadPart.bottomSheet(context);
              },
            ),
          );
        }),

        // SPACER.
        90.gap,
      ],
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;

  @override
  bool get wantKeepAlive => true;
}
