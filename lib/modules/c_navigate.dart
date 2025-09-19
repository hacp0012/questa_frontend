/*import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:web/web.dart' as WEB;*/

/*extension CNavigate on BuildContext {
  void goTo(Widget wigdet) => Navigator.of(this).push(MaterialPageRoute(builder: (context) => widget));

  void goBack() => Navigator.pop(this);

  void replace(Widget widget) => Navigator.pushReplacement(this, MaterialPageRoute(builder: (context) => widget));
}

class CRouter_ {
  CRouter_(this.context);

  BuildContext context;

  void goTo(Widget widget) => Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));

  void goBack() => Navigator.pop(context);

  void replace(Widget widget) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget));
}*/

/*class CRouter {
  CRouter(this.context);

  BuildContext context;

  void goTo(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    if (kIsWeb || kIsWasm) {
      // NAVIGATE IN WEB.
      GoRouter.of(context).goNamed(name, pathParameters: pathParameters, queryParameters: queryParameters, extra: extra);
    } else {
      // NAVIGATE IN NO WEB.
      GoRouter.of(context).pushNamed(name, pathParameters: pathParameters, queryParameters: queryParameters, extra: extra);
    }
  }

  void goBack({bool userNavigator = false}) {
    if (userNavigator) {
      Navigator.pop(context);
      return;
    }

    if (kIsWeb) {
      WEB.window.history.back();
    } else {
      GoRouter.of(context).pop();
    }
  }

  void replace(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    // NAVIGATE IN WEB AND OTHERS.
    GoRouter.of(context).replaceNamed(name, pathParameters: pathParameters, queryParameters: queryParameters, extra: extra);
  }
}*/

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CRouter {
  CRouter(this.context);
  BuildContext context;

  Future<void> goTo(PageRouteInfo<Object?> route, {void Function(NavigationFailure)? onFailure}) async {
    if (kIsWeb || kIsWasm) {
      // NAVIGATE IN WEB.
      await AutoRouter.of(context).navigate(route, onFailure: onFailure);
    } else {
      // NAVIGATE IN NO WEB.
      await AutoRouter.of(context).push(route, onFailure: onFailure);
    }
  }

  Future<void> goBack({bool userNavigator = false}) async {
    if (userNavigator) {
      Navigator.pop(context);
      return;
    }

    if (kIsWeb) {
      // WEB.window.history.back();
      // AutoRouter.of(context).pop();
      context.back();
    } else {
      AutoRouter.of(context).pop();
    }
  }

  Future<void> replace(PageRouteInfo<Object?> route, {void Function(NavigationFailure)? onFailure}) async {
    await AutoRouter.of(context).replace(route, onFailure: onFailure);
  }
}
