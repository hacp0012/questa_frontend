part of '../a_r_app.dart';

var appRoutes = [
  AutoRoute(
    path: '/',
    guards: [ARAuthGuard()],
    page: MainScreenRoute.page,
    initial: true,
    children: [
      AutoRoute(page: MyTasksMainPartRoute.page),
      AutoRoute(page: TasksMainPartRoute.page),
      AutoRoute(page: ResponsesMainPartRoute.page),
      AutoRoute(page: ProfileMainPartRoute.page),
    ],
  ),
  AutoRoute(path: '/933907642898730167', guards: [ARAuthGuard()], page: ChatRoute.page),
];
