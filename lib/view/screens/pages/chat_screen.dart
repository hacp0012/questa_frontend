import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:logger/logger.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/modules/c_api.dart';
import 'package:questa/modules/c_image_handler_class.dart';
import 'package:questa/modules/c_navigate.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/auto_routes/a_r_app.gr.dart';
import 'package:questa/view/screens/layouts/default_layout.dart';
import 'package:questa/view/widgets/back_button_widget.dart';
import 'package:questa/view/widgets/c_toast.dart';
import 'package:questa/view/widgets/chip_widget.dart';
import 'package:questa/view/widgets/divider_widget.dart';
import 'package:questa/view/widgets/icon_button_widget.dart';
import 'package:run_it/run_it.dart';
import 'package:ui_value/ui_value.dart';

@RoutePage()
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, @QueryParam() this.entrypointId});
  static const String routeId = "5u12C8713J2X60gNei";
  final String? entrypointId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with UiValueMixin {
  late var isLoadingDetails = uiValue(false);
  late var isSendingMessage = uiValue(false);
  late var isLoadingMessages = uiValue(false);
  late var isDeletingForMe = uiValue(false);
  late var isDeleting = uiValue(false);
  late var isRejectingPostulation = uiValue(false);

  MenuController chatBullOptionsMenuController = MenuController();
  TextEditingController inputMessageController = TextEditingController();

  late var isDealed = uiValue(false);
  List messagesList = [];
  Map detailsData = {};
  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void initState() {
    super.initState();
    _loadMessages();
    _loadDetails();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

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
              Text("${detailsData['interloc_name'] ?? "Sans nom"}", style: context.theme.textTheme.titleMedium).bold.elipsis,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 6,
                children: [
                  // Text("Chat"),
                  ChipWidget(
                    color: Colors.black.withAlpha(12),
                    padding: EdgeInsets.symmetric(horizontal: 4.8),
                    child: Text(
                      run(() {
                        return switch (detailsData['interloc_type']) {
                          'TASKER' => "Tasker",
                          'CLIENT' => "Client",
                          _ => "Anonyme",
                        };
                      }),
                      style: context.theme.textTheme.labelMedium,
                    ),
                  ),
                  ChipWidget(
                    padding: EdgeInsets.symmetric(horizontal: 4.8),
                    child: Text(
                      run(() {
                        return switch (detailsData['entrypoint_type']) {
                          'TASK' => 'Tache',
                          _ => "Conversation",
                        };
                      }),
                      style: context.theme.textTheme.labelMedium,
                    ),
                  ),
                ],
              ),
            ],
          ).asSkeleton(enabled: isLoadingDetails.value && detailsData.isEmpty),
          actions: [
            if (detailsData['entrypoint_type'] == 'TASK')
              FilledButton.tonal(onPressed: isLoadingDetails.value ? null : () {}, child: Text("Conclure")),
            6.gap,
            MenuAnchor(
              builder: (context, controller, child) {
                return IconButtonWidget(
                  icon: Icon(IconsaxPlusLinear.more),
                  onPressed: isLoadingDetails.value
                      ? null
                      : () {
                          chatBullOptionsMenuController = controller;
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            controller.open();
                          }
                        },
                );
              },
              menuChildren: [
                TextButton.icon(onPressed: () {}, icon: Icon(IconsaxPlusLinear.archive), label: Text("Archiver")),
                TextButton.icon(onPressed: () {}, icon: Icon(Icons.star), label: Text("Suivre")),
                TextButton.icon(onPressed: () {}, icon: Icon(IconsaxPlusLinear.trash), label: Text("Supprimer le chat")),
              ],
            ).asSkeleton(enabled: isLoadingDetails.value),
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

                  // LOADER.
                  if (isLoadingMessages.value && messagesList.isEmpty) loader(),
                  // MESSAGES
                  if (messagesList.isNotEmpty) ...messagesList,
                  // IF MESSAGES IS BLANK.
                  if (messagesList.isEmpty && !isLoadingMessages.value)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(IconsaxPlusBroken.message_remove, size: 54, color: CConsts.COLOR_GREY_LIGHT),
                          6.gap,
                          Text("Aucun message pour le moment", textAlign: TextAlign.center).muted,
                          Text(
                            "Ecrivez votre premier message",
                            textAlign: TextAlign.center,
                            style: context.theme.textTheme.labelSmall,
                          ).muted,
                        ],
                      ),
                    ).sized(height: 120).animate().fadeIn(),

                  // ALERT.
                  27.gap,
                  DividerWidget(child: "Messages".t.muted),

                  // REJECT EXCHANGE.
                  if (detailsData['entrypoint_type'] == 'TASK') ...[
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
                    12.gap,
                  ],

                  // INFO ALERT.
                  if (detailsData.isNotEmpty)
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
                    ).animate().fadeIn(),

                  // Avatar & INFOS.
                  if (detailsData.isNotEmpty) ...[
                    18.gap,
                    6.gap,
                    Text(
                      "Cette conversation a commence \n"
                      "le ${detailsData['entrypoint_created_at'].toString().toDateTime()?.toReadable.numeric(format: "{day}/{month}/{year} à {hour}:{minute}")}",
                      textAlign: TextAlign.center,
                      style: context.theme.textTheme.labelMedium,
                    ),
                    6.gap,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton.tonalIcon(
                          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(CConsts.LIGHT_COLOR)),
                          onPressed: () {
                            if (detailsData['interloc_type'] == 'CLIENT') {
                              CRouter(context).goTo(UserProfileReadRoute(userId: detailsData['interloc_id'] ?? '---'));
                            } else if (detailsData['interloc_type'] == 'TASKER') {
                              CRouter(context).goTo(TaskerProfileRoute(taskerId: detailsData['tasker_id'] ?? '---'));
                            }
                          },
                          label: Text("Consulter le profile"),
                        ),
                      ],
                    ),
                    6.gap,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 6,
                      children: [
                        ChipWidget(
                          color: Colors.black.withAlpha(12),
                          padding: EdgeInsets.symmetric(horizontal: 4.8),
                          child: Text(
                            run(() {
                              return switch (detailsData['interloc_type']) {
                                'TASKER' => "Tasker",
                                'CLIENT' => "Client",
                                _ => "Anonyme",
                              };
                            }),
                            style: context.theme.textTheme.labelMedium,
                          ),
                        ),
                        ChipWidget(
                          padding: EdgeInsets.symmetric(horizontal: 4.8),
                          child: Text(
                            run(() {
                              return switch (detailsData['entrypoint_type']) {
                                'TASK' => 'Tache',
                                _ => "Conversation",
                              };
                            }),
                            style: context.theme.textTheme.labelMedium,
                          ),
                        ),
                      ],
                    ),
                    6.gap,
                    Text(
                      "${detailsData['interloc_name'] ?? "Sans nom"}",
                      style: context.theme.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    6.gap,
                    CircleAvatar(
                      radius: 54,
                      backgroundImage: Image.network(
                        CNetworkFilesClass.picture(detailsData['interloc_picture']),
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(IconsaxPlusLinear.user, size: 45);
                        },
                      ).image,
                    ),
                  ],
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

  Widget outputChatBull({required Map data}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        27.gap,
        Flexible(
          fit: FlexFit.tight,
          child: Card.filled(
            margin: EdgeInsets.zero,
            color: Colors.black.withAlpha(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Spacer(),
                    MenuAnchor(
                      builder: (context, controller, child) {
                        return Icon(IconsaxPlusLinear.more, color: CConsts.LIGHT_COLOR)
                            .withPadding(left: 12, right: 3)
                            .cursorClick(
                              onClick: () {
                                chatBullOptionsMenuController = controller;
                                if (controller.isOpen) {
                                  controller.close();
                                } else {
                                  controller.open();
                                }
                              },
                              inkwell: true,
                            );
                      },
                      menuChildren: [
                        TextButton.icon(onPressed: () {}, icon: Icon(IconsaxPlusLinear.redo), label: Text("Repondre")),
                        TextButton.icon(onPressed: () {}, icon: Icon(IconsaxPlusLinear.trash), label: Text("Supprimer")),
                        TextButton.icon(onPressed: () {}, icon: Icon(IconsaxPlusLinear.copy), label: Text("Copier")),
                      ],
                    ),
                  ],
                ),
                SelectableText("${data['content'] ?? "Contenu vide"}", style: context.theme.textTheme.bodyMedium),
                4.5.gap,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Spacer(),
                    Text(
                      "${data['send_at'].toString().toDateTime()?.toReadable.numeric(format: "{day}/{month}/{year} à {hour}:{minute}")}",
                      style: context.theme.textTheme.labelSmall,
                    ),
                    9.gap,
                    Icon(Icons.check, size: 14).run((it) {
                      // 'READ', 'DELIVERED', 'SENT
                      if (data['send_state'] == 'SENT') {
                        return it;
                      } else if (data['send_state'] == 'DELIVERED') {
                        return Icon(Icons.check_circle, color: Colors.green);
                      } else if (data['send_state'] == 'READ') {
                        return Icon(Icons.check_circle, color: Colors.blue);
                      }
                      return it;
                    }),
                  ],
                ),
              ],
            ).withPadding(left: 12, right: 12, bottom: 12),
          ),
        ),
      ],
    ).withPadding(top: 18);
  }

  Widget inputChatBull({required Map data}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CircleAvatar(child: Icon(IconsaxPlusLinear.user)),
        6.gap,
        Flexible(
          child: Card.filled(
            margin: EdgeInsets.zero,
            color: CConsts.LIGHT_COLOR,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Spacer(),
                    MenuAnchor(
                      builder: (context, controller, child) {
                        return Icon(IconsaxPlusLinear.more)
                            .withPadding(left: 12, right: 3)
                            .cursorClick(
                              onClick: () {
                                chatBullOptionsMenuController = controller;
                                if (controller.isOpen) {
                                  controller.close();
                                } else {
                                  controller.open();
                                }
                              },
                              inkwell: true,
                            );
                      },
                      menuChildren: [
                        TextButton.icon(onPressed: () {}, icon: Icon(IconsaxPlusLinear.redo), label: Text("Repondre")),
                        TextButton.icon(onPressed: () {}, icon: Icon(IconsaxPlusLinear.trash), label: Text("Supp. pour moi")),
                        TextButton.icon(onPressed: () {}, icon: Icon(IconsaxPlusLinear.copy), label: Text("Copier")),
                      ],
                    ),
                  ],
                ),
                SelectableText("${data['content'] ?? "Contenu vide"}", style: context.theme.textTheme.bodyMedium),
                4.5.gap,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Spacer(),
                    Text(
                      "${data['send_at'].toString().toDateTime()?.toReadable.numeric(format: "{day}/{month}/{year} à {hour}:{minute}")}",
                      style: context.theme.textTheme.labelSmall,
                    ),
                    // 9.gap,
                    // Icon(Icons.check, size: 14),
                  ],
                ),
              ],
            ).withPadding(left: 12, right: 12, bottom: 12),
          ),
        ),
        27.gap,
      ],
    ).withPadding(top: 18);
  }

  Widget loader() {
    Widget inner = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CircleAvatar(child: Icon(IconsaxPlusLinear.user)),
        6.gap,
        Flexible(
          child: Card.filled(
            margin: EdgeInsets.zero,
            color: CConsts.LIGHT_COLOR,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
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
            ).withPadding(left: 12, right: 12, bottom: 12),
          ),
        ),
        27.gap,
      ],
    ).withPadding(top: 18);

    Widget outter = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        27.gap,
        Flexible(
          child: Card.filled(
            margin: EdgeInsets.zero,
            color: Colors.black.withAlpha(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SelectableText(
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
            ).withPadding(left: 12, right: 12, bottom: 12),
          ),
        ),
      ],
    ).withPadding(top: 18);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [inner, outter, inner, outter],
    ).asSkeleton();
  }

  // METHODS =================================================================================================================
  void _loadDetails() {
    isLoadingDetails.value = true;

    Map<String, dynamic> params = {'entrypointId': widget.entrypointId};
    var req = CApi.request.get('/chat/5uebPTwvk', queryParameters: params);
    req.whenComplete(() => isLoadingDetails.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          detailsData = res.data['data'] ?? {};
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

  void populateMessages({required List list}) {
    List newMessagesList = [];
    for (var element in list) {
      if (element['sender_is_me'] == true) {
        newMessagesList.add(outputChatBull(data: element));
      } else {
        newMessagesList.add(inputChatBull(data: element));
      }
    }

    messagesList = newMessagesList;
    uiUpdate();
  }

  void _loadMessages() {
    isLoadingMessages.value = true;

    Map<String, dynamic> params = {'entrypointId': widget.entrypointId};
    var req = CApi.request.get('/chat/PKV3QNpy3', queryParameters: params);
    req.whenComplete(() => isLoadingMessages.value = false);
    req.then(
      (res) {
        Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          populateMessages(list: res.data['data'] ?? []);
        } else {
          CToast(context).warning("Impossible de charger les messages.".t);
        }
      },
      onError: (e) {
        Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }

  void _rejectPostulation() {}

  void _dealWithHim() {}

  void _copyText() {}

  void _deleteMessage() {}

  void _deleteMessageForMe() {}

  void _sendMessage() {}
}
