import 'package:auto_route/auto_route.dart';
import 'package:questa/view/auto_routes/guards/a_r_boot_guard.dart';

import 'a_r_app.gr.dart';
import 'guards/a_r_auth_guard.dart';

part './routes/app_routes.dart';
part './routes/auth_routes.dart';
part './routes/public_routes.dart';
part './routes/user_routes.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class ARApp extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.cupertino(); //.cupertino, .adaptive ..etc

  @override
  List<AutoRouteGuard> get guards => [
    ARBootGuard(
      outGuards: [
        OnboardRoute.page,
        AuthLoginRoute.page,
        AuthOtpLoginRoute.page,
        AuthRegisterRoute.page,
        PrivacyPolicyRoute.page,
        AboutAppRoute.page,
        ShareAppRoute.page,
      ],
    ),
  ];

  @override
  List<AutoRoute> get routes => [
    ...appRoutes,
    ...authRoutes,
    ...publicRoutes,
    ...userRoutes,

    // ERROR PAGE (404)
    AutoRoute(path: '*', page: ErrorRoute.page),
  ];
}
