import 'package:auto_route/auto_route.dart';
import 'package:questa/modules/c_api.dart';
import 'package:questa/modules/c_store.dart';
import 'package:questa/view/auto_routes/a_r_app.gr.dart';

class ARBootGuard extends AutoRouteGuard {
  ARBootGuard({required this.outGuards});
  List<PageInfo> outGuards;

  /// Routes that are out bool guard.
  // List<String> outGuards = [OnboardRoute.name, AuthLoginRoute.name, PrivacyPolicyRoute.name];

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    for (int index = 0; index < outGuards.length; index++) {
      if (resolver.routeName == outGuards[index].name) {
        resolver.next(true);
        return;
      }
    }

    bool isFirstLaunchedApp = CStore.prefs.getBool('first_launched_this_app') ?? true;
    bool hasLogintoken = CApi.loginToken != null;

    if (isFirstLaunchedApp) {
      resolver.redirectUntil(OnboardRoute());
    } else if (!hasLogintoken) {
      resolver.redirectUntil(AuthLoginRoute());
    } else {
      resolver.next(true);
    }
  }
}
