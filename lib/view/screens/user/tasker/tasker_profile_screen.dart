import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
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
import 'package:questa/view/widgets/commenter_widget.dart';
import 'package:questa/view/widgets/icon_button_widget.dart';
import 'package:questa/view/widgets/spinner_widget.dart';
import 'package:ui_value/ui_value.dart';

@RoutePage()
class TaskerProfileScreen extends StatefulWidget {
  const TaskerProfileScreen({super.key, @queryParam required this.taskerId});
  static const String routeId = "67TrN682L83243tr058o3Xc1242";
  final String? taskerId;

  @override
  State<TaskerProfileScreen> createState() => _TaskerProfileScreenState();
}

class _TaskerProfileScreenState extends State<TaskerProfileScreen> with UiValueMixin {
  late var isLoadingDetails = uiValue(false);

  String? _coverPicture;
  String? _profilePicture;
  Map _tasker = {};
  Map _user = {};
  List _portfolios = [];
  List _reactions = [];
  List _skills = [];

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
    return DefaultContainer(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        // BODY.
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              leading: BackButtonWidget(),
              centerTitle: true,
              title: "Profile".t,
              actions: [IconButtonWidget(icon: Icon(IconsaxPlusLinear.save_2))],
            ),

            if (isLoadingDetails.value)
              SliverList(delegate: SliverChildListDelegate([_loader()]))
            else
              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(
                    height: 207,
                    child: Stack(
                      children: [
                        Positioned(
                          child: Card.filled(
                            clipBehavior: Clip.hardEdge,
                            child: Image.network(
                              CNetworkFilesClass.picture(_coverPicture, scale: 36),
                              height: 154,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Center(child: Icon(IconsaxPlusLinear.user)),
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(child: SpinnerWidget());
                              },
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // STARTS
                              OutlinedButton.icon(onPressed: () {}, icon: Icon(IconsaxPlusLinear.star), label: "34".t),

                              // AVATAR
                              Badge(
                                alignment: Alignment.bottomCenter,
                                backgroundColor: Colors.amber,
                                offset: Offset(-27, -12),
                                label: "Profile PRO".t,
                                child: Material(
                                  color: CConsts.PRIMARY_COLOR,
                                  borderRadius: BorderRadiusGeometry.circular(100),
                                  child: CircleAvatar(
                                    backgroundImage: Image.network(CNetworkFilesClass.picture(_profilePicture)).image,
                                    radius: 54,
                                  ).withPadding(all: 9),
                                ),
                              ),

                              // DEALS
                              OutlinedButton.icon(
                                onPressed: () {},
                                icon: Icon(IconsaxPlusLinear.briefcase),
                                iconAlignment: IconAlignment.end,
                                label: "23".t,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  9.gap,
                  Text(
                    "${_user['name'] ?? 'N/A'}",
                    style: context.theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  9.gap,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton.tonalIcon(
                        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(CConsts.LIGHT_COLOR)),
                        onPressed: () {},
                        icon: Icon(IconsaxPlusLinear.like_1),
                        label: "12".t,
                      ),
                      9.gap,
                      FilledButton.tonalIcon(
                        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(CConsts.LIGHT_COLOR)),
                        onPressed: null,
                        icon: Icon(IconsaxPlusLinear.map_1),
                        label: "${_tasker['address']?['ville']['name'] ?? 'N/A'}".t,
                      ),
                    ],
                  ),

                  // PORTFOLIOS.
                  18.gap,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        9.gap,
                        for (int index = 0; index < _portfolios.length; index++)
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: InkWell(
                              onTap: () {
                                CRouter(context).goTo(TaskerPortfolioReadRoute(portfolioId: _portfolios[index]['id']));
                              },
                              child: Card.filled(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Center(child: Icon(IconsaxPlusBold.briefcase)).expanded(),
                                    "${_portfolios[index]['title'] ?? 'N/A'}".t.elipsis,
                                  ],
                                ).withPadding(all: 6),
                              ),
                            ),
                          ),
                        9.gap,
                      ],
                    ),
                  ),
                  9.gap,
                  if (_portfolios.length > 3)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(onPressed: () {}, child: "Tout voir".t),
                        9.gap,
                      ],
                    ),

                  // SKILLS.
                  18.gap,
                  "Competances".t.muted.bold.withPadding(left: 9),
                  9.gap,
                  Wrap(
                    runSpacing: 4.5,
                    spacing: 4.5,
                    children: [
                      ...((_tasker['skill_sectors'] ?? []) as List).map((e) {
                        for (int index = 0; index < _skills.length; index++) {
                          if (_skills[index]['id'] == e) {
                            return Chip(label: "${_skills[index]['name'] ?? 'N/A'}".t);
                          }
                        }

                        return Container();
                      }),
                    ],
                  ).withPadding(horizontal: 12),

                  // DESCRIPTION.
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      18.gap,
                      Text("Description").bold,
                      9.gap,
                      Text(
                        "${_tasker['description'] ?? "Aucun description fourni."}",
                        style: context.theme.textTheme.bodyLarge,
                      ),
                    ],
                  ).withPadding(horizontal: 12),

                  // CONTANCTS.
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      18.gap,
                      Text("Contacts").bold,
                      4.5.gap,
                      Text("Telephoen: ${_user['telephone'] ?? 'N/A'}"),
                      4.5.gap,
                      Text("E-mail: ${_user['email'] ?? 'N/A'}"),
                      4.5.gap,
                      Text("autres contacts: ${_user['contacts'] ?? 'N/A'}"),
                      4.5.gap,
                      Text("Ville: Bukavu"),
                      4.5.gap,
                      Text(
                        "Adresse: ${_tasker['address']?['avenue']['name'] ?? 'N/A'}, "
                        "${_tasker['address']?['quartier']['name'] ?? 'N/A'}, "
                        "${_tasker['address']?['ville']['name'] ?? 'N/A'}, "
                        "${_tasker['address']?['province']['name'] ?? 'N/A'}, ${CConsts.CENTER_DOT} "
                        "${_tasker['address']?['pays']['name'] ?? 'N/A'}",
                      ),
                      9.gap,
                      Text("Adresse de reference: ${_tasker['address_ref'] ?? 'N/A'}"),
                    ],
                  ).withPadding(horizontal: 12),

                  // COMMENTER
                  12.gap,
                  CommenterWidget(
                    model: 'App\\Models\\Taskers',
                    modelId: widget.taskerId ?? '---',
                    title: "Commentez cet profile".t.bold,
                  ).withPadding(horizontal: 9),

                  // SPCER.
                  81.gap,
                ]),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;

  Widget _loader() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [SpinnerWidget(), 12.gap, Text("Chargement...")],
      ),
    ).sized(height: 360);
  }

  // METHODS =================================================================================================================
  void loadDetails() {
    isLoadingDetails.value = true;
    _reactions;

    Map<String, dynamic> params = {'taskerId': widget.taskerId};
    var req = CApi.request.get('/user/tasker/YfGeyOlhq', queryParameters: params);
    req.whenComplete(() => isLoadingDetails.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          var data = res.data['data'];
          _coverPicture = data['cover_picture'];
          _profilePicture = data['profile_picture'];
          _portfolios = data['portfolios'] ?? [];
          _reactions = data['reactions'] ?? [];
          _tasker = data['tasker'] ?? {};
          _user = data['user'] ?? {};
          _skills = data['skills'] ?? {};
        } else {
          CToast(context).warning("Impossible de charger les contenus.".t);
        }
      },
      onError: (e) {
        Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }
}
