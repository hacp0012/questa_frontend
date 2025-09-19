part of '../main_screen.dart';

class ResponsePostulatReadPart extends StatefulWidget {
  const ResponsePostulatReadPart({super.key});

  @override
  State<ResponsePostulatReadPart> createState() => _ResponsePostulatReadPartState();

  static void bottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ResponsePostulatReadPart();
      },
    );
  }
}

class _ResponsePostulatReadPartState extends State<ResponsePostulatReadPart> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(IconsaxPlusBroken.note_1, size: 45),
                  Spacer(),
                  TextButton(onPressed: () => Navigator.pop(context), child: "FERMER".t),
                ],
              ),
              Text("Candidature", style: context.theme.textTheme.titleLarge, textAlign: TextAlign.center),
            ],
          ),
          //
          18.gap,
          Row(children: ["MESSAGE".t.muted]),
          9.gap,
          Text(
            "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt "
            "ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo "
            "duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata",
            style: context.theme.textTheme.bodyMedium,
          ),

          18.gap,
          Icon(IconsaxPlusLinear.clock_1, size: 14).stickThis("Envoyer a 13h 12 ${CConsts.CENTER_DOT} 12/12/2025".t.muted),
          Icon(IconsaxPlusLinear.map_1, size: 14).stickThis("Bukavu ${CConsts.CENTER_DOT} Saiy".t.muted.expanded()),

          27.gap,

          Text(
            "Une fois vous avez accepter le candidatur, dans votre discussion vous receverez un "
            "message contenant cette message ci-haut.",
            style: context.theme.textTheme.labelSmall,
          ).muted,
          4.5.gap,
          Row(
            children: [
              FilledButton.tonalIcon(
                style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(CConsts.LIGHT_COLOR)),
                onPressed: () {},
                label: Text("Rejeter"),
                icon: Icon(IconsaxPlusLinear.trash),
              ).expanded(flex: 2),
              9.gap,
              FilledButton.tonalIcon(
                style: TcButtonsLight.blackButtonTheme,
                onPressed: () {},
                label: Text("Accepter"),
                icon: Icon(Icons.check, color: Colors.green),
              ).expanded(flex: 3),
            ],
          ),
        ],
      ).withPadding(all: 12).sized(width: double.infinity),
    );
  }
}
