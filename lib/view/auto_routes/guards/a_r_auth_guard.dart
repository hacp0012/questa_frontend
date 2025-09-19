import 'package:auto_route/auto_route.dart';
import 'package:questa/models/user_mv.dart';
import 'package:questa/modules/c_api.dart';
import 'package:questa/view/auto_routes/a_r_app.gr.dart';

class ARAuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (CApi.loginToken == null) {
      resolver.redirectUntil(AuthLoginRoute(onLogin: (p0) => resolver.next(p0)));
    } else {
      UserMv().pingLogin();
      resolver.next(true);
    }
  }
}
