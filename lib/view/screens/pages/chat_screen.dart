import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/screens/layouts/default_layout.dart';
import 'package:questa/view/widgets/back_button_widget.dart';
import 'package:questa/view/widgets/divider_widget.dart';
import 'package:questa/view/widgets/icon_button_widget.dart';
import 'package:ui_value/ui_value.dart';

@RoutePage()
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const String routeId = "5u12C8713J2X60gNei";

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with UiValueMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButtonWidget(),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Chat"),
              Text("Candudatur | Tache", style: context.theme.textTheme.labelSmall),
            ],
          ),
          actions: [
            FilledButton.tonal(onPressed: () {}, child: Text("Conclure")),
            9.gap,
            IconButtonWidget(icon: Icon(IconsaxPlusLinear.more), onPressed: () {}),
          ],
        ),

        // BODY.
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView(
                padding: EdgeInsets.symmetric(horizontal: 12),
                reverse: true,
                children: [
                  // SPACER.
                  18.gap,

                  inputChatBull(),
                  outputChatBull(),
                  inputChatBull(),

                  // ALERT.
                  27.gap,
                  DividerWidget(child: "Messages".t.muted),
                  18.gap,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(IconsaxPlusLinear.trash),
                        label: "Supprimer - rejeter".t,
                      ),
                    ],
                  ),
                  Card.filled(
                    color: CConsts.LIGHT_COLOR,
                    child: Column(
                      children: [
                        Icon(IconsaxPlusBroken.info_circle),
                        9.gap,
                        Text(
                          "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor "
                          "invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam "
                          "et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata",
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ).withPadding(all: 12),
                  ),
                ],
              ).expanded(),
              //
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButtonWidget(icon: Icon(IconsaxPlusLinear.paperclip)),
                  TextField(decoration: InputDecoration(hintText: "Message..."), minLines: 1, maxLines: 6).expanded(),
                  IconButtonWidget(icon: Icon(IconsaxPlusBroken.send_1)),
                ],
              ).withPadding(bottom: 4.5, right: 4.5, left: 4.5),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;

  Widget outputChatBull() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        27.gap,
        Flexible(
          child: Card.filled(
            margin: EdgeInsets.zero,
            color: CConsts.COLOR_GREEN_LIGHT,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet, consetetur sadipscing elitr, ",
                  style: context.theme.textTheme.bodyMedium,
                ),
                4.5.gap,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Spacer(),
                    Text("12/12/2025 a 12h11", style: context.theme.textTheme.labelSmall),
                    9.gap,
                    Icon(Icons.check, size: 14),
                  ],
                ),
              ],
            ).withPadding(all: 12),
          ),
        ),
      ],
    ).withPadding(top: 18);
  }

  Widget inputChatBull() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Card.filled(
            margin: EdgeInsets.zero,
            color: CConsts.COLOR_GREY_LIGHT,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet, consetetur sadipscing elitr, ",
                  style: context.theme.textTheme.bodyMedium,
                ),
                4.5.gap,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Spacer(),
                    Text("12/12/2025 a 12h11", style: context.theme.textTheme.labelSmall),
                    // 9.gap,
                    // Icon(Icons.check, size: 14),
                  ],
                ),
              ],
            ).withPadding(all: 12),
          ),
        ),
        27.gap,
      ],
    ).withPadding(top: 18);
  }

  // METHODS =================================================================================================================
}
