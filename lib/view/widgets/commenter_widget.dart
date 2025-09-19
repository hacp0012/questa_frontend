// ignore_for_file: use_build_context_synchronously

// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/modules/c_api.dart';
import 'package:questa/modules/c_image_handler_class.dart';
import 'package:questa/modules/c_misc_class.dart';
import 'package:questa/modules/c_navigate.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/auto_routes/a_r_app.gr.dart';
import 'package:questa/view/widgets/c_toast.dart';
import 'package:questa/view/widgets/spinner_widget.dart';
import 'package:run_it/run_it.dart';
import 'package:ui_value/ui_value.dart';

class CommenterWidget extends StatefulWidget {
  const CommenterWidget({super.key, required this.model, required this.modelId, this.title, this.cacheIt = false});

  final String model;
  final String modelId;
  final Widget? title;
  final bool cacheIt;

  @override
  State<CommenterWidget> createState() => _CommenterWidgetState();
}

class _CommenterWidgetState extends State<CommenterWidget> with UiValueMixin {
  late var isLoading = uiValue(false);
  late var isSending = uiValue(false);
  late var isLikingId = uiValue<String?>(null);
  late var isLoadingNextContents = uiValue(false);

  int page = 1;
  int pageSize = 25;
  bool hasNextContents = false;
  int totalContents = 0;

  TextEditingController commentController = TextEditingController();
  MenuController? sortCommentsController;
  String sortMode = 'OLDS'; // OLDS | RECENTS

  List commentsList = [];

  // WIDGET ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void initState() {
    sortCommentsController = MenuController();

    super.initState();
    loadComments();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TITLE BAR.
        Row(
          children: [
            if (widget.title.isNotNull) widget.title!,
            if (totalContents > 0) ...[
              4.5.gap,
              "${CConsts.CENTER_DOT} ${CMiscClass.numberAbrev(totalContents.toDouble())}".t.bold,
              4.5.gap,
            ],
            const Spacer(),
            MenuAnchor(
              builder: (context, controller, child) {
                return Tooltip(
                  message: "Trier les commantaires",
                  child: TextButton.icon(
                    onPressed: () {
                      sortCommentsController = controller;
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                    icon: Icon(IconsaxPlusLinear.sort),
                    label: "Trier les comm...".t,
                  ),
                );
              },
              menuChildren: [
                TextButton.icon(
                  onPressed: () {
                    sortMode = 'RECENTS';
                    sortCommentsController?.close();
                    page = 1;
                    loadComments(noLoader: false);
                  },
                  label: "Les plus enceint".t,
                  icon: sortMode == 'RECENTS' ? Icon(Icons.check) : null,
                  style: ButtonStyle(visualDensity: VisualDensity.compact),
                ),
                TextButton.icon(
                  onPressed: () {
                    sortMode = 'OLDS';
                    sortCommentsController?.close();
                    page = 1;
                    loadComments(noLoader: false);
                  },
                  label: "Les plus récent".t,
                  icon: sortMode == 'OLDS' ? Icon(Icons.check) : null,
                  style: ButtonStyle(visualDensity: VisualDensity.compact),
                ),
              ],
            ),
          ],
        ),

        9.gap,
        TextField(
          controller: commentController,
          decoration: InputDecoration(
            hintText: "Laissez votre commentaire ...",
            prefixIcon: Icon(IconsaxPlusLinear.message_text_1),
          ),
          minLines: 1,
          maxLines: 9,
          readOnly: isSending.value || isLoading.value,
          onChanged: (value) => uiUpdate(),
        ).expanded().stickThis(
          IconButton(
            onPressed: run(() {
              if (commentController.text.trim().isEmpty) return null;

              return isSending.value ? null : postComment;
            }),
            icon: isSending.value ? SpinnerWidget(size: 18) : Icon(IconsaxPlusLinear.send_1),
          ),
          vCenter: null,
        ),

        // COMMENTS.
        18.gap,
        ...commentsList.map((e) {
          return Card.filled(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: Image.network(
                        CNetworkFilesClass.picture(e['commenter']?['picture']),
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(IconsaxPlusLinear.user);
                        },
                      ).image,
                    ),
                    9.gap,
                    "${e['commenter']?['name'] ?? 'Sans nom'}".t.bold,
                  ],
                ).cursorClick(
                  onClick: e['commenter']?['id'] == null
                      ? null
                      : () => CRouter(context).goTo(UserProfileReadRoute(userId: e['commenter']?['id'])),
                ),
                9.gap,
                "${e['comment']}".t,
                Row(
                  children: [
                    TextButton.icon(
                      label: "${CMiscClass.numberAbrev((e['likes'] ?? 0).toDouble())} J'aime".t,
                      icon: isLikingId.value == e['id']
                          ? SpinnerWidget(size: 18)
                          : Icon(e['user_like_this'] == true ? IconsaxPlusBold.like_1 : IconsaxPlusLinear.like_1),
                      onPressed: run(() {
                        if (isLikingId.value.isNotNull && e['id'] != isLikingId.value) return null;
                        return () => toggleComment(e['id']);
                      }),
                    ),
                    const Spacer(),
                    (e['created_at'].toString().toDateTime()?.toReadable.sementic() ?? 'non datée').t,
                    9.gap,
                  ],
                ),
              ],
            ).withPadding(all: 9),
          ).withPadding(bottom: 9).animate().fadeIn().asSkeleton(enabled: isLoading.value);
        }),

        // WHEN EMPTY.
        if (commentsList.isEmpty) "Sans commentaire".t.muted.center,

        // NEXT CONTENTS LOADER.
        if (hasNextContents) ...[
          27.gap,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: isLoadingNextContents.value
                    ? null
                    : () {
                        isLoadingNextContents.value = true;
                        loadComments(noLoader: true, page: page + 1);
                      },
                label: "Charger plus".t,
                icon: isLoadingNextContents.value ? SpinnerWidget(size: 14) : Icon(IconsaxPlusLinear.add),
                style: ButtonStyle(iconAlignment: IconAlignment.start),
              ),
            ],
          ),
        ],

        // PRELOADER.
        if (isLoading.value && commentsList.isEmpty)
          Card.filled(
            margin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: 18, child: Icon(IconsaxPlusLinear.user)),
                    9.gap,
                    "Nom d'utilisateur".t.bold,
                  ],
                ),
                9.gap,
                "Et est anim labore in commodo mollit labore. Incididunt est voluptate et deserunt ipsum non sunt.".t,
                Row(
                  children: [
                    TextButton.icon(label: "0 J'aime".t, icon: Icon(IconsaxPlusLinear.like_1), onPressed: () {}),
                    const Spacer(),
                    "09/09/2025".t,
                    9.gap,
                  ],
                ),
              ],
            ).withPadding(all: 9),
          ).withPadding(bottom: 9).asSkeleton(),
      ],
    ).animate().fadeIn();
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;
  // METHODS =================================================================================================================
  void loadComments({bool noLoader = false, int? page, int? pageSize}) {
    // if (!noLoader) isLoading.value = true;

    Map<String, dynamic> params = {
      'model': widget.model,
      'modelId': widget.modelId,
      'page': page ?? this.page,
      'pageSize': pageSize ?? this.pageSize,
      'sortMode': sortMode.toLowerCase(),
    };
    var requestApi = CApi.request.run((it) {
      if (page == 1 && widget.cacheIt) return CApi.cachedRequest;
      return it;
    });
    var req = requestApi.post('/app/pertn3ErZ', data: params);
    req.whenComplete(() {
      if (isLoadingNextContents.value) {
        isLoadingNextContents.value = false;
      } else {
        isLoading.value = false;
      }
    });
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          // Les commentaires ont été chargés avec succès.
          commentsList = res.data['data']?['contents'] ?? [];
          pageSize = res.data['data']['page_size'] ?? pageSize;
          page = res.data['data']['current_page'] ?? page;
          totalContents = res.data['data']['total_contents'] ?? 0;
          hasNextContents = res.data['data']['has_next'] ?? false;
          uiUpdate();
        } else {
          CToast(context).warning("Une erreur est survenue lors du chargement des commentaires.".t);
        }
      },
      onError: (e) {
        // Logger().e(e);
        CToast(context).error("Problème de connexion.".t);
      },
    );
  }

  void postComment() {
    isSending.value = true;

    Map<String, dynamic> params = {'model': widget.model, 'modelId': widget.modelId, 'comment': commentController.text};
    var req = CApi.request.post('/app/qwm6a2B1j', data: params);
    req.whenComplete(() => isSending.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          CToast(context).success("Commentaire envoyé avec succès.".t);
          commentController.clear();

          if (res.data['comment'] != null) {
            totalContents++;
            commentsList.insert(0, res.data['comment']);
          }

          uiUpdate();
        } else {
          CToast(context).warning("Le commentaire n'a pas pu être envoyé.".t);
        }
      },
      onError: (e) {
        // Logger().e(e);
        CToast(context).error("Problème de connexion.".t);
      },
    );
  }

  void toggleComment(String commentId) {
    isLikingId.value = commentId;

    Map<String, dynamic> params = {'commentId': commentId};
    var req = CApi.request.post('/app/BgCyav5pl', data: params);
    req.whenComplete(() => isLikingId.value = null);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          if (res.data['state'] == 'LIKED') {
            commentsList = commentsList.map((element) {
              if (element['id'] == commentId) {
                element['user_like_this'] = true;
                element['likes'] = res.data['count'];
              }
              return element;
            }).toList();

            CToast(
              context,
            ).success(Icon(IconsaxPlusLinear.like).stickThis("Vous venez d'aimer ce commentaire.".t.color(Colors.grey)));
            return;
          } else if (res.data['state'] == 'DISLIKED') {
            commentsList = commentsList.map((element) {
              if (element['id'] == commentId) {
                element['user_like_this'] = false;
                element['likes'] = res.data['count'];
              }
              return element;
            }).toList();

            CToast(context).success(
              Icon(
                IconsaxPlusLinear.like_dislike,
                color: context.theme.colorScheme.error,
              ).stickThis("Vous n'aimez plus ce commentaire.".t.color(Colors.grey)),
            );
            return;
          }
          CToast(context).warning("L'action n'a pas pu être effectuée.".t);
        } else {
          CToast(context).warning("Une erreur est survenue lors de l'action.".t);
        }
      },
      onError: (e) {
        // Logger().e(e);
        CToast(context).error("Problème de connexion.".t);
      },
    );
  }
}
