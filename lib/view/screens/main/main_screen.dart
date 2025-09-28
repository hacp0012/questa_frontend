export '' show MainScreen;

import 'package:auto_route/auto_route.dart';
import 'package:easy_money_formatter/easy_money_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:logger/logger.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/configs/emergency_level_text.dart';
import 'package:questa/configs/inline_notifier_keys.dart';
import 'package:questa/dsi/data_sync_interface.dart';
import 'package:questa/models/user_mv.dart';
import 'package:questa/modules/c_api.dart';
import 'package:questa/modules/c_image_handler_class.dart';
import 'package:questa/modules/c_misc_class.dart';
import 'package:questa/modules/c_navigate.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/auto_routes/a_r_app.gr.dart';
import 'package:questa/view/screens/layouts/default_layout.dart';
import 'package:questa/view/screens/tasks/task_skills_menu_screen.dart';
import 'package:questa/view/theme/configs/tc_buttons.dart';
import 'package:questa/view/widgets/c_modal_widget.dart';
import 'package:questa/view/widgets/c_toast.dart';
import 'package:questa/view/widgets/chip_widget.dart';
import 'package:questa/view/widgets/divider_widget.dart';
import 'package:questa/view/widgets/icon_button_widget.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'package:questa/view/widgets/photo_viewer_widget.dart';
import 'package:questa/view/widgets/spinner_widget.dart';
import 'package:run_it/run_it.dart';
import 'package:ui_value/ui_value.dart';

part './parts/appbar_main_screnn_part.dart';
part './parts/responses_main_part.dart';
part './parts/profile_main_part.dart';
part './parts/my_tasks_main_part.dart';
part './parts/tasks_main_part.dart';
part './response_parts/chat_discusions_list_part.dart';
part './response_parts/resposes_to_tasks_part.dart';
part './response_parts/response_postulat_read_part.dart';

@RoutePage(name: 'MainScreenRoute')
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const String routeId = "h80V3mh292xgTl9eR5";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with UiValueMixin {
  late var selectedViewIndex = uiValue(1);

  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void initState() {
    super.initState();
    Dsi.model<UserMv>()!.load();
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.pageView(
      homeIndex: 2,
      // physics: const NeverScrollableScrollPhysics(),
      routes: [MyTasksMainPartRoute(), TasksMainPartRoute(), ResponsesMainPartRoute(), ProfileMainPartRoute()],
      builder: (context, child, pageController) {
        final tabsRouter = AutoTabsRouter.of(context);
        return DefaultContainer(
          navBarColor: CConsts.LIGHT_COLOR,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            // BDOY.
            body: child,

            /*body: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) => selectedViewIndex.value = index,
              children: const <Widget>[MyTasksMainPart(), TasksMainPart(), ResponsesMainPart(), ProfileMainPart()],
            ),
            bottomNavigationBar: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(18)),
                boxShadow: [
                  BoxShadow(
                    color: CConsts.SECONDARY_COLOR.withAlpha(10),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, -2), // changes position of shadow
                  ),
                ],
              ),
              child: BottomBar(
                backgroundColor: CConsts.LIGHT_COLOR,
                selectedIndex: selectedViewIndex.value,
                onTap: (int index) {
                  selectedViewIndex.value = index;
                  _pageController.animateToPage(index, curve: Curves.easeIn, duration: 360.ms);
                },
                items: <BottomBarItem>[
                  BottomBarItem(
                    inactiveIcon: Icon(IconsaxPlusLinear.note, color: Colors.grey),
                    icon: Icon(IconsaxPlusBold.note),
                    title: Text('Mes tâches'),
                    activeColor: Colors.blue,
                    activeTitleColor: context.theme.colorScheme.secondary,
                    activeIconColor: context.theme.colorScheme.secondary,
                  ),
                  BottomBarItem(
                    // inactiveIcon: Icon(IconsaxPlusBroken.activity, color: Colors.grey),
                    // icon: Icon(IconsaxPlusLinear.activity),
                    inactiveIcon: Image.asset("lib/assets/icons/logo_q_secondary_color.png", height: 27),
                    icon: Image.asset("lib/assets/icons/logo_q_primary_color.png", height: 27),
                    title: Text('Tâches'),
                    activeColor: context.theme.colorScheme.primary,
                    activeTitleColor: context.theme.colorScheme.secondary,
                    activeIconColor: context.theme.colorScheme.secondary,
                  ),
                  BottomBarItem(
                    inactiveIcon: Icon(IconsaxPlusBroken.messages, color: Colors.grey),
                    icon: Icon(IconsaxPlusLinear.messages),
                    title: Text('Reponses'),
                    activeColor: Colors.greenAccent.shade700,
                    activeTitleColor: context.theme.colorScheme.secondary,
                    activeIconColor: context.theme.colorScheme.secondary,
                  ),
                  BottomBarItem(
                    inactiveIcon: Icon(IconsaxPlusBroken.user, color: Colors.grey),
                    icon: Icon(IconsaxPlusLinear.user_cirlce_add),
                    title: Text('Profil'),
                    activeColor: Colors.orange,
                  ),
                ],
              ),
            ), */
            bottomNavigationBar: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(18)),
                boxShadow: [
                  BoxShadow(
                    color: CConsts.SECONDARY_COLOR.withAlpha(10),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, -2), // changes position of shadow
                  ),
                ],
              ),
              child: BottomBar(
                backgroundColor: CConsts.LIGHT_COLOR,
                selectedIndex: tabsRouter.activeIndex,
                onTap: (int index) => tabsRouter.setActiveIndex(index),
                items: <BottomBarItem>[
                  BottomBarItem(
                    inactiveIcon: Icon(IconsaxPlusLinear.note, color: Colors.grey),
                    icon: Icon(IconsaxPlusBold.note),
                    title: Text('Mes tâches'),
                    activeColor: Colors.blue,
                    activeTitleColor: context.theme.colorScheme.secondary,
                    activeIconColor: context.theme.colorScheme.secondary,
                  ),
                  BottomBarItem(
                    // inactiveIcon: Icon(IconsaxPlusBroken.activity, color: Colors.grey),
                    // icon: Icon(IconsaxPlusLinear.activity),
                    inactiveIcon: Image.asset("lib/assets/icons/logo_q_secondary_color.png", height: 27),
                    icon: Image.asset("lib/assets/icons/logo_q_primary_color.png", height: 27),
                    title: Text('Tâches'),
                    activeColor: context.theme.colorScheme.primary,
                    activeTitleColor: context.theme.colorScheme.secondary,
                    activeIconColor: context.theme.colorScheme.secondary,
                  ),
                  BottomBarItem(
                    inactiveIcon: Icon(IconsaxPlusBroken.messages, color: Colors.grey),
                    icon: Icon(IconsaxPlusLinear.messages),
                    title: Text('Chats'),
                    activeColor: Colors.greenAccent.shade700,
                    activeTitleColor: context.theme.colorScheme.secondary,
                    activeIconColor: context.theme.colorScheme.secondary,
                  ),
                  BottomBarItem(
                    inactiveIcon: Icon(IconsaxPlusBroken.user, color: Colors.grey),
                    icon: Icon(IconsaxPlusLinear.user_cirlce_add),
                    title: Text('Profil'),
                    activeColor: Colors.orange,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;

  @override
  void dispose() {
    super.dispose();
  }

  // METHODS =================================================================================================================
}
