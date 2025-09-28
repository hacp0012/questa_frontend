import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:logger/logger.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/configs/inline_notifier_keys.dart';
import 'package:questa/dsi/data_sync_interface.dart';
import 'package:questa/modules/c_api.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/screens/layouts/default_layout.dart';
import 'package:questa/view/theme/configs/tc_buttons.dart';
import 'package:questa/view/widgets/back_button_widget.dart';
import 'package:questa/view/widgets/c_toast.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:ui_value/ui_value.dart';

@RoutePage()
class TaskSkillsMenuScreen extends StatefulWidget {
  const TaskSkillsMenuScreen({super.key, @QueryParam() this.title});
  final String? title;
  // final Function(dynamic value)? onSelected;
  static String onSelectCallbackKey = DsiKeys.SKILLS_SELECTOR_PROXY.name;

  @override
  State<TaskSkillsMenuScreen> createState() => _TaskSkillsMenuScreenState();
}

class _TaskSkillsMenuScreenState extends State<TaskSkillsMenuScreen> with UiValueMixin {
  late var isLoadingDetails = uiValue(false);

  TextEditingController searchController = TextEditingController();

  List skillssList = [];
  List originalSkillsList = []; // Pour stocker la liste originale des compétences
  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void initState() {
    super.initState();
    loadDetails();
  }

  @override
  void dispose() {
    Dsi.disposeCallback(TaskSkillsMenuScreen.onSelectCallbackKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: BackButtonWidget(),
          title: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Chercher un competence",
              prefixIcon: Icon(IconsaxPlusLinear.search_normal),
              suffixIcon: Icon(Icons.close_rounded).onTap(
                () => uiUpdate(() {
                  searchController.clear();
                  simpleSearch();
                }),
              ),
            ),
            onChanged: (value) => simpleSearch(),
          ),
        ),

        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12),
          children: [
            81.gap,
            // PRESENTATION.
            Row(
              children: [
                Icon(IconsaxPlusBroken.briefcase, size: 54, color: CConsts.COLOR_GREY_LIGHT),
                9.gap,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Competance",
                      style: context.theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: CConsts.FONT_INTER,
                      ),
                    ),
                    (widget.title ?? "Selectionnez un competence").t.muted,
                  ],
                ),
              ],
            ),

            // LOADER.
            if (isLoadingDetails.value && skillssList.isEmpty)
              ResponsiveGridRow(
                children: [
                  for (int index = 0; index < 5; index++)
                    ResponsiveGridCol(
                      xs: 4,
                      child: SizedBox(
                        height: 126,
                        child: Card.filled(
                          color: CConsts.LIGHT_COLOR,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(18)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(child: Icon(IconsaxPlusBroken.brifecase_tick, size: 45)).expanded(),
                              4.5.gap,
                              Text("data"),
                              //
                            ],
                          ),
                        ).asSkeleton(),
                      ),
                    ),
                ],
              ).withPadding(top: 18),

            // CONTENTS.
            18.gap,
            ResponsiveGridRow(
              children: [
                ...skillssList.map((e) {
                  return ResponsiveGridCol(
                    xs: 4,
                    child: SizedBox(
                      height: 126,
                      child: InkWell(
                        onTap: () => _openSkillDetailBottomSheet(e),
                        radius: 18,
                        child: Card.filled(
                          color: CConsts.LIGHT_COLOR,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(18)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(child: Icon(IconsaxPlusBroken.brifecase_tick, size: 45)).expanded(),
                              4.5.gap,
                              Text("${e['name']}", overflow: TextOverflow.ellipsis),
                              //
                            ],
                          ).withPadding(all: 6),
                        ).animate().fadeIn(),
                      ),
                    ),
                  );
                }),
              ],
            ),

            // SPACER.
            81.gap,
          ],
        ),
      ),
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;
  // METHODS =================================================================================================================
  void loadDetails() {
    isLoadingDetails.value = true;

    Map<String, dynamic> params = {};
    var req = CApi.request.post('/task/rjBxVesbO', data: params);
    req.whenComplete(() => isLoadingDetails.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          skillssList = res.data['data'];
          originalSkillsList = List.from(skillssList); // Copier la liste originale
        } else {
          CToast(context).warning("Impossible de charger les donnees de puis le serveur.".t);
        }
      },
      onError: (e) {
        Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }

  void _openSkillDetailBottomSheet(Map element) {
    // List<String> topics = ((element['topics'] ?? '') as String).run<List<String>>((it) => it.split(","));

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 126,
              child: Center(child: Icon(IconsaxPlusBroken.briefcase, color: CConsts.COLOR_GREY_LIGHT, size: 63)),
            ),
            9.gap,
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${element['name'] ?? "Aucun nom disponible"}",
                  textAlign: TextAlign.center,
                  style: context.theme.textTheme.titleLarge,
                ),
                9.gap,
                Text(
                  "${element['description'] ?? "Aucun description disponible"}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: CConsts.FONT_ALBERT),
                ),
                9.gap,
                Text("Sujets").muted,
                9.gap,
              ],
            ).withPadding(horizontal: 12),

            // ACTIONS.
            Row(
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: "Fermer".t),
                Spacer(),
                FilledButton.tonalIcon(
                  style: TcButtonsLight.blackButtonTheme,
                  label: "Choisir".t,
                  icon: Icon(IconsaxPlusLinear.add_circle),
                  onPressed: () async {
                    Dsi.call(TaskSkillsMenuScreen.onSelectCallbackKey, payload: element['id']);
                    // Navigator.pop(context);
                    // await Future.delayed(900.ms);
                  },
                ),
              ],
            ).withPadding(all: 9),
            9.gap,
          ],
        );
      },
    );
  }

  void simpleSearch() {
    List<Map> filteredList = [];
    String query = searchController.text.toLowerCase();

    if (query.isEmpty) {
      // Si la recherche est vide, afficher la liste originale
      filteredList.addAll(originalSkillsList.cast<Map>());
    } else {
      // Sinon, filtrer la liste
      filteredList = originalSkillsList
          .where((skill) {
            String skillName =
                (skill['name'] as String? ?? '').toLowerCase() +
                skill['topics'].toString().toLowerCase() +
                skill['description'].toString().toLowerCase();
            return skillName.contains(query);
          })
          .toList()
          .cast<Map>();
    }

    uiUpdate(() => skillssList = filteredList);
  }
}
