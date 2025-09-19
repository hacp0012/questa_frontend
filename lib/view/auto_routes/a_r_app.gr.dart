// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i28;
import 'package:flutter/cupertino.dart' as _i31;
import 'package:flutter/foundation.dart' as _i29;
import 'package:flutter/material.dart' as _i30;
import 'package:go_router/go_router.dart' as _i32;
import 'package:questa/view/screens/app/about_app_screen.dart' as _i1;
import 'package:questa/view/screens/app/onboard_screen.dart' as _i10;
import 'package:questa/view/screens/app/privacy_policy_screen.dart' as _i11;
import 'package:questa/view/screens/app/share_app_screen.dart' as _i12;
import 'package:questa/view/screens/error_screen.dart' as _i7;
import 'package:questa/view/screens/main/main_screen.dart' as _i8;
import 'package:questa/view/screens/pages/chat_screen.dart' as _i5;
import 'package:questa/view/screens/pages/notifications_screen.dart' as _i9;
import 'package:questa/view/screens/pages/taskers_screen.dart' as _i24;
import 'package:questa/view/screens/tasks/task_new_task_screen.dart' as _i13;
import 'package:questa/view/screens/tasks/task_responses_screen.dart' as _i14;
import 'package:questa/view/screens/tasks/task_skills_menu_screen.dart' as _i15;
import 'package:questa/view/screens/user/auth/auth_login_screen.dart' as _i2;
import 'package:questa/view/screens/user/auth/auth_opt_login_screen.dart'
    as _i3;
import 'package:questa/view/screens/user/auth/auth_register_screen.dart' as _i4;
import 'package:questa/view/screens/user/tasker/delete_tasker_profile_screen.dart'
    as _i6;
import 'package:questa/view/screens/user/tasker/tasker_edit_profile_screen.dart'
    as _i16;
import 'package:questa/view/screens/user/tasker/tasker_portfolio_add_screen.dart'
    as _i17;
import 'package:questa/view/screens/user/tasker/tasker_portfolio_edit_screen.dart'
    as _i18;
import 'package:questa/view/screens/user/tasker/tasker_portfolio_read_screen.dart'
    as _i19;
import 'package:questa/view/screens/user/tasker/tasker_profile_screen.dart'
    as _i20;
import 'package:questa/view/screens/user/tasker/tasker_register_screen.dart'
    as _i21;
import 'package:questa/view/screens/user/tasker/tasker_user_main_screen.dart'
    as _i22;
import 'package:questa/view/screens/user/tasker/tasker_validation_ids_screen.dart'
    as _i23;
import 'package:questa/view/screens/user/user_delete_profile_screen.dart'
    as _i25;
import 'package:questa/view/screens/user/user_profile_option_screen.dart'
    as _i26;
import 'package:questa/view/screens/user/user_profile_read_screen.dart' as _i27;

/// generated route for
/// [_i1.AboutAppScreen]
class AboutAppRoute extends _i28.PageRouteInfo<void> {
  const AboutAppRoute({List<_i28.PageRouteInfo>? children})
    : super(AboutAppRoute.name, initialChildren: children);

  static const String name = 'AboutAppRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i1.AboutAppScreen();
    },
  );
}

/// generated route for
/// [_i2.AuthLoginScreen]
class AuthLoginRoute extends _i28.PageRouteInfo<AuthLoginRouteArgs> {
  AuthLoginRoute({
    _i29.Key? key,
    dynamic Function(bool)? onLogin,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         AuthLoginRoute.name,
         args: AuthLoginRouteArgs(key: key, onLogin: onLogin),
         initialChildren: children,
       );

  static const String name = 'AuthLoginRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AuthLoginRouteArgs>(
        orElse: () => const AuthLoginRouteArgs(),
      );
      return _i2.AuthLoginScreen(key: args.key, onLogin: args.onLogin);
    },
  );
}

class AuthLoginRouteArgs {
  const AuthLoginRouteArgs({this.key, this.onLogin});

  final _i29.Key? key;

  final dynamic Function(bool)? onLogin;

  @override
  String toString() {
    return 'AuthLoginRouteArgs{key: $key, onLogin: $onLogin}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AuthLoginRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [_i3.AuthOtpLoginScreen]
class AuthOtpLoginRoute extends _i28.PageRouteInfo<AuthOtpLoginRouteArgs> {
  AuthOtpLoginRoute({
    _i29.Key? key,
    required String? phoneCode,
    required String? phoneNumber,
    bool isRegister = false,
    String? otp,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         AuthOtpLoginRoute.name,
         args: AuthOtpLoginRouteArgs(
           key: key,
           phoneCode: phoneCode,
           phoneNumber: phoneNumber,
           isRegister: isRegister,
           otp: otp,
         ),
         rawQueryParams: {
           'phoneCode': phoneCode,
           'phoneNumber': phoneNumber,
           'isRegister': isRegister,
           'otp': otp,
         },
         initialChildren: children,
       );

  static const String name = 'AuthOtpLoginRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<AuthOtpLoginRouteArgs>(
        orElse: () => AuthOtpLoginRouteArgs(
          phoneCode: queryParams.optString('phoneCode'),
          phoneNumber: queryParams.optString('phoneNumber'),
          isRegister: queryParams.getBool('isRegister', false),
          otp: queryParams.optString('otp'),
        ),
      );
      return _i3.AuthOtpLoginScreen(
        key: args.key,
        phoneCode: args.phoneCode,
        phoneNumber: args.phoneNumber,
        isRegister: args.isRegister,
        otp: args.otp,
      );
    },
  );
}

class AuthOtpLoginRouteArgs {
  const AuthOtpLoginRouteArgs({
    this.key,
    required this.phoneCode,
    required this.phoneNumber,
    this.isRegister = false,
    this.otp,
  });

  final _i29.Key? key;

  final String? phoneCode;

  final String? phoneNumber;

  final bool isRegister;

  final String? otp;

  @override
  String toString() {
    return 'AuthOtpLoginRouteArgs{key: $key, phoneCode: $phoneCode, phoneNumber: $phoneNumber, isRegister: $isRegister, otp: $otp}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AuthOtpLoginRouteArgs) return false;
    return key == other.key &&
        phoneCode == other.phoneCode &&
        phoneNumber == other.phoneNumber &&
        isRegister == other.isRegister &&
        otp == other.otp;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      phoneCode.hashCode ^
      phoneNumber.hashCode ^
      isRegister.hashCode ^
      otp.hashCode;
}

/// generated route for
/// [_i4.AuthRegisterScreen]
class AuthRegisterRoute extends _i28.PageRouteInfo<AuthRegisterRouteArgs> {
  AuthRegisterRoute({
    _i30.Key? key,
    String? phoneCode,
    String? phoneNumber,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         AuthRegisterRoute.name,
         args: AuthRegisterRouteArgs(
           key: key,
           phoneCode: phoneCode,
           phoneNumber: phoneNumber,
         ),
         rawQueryParams: {'phoneCode': phoneCode, 'phoneNumber': phoneNumber},
         initialChildren: children,
       );

  static const String name = 'AuthRegisterRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<AuthRegisterRouteArgs>(
        orElse: () => AuthRegisterRouteArgs(
          phoneCode: queryParams.optString('phoneCode'),
          phoneNumber: queryParams.optString('phoneNumber'),
        ),
      );
      return _i4.AuthRegisterScreen(
        key: args.key,
        phoneCode: args.phoneCode,
        phoneNumber: args.phoneNumber,
      );
    },
  );
}

class AuthRegisterRouteArgs {
  const AuthRegisterRouteArgs({this.key, this.phoneCode, this.phoneNumber});

  final _i30.Key? key;

  final String? phoneCode;

  final String? phoneNumber;

  @override
  String toString() {
    return 'AuthRegisterRouteArgs{key: $key, phoneCode: $phoneCode, phoneNumber: $phoneNumber}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AuthRegisterRouteArgs) return false;
    return key == other.key &&
        phoneCode == other.phoneCode &&
        phoneNumber == other.phoneNumber;
  }

  @override
  int get hashCode => key.hashCode ^ phoneCode.hashCode ^ phoneNumber.hashCode;
}

/// generated route for
/// [_i5.ChatScreen]
class ChatRoute extends _i28.PageRouteInfo<void> {
  const ChatRoute({List<_i28.PageRouteInfo>? children})
    : super(ChatRoute.name, initialChildren: children);

  static const String name = 'ChatRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i5.ChatScreen();
    },
  );
}

/// generated route for
/// [_i6.DeleteTaskerProfileScreen]
class DeleteTaskerProfileRoute extends _i28.PageRouteInfo<void> {
  const DeleteTaskerProfileRoute({List<_i28.PageRouteInfo>? children})
    : super(DeleteTaskerProfileRoute.name, initialChildren: children);

  static const String name = 'DeleteTaskerProfileRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i6.DeleteTaskerProfileScreen();
    },
  );
}

/// generated route for
/// [_i7.ErrorScreen]
class ErrorRoute extends _i28.PageRouteInfo<ErrorRouteArgs> {
  ErrorRoute({
    _i31.Key? key,
    required _i32.GoRouterState routeState,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         ErrorRoute.name,
         args: ErrorRouteArgs(key: key, routeState: routeState),
         initialChildren: children,
       );

  static const String name = 'ErrorRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ErrorRouteArgs>();
      return _i7.ErrorScreen(key: args.key, routeState: args.routeState);
    },
  );
}

class ErrorRouteArgs {
  const ErrorRouteArgs({this.key, required this.routeState});

  final _i31.Key? key;

  final _i32.GoRouterState routeState;

  @override
  String toString() {
    return 'ErrorRouteArgs{key: $key, routeState: $routeState}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ErrorRouteArgs) return false;
    return key == other.key && routeState == other.routeState;
  }

  @override
  int get hashCode => key.hashCode ^ routeState.hashCode;
}

/// generated route for
/// [_i8.MainScreen]
class MainScreenRoute extends _i28.PageRouteInfo<void> {
  const MainScreenRoute({List<_i28.PageRouteInfo>? children})
    : super(MainScreenRoute.name, initialChildren: children);

  static const String name = 'MainScreenRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i8.MainScreen();
    },
  );
}

/// generated route for
/// [_i8.MyTasksMainPart]
class MyTasksMainPartRoute extends _i28.PageRouteInfo<void> {
  const MyTasksMainPartRoute({List<_i28.PageRouteInfo>? children})
    : super(MyTasksMainPartRoute.name, initialChildren: children);

  static const String name = 'MyTasksMainPartRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i8.MyTasksMainPart();
    },
  );
}

/// generated route for
/// [_i9.NotificationsScreen]
class NotificationsRoute extends _i28.PageRouteInfo<void> {
  const NotificationsRoute({List<_i28.PageRouteInfo>? children})
    : super(NotificationsRoute.name, initialChildren: children);

  static const String name = 'NotificationsRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i9.NotificationsScreen();
    },
  );
}

/// generated route for
/// [_i10.OnboardScreen]
class OnboardRoute extends _i28.PageRouteInfo<void> {
  const OnboardRoute({List<_i28.PageRouteInfo>? children})
    : super(OnboardRoute.name, initialChildren: children);

  static const String name = 'OnboardRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i10.OnboardScreen();
    },
  );
}

/// generated route for
/// [_i11.PrivacyPolicyScreen]
class PrivacyPolicyRoute extends _i28.PageRouteInfo<void> {
  const PrivacyPolicyRoute({List<_i28.PageRouteInfo>? children})
    : super(PrivacyPolicyRoute.name, initialChildren: children);

  static const String name = 'PrivacyPolicyRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i11.PrivacyPolicyScreen();
    },
  );
}

/// generated route for
/// [_i8.ProfileMainPart]
class ProfileMainPartRoute extends _i28.PageRouteInfo<void> {
  const ProfileMainPartRoute({List<_i28.PageRouteInfo>? children})
    : super(ProfileMainPartRoute.name, initialChildren: children);

  static const String name = 'ProfileMainPartRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i8.ProfileMainPart();
    },
  );
}

/// generated route for
/// [_i8.ResponsesMainPart]
class ResponsesMainPartRoute extends _i28.PageRouteInfo<void> {
  const ResponsesMainPartRoute({List<_i28.PageRouteInfo>? children})
    : super(ResponsesMainPartRoute.name, initialChildren: children);

  static const String name = 'ResponsesMainPartRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i8.ResponsesMainPart();
    },
  );
}

/// generated route for
/// [_i12.ShareAppScreen]
class ShareAppRoute extends _i28.PageRouteInfo<ShareAppRouteArgs> {
  ShareAppRoute({
    _i30.Key? key,
    bool isShared = false,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         ShareAppRoute.name,
         args: ShareAppRouteArgs(key: key, isShared: isShared),
         initialChildren: children,
       );

  static const String name = 'ShareAppRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ShareAppRouteArgs>(
        orElse: () => const ShareAppRouteArgs(),
      );
      return _i12.ShareAppScreen(key: args.key, isShared: args.isShared);
    },
  );
}

class ShareAppRouteArgs {
  const ShareAppRouteArgs({this.key, this.isShared = false});

  final _i30.Key? key;

  final bool isShared;

  @override
  String toString() {
    return 'ShareAppRouteArgs{key: $key, isShared: $isShared}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ShareAppRouteArgs) return false;
    return key == other.key && isShared == other.isShared;
  }

  @override
  int get hashCode => key.hashCode ^ isShared.hashCode;
}

/// generated route for
/// [_i13.TaskNewTaskScreen]
class TaskNewTaskRoute extends _i28.PageRouteInfo<TaskNewTaskRouteArgs> {
  TaskNewTaskRoute({
    _i30.Key? key,
    String? skillId,
    String? taskName,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         TaskNewTaskRoute.name,
         args: TaskNewTaskRouteArgs(
           key: key,
           skillId: skillId,
           taskName: taskName,
         ),
         rawQueryParams: {'skillId': skillId, 'taskName': taskName},
         initialChildren: children,
       );

  static const String name = 'TaskNewTaskRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<TaskNewTaskRouteArgs>(
        orElse: () => TaskNewTaskRouteArgs(
          skillId: queryParams.optString('skillId'),
          taskName: queryParams.optString('taskName'),
        ),
      );
      return _i13.TaskNewTaskScreen(
        key: args.key,
        skillId: args.skillId,
        taskName: args.taskName,
      );
    },
  );
}

class TaskNewTaskRouteArgs {
  const TaskNewTaskRouteArgs({this.key, this.skillId, this.taskName});

  final _i30.Key? key;

  final String? skillId;

  final String? taskName;

  @override
  String toString() {
    return 'TaskNewTaskRouteArgs{key: $key, skillId: $skillId, taskName: $taskName}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TaskNewTaskRouteArgs) return false;
    return key == other.key &&
        skillId == other.skillId &&
        taskName == other.taskName;
  }

  @override
  int get hashCode => key.hashCode ^ skillId.hashCode ^ taskName.hashCode;
}

/// generated route for
/// [_i14.TaskResponsesScreen]
class TaskResponsesRoute extends _i28.PageRouteInfo<TaskResponsesRouteArgs> {
  TaskResponsesRoute({
    _i30.Key? key,
    required String taskId,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         TaskResponsesRoute.name,
         args: TaskResponsesRouteArgs(key: key, taskId: taskId),
         initialChildren: children,
       );

  static const String name = 'TaskResponsesRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TaskResponsesRouteArgs>();
      return _i14.TaskResponsesScreen(key: args.key, taskId: args.taskId);
    },
  );
}

class TaskResponsesRouteArgs {
  const TaskResponsesRouteArgs({this.key, required this.taskId});

  final _i30.Key? key;

  final String taskId;

  @override
  String toString() {
    return 'TaskResponsesRouteArgs{key: $key, taskId: $taskId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TaskResponsesRouteArgs) return false;
    return key == other.key && taskId == other.taskId;
  }

  @override
  int get hashCode => key.hashCode ^ taskId.hashCode;
}

/// generated route for
/// [_i15.TaskSkillsMenuScreen]
class TaskSkillsMenuRoute extends _i28.PageRouteInfo<TaskSkillsMenuRouteArgs> {
  TaskSkillsMenuRoute({
    _i30.Key? key,
    String? title,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         TaskSkillsMenuRoute.name,
         args: TaskSkillsMenuRouteArgs(key: key, title: title),
         rawQueryParams: {'title': title},
         initialChildren: children,
       );

  static const String name = 'TaskSkillsMenuRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<TaskSkillsMenuRouteArgs>(
        orElse: () =>
            TaskSkillsMenuRouteArgs(title: queryParams.optString('title')),
      );
      return _i15.TaskSkillsMenuScreen(key: args.key, title: args.title);
    },
  );
}

class TaskSkillsMenuRouteArgs {
  const TaskSkillsMenuRouteArgs({this.key, this.title});

  final _i30.Key? key;

  final String? title;

  @override
  String toString() {
    return 'TaskSkillsMenuRouteArgs{key: $key, title: $title}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TaskSkillsMenuRouteArgs) return false;
    return key == other.key && title == other.title;
  }

  @override
  int get hashCode => key.hashCode ^ title.hashCode;
}

/// generated route for
/// [_i16.TaskerEditProfileScreen]
class TaskerEditProfileRoute extends _i28.PageRouteInfo<void> {
  const TaskerEditProfileRoute({List<_i28.PageRouteInfo>? children})
    : super(TaskerEditProfileRoute.name, initialChildren: children);

  static const String name = 'TaskerEditProfileRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i16.TaskerEditProfileScreen();
    },
  );
}

/// generated route for
/// [_i17.TaskerPortfolioAddScreen]
class TaskerPortfolioAddRoute extends _i28.PageRouteInfo<void> {
  const TaskerPortfolioAddRoute({List<_i28.PageRouteInfo>? children})
    : super(TaskerPortfolioAddRoute.name, initialChildren: children);

  static const String name = 'TaskerPortfolioAddRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i17.TaskerPortfolioAddScreen();
    },
  );
}

/// generated route for
/// [_i18.TaskerPortfolioEditScreen]
class TaskerPortfolioEditRoute
    extends _i28.PageRouteInfo<TaskerPortfolioEditRouteArgs> {
  TaskerPortfolioEditRoute({
    _i29.Key? key,
    String? portfolioId,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         TaskerPortfolioEditRoute.name,
         args: TaskerPortfolioEditRouteArgs(key: key, portfolioId: portfolioId),
         rawQueryParams: {'portfolioId': portfolioId},
         initialChildren: children,
       );

  static const String name = 'TaskerPortfolioEditRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<TaskerPortfolioEditRouteArgs>(
        orElse: () => TaskerPortfolioEditRouteArgs(
          portfolioId: queryParams.optString('portfolioId'),
        ),
      );
      return _i18.TaskerPortfolioEditScreen(
        key: args.key,
        portfolioId: args.portfolioId,
      );
    },
  );
}

class TaskerPortfolioEditRouteArgs {
  const TaskerPortfolioEditRouteArgs({this.key, this.portfolioId});

  final _i29.Key? key;

  final String? portfolioId;

  @override
  String toString() {
    return 'TaskerPortfolioEditRouteArgs{key: $key, portfolioId: $portfolioId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TaskerPortfolioEditRouteArgs) return false;
    return key == other.key && portfolioId == other.portfolioId;
  }

  @override
  int get hashCode => key.hashCode ^ portfolioId.hashCode;
}

/// generated route for
/// [_i19.TaskerPortfolioReadScreen]
class TaskerPortfolioReadRoute
    extends _i28.PageRouteInfo<TaskerPortfolioReadRouteArgs> {
  TaskerPortfolioReadRoute({
    _i30.Key? key,
    String? portfolioId,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         TaskerPortfolioReadRoute.name,
         args: TaskerPortfolioReadRouteArgs(key: key, portfolioId: portfolioId),
         rawQueryParams: {'portfolioId': portfolioId},
         initialChildren: children,
       );

  static const String name = 'TaskerPortfolioReadRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<TaskerPortfolioReadRouteArgs>(
        orElse: () => TaskerPortfolioReadRouteArgs(
          portfolioId: queryParams.optString('portfolioId'),
        ),
      );
      return _i19.TaskerPortfolioReadScreen(
        key: args.key,
        portfolioId: args.portfolioId,
      );
    },
  );
}

class TaskerPortfolioReadRouteArgs {
  const TaskerPortfolioReadRouteArgs({this.key, this.portfolioId});

  final _i30.Key? key;

  final String? portfolioId;

  @override
  String toString() {
    return 'TaskerPortfolioReadRouteArgs{key: $key, portfolioId: $portfolioId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TaskerPortfolioReadRouteArgs) return false;
    return key == other.key && portfolioId == other.portfolioId;
  }

  @override
  int get hashCode => key.hashCode ^ portfolioId.hashCode;
}

/// generated route for
/// [_i20.TaskerProfileScreen]
class TaskerProfileRoute extends _i28.PageRouteInfo<void> {
  const TaskerProfileRoute({List<_i28.PageRouteInfo>? children})
    : super(TaskerProfileRoute.name, initialChildren: children);

  static const String name = 'TaskerProfileRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i20.TaskerProfileScreen();
    },
  );
}

/// generated route for
/// [_i21.TaskerRegisterScreen]
class TaskerRegisterRoute extends _i28.PageRouteInfo<void> {
  const TaskerRegisterRoute({List<_i28.PageRouteInfo>? children})
    : super(TaskerRegisterRoute.name, initialChildren: children);

  static const String name = 'TaskerRegisterRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i21.TaskerRegisterScreen();
    },
  );
}

/// generated route for
/// [_i22.TaskerUserMainScreen]
class TaskerUserMainRoute extends _i28.PageRouteInfo<void> {
  const TaskerUserMainRoute({List<_i28.PageRouteInfo>? children})
    : super(TaskerUserMainRoute.name, initialChildren: children);

  static const String name = 'TaskerUserMainRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i22.TaskerUserMainScreen();
    },
  );
}

/// generated route for
/// [_i23.TaskerValidationIdsScreen]
class TaskerValidationIdsRoute extends _i28.PageRouteInfo<void> {
  const TaskerValidationIdsRoute({List<_i28.PageRouteInfo>? children})
    : super(TaskerValidationIdsRoute.name, initialChildren: children);

  static const String name = 'TaskerValidationIdsRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i23.TaskerValidationIdsScreen();
    },
  );
}

/// generated route for
/// [_i24.TaskersScreen]
class TaskersRoute extends _i28.PageRouteInfo<void> {
  const TaskersRoute({List<_i28.PageRouteInfo>? children})
    : super(TaskersRoute.name, initialChildren: children);

  static const String name = 'TaskersRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i24.TaskersScreen();
    },
  );
}

/// generated route for
/// [_i8.TasksMainPart]
class TasksMainPartRoute extends _i28.PageRouteInfo<void> {
  const TasksMainPartRoute({List<_i28.PageRouteInfo>? children})
    : super(TasksMainPartRoute.name, initialChildren: children);

  static const String name = 'TasksMainPartRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i8.TasksMainPart();
    },
  );
}

/// generated route for
/// [_i25.UserDeleteProfileScreen]
class UserDeleteProfileRoute extends _i28.PageRouteInfo<void> {
  const UserDeleteProfileRoute({List<_i28.PageRouteInfo>? children})
    : super(UserDeleteProfileRoute.name, initialChildren: children);

  static const String name = 'UserDeleteProfileRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i25.UserDeleteProfileScreen();
    },
  );
}

/// generated route for
/// [_i26.UserProfileOptionScreen]
class UserProfileOptionRoute extends _i28.PageRouteInfo<void> {
  const UserProfileOptionRoute({List<_i28.PageRouteInfo>? children})
    : super(UserProfileOptionRoute.name, initialChildren: children);

  static const String name = 'UserProfileOptionRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i26.UserProfileOptionScreen();
    },
  );
}

/// generated route for
/// [_i27.UserProfileReadScreen]
class UserProfileReadRoute
    extends _i28.PageRouteInfo<UserProfileReadRouteArgs> {
  UserProfileReadRoute({
    _i30.Key? key,
    String? userId,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         UserProfileReadRoute.name,
         args: UserProfileReadRouteArgs(key: key, userId: userId),
         rawQueryParams: {'userId': userId},
         initialChildren: children,
       );

  static const String name = 'UserProfileReadRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<UserProfileReadRouteArgs>(
        orElse: () =>
            UserProfileReadRouteArgs(userId: queryParams.optString('userId')),
      );
      return _i27.UserProfileReadScreen(key: args.key, userId: args.userId);
    },
  );
}

class UserProfileReadRouteArgs {
  const UserProfileReadRouteArgs({this.key, this.userId});

  final _i30.Key? key;

  final String? userId;

  @override
  String toString() {
    return 'UserProfileReadRouteArgs{key: $key, userId: $userId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UserProfileReadRouteArgs) return false;
    return key == other.key && userId == other.userId;
  }

  @override
  int get hashCode => key.hashCode ^ userId.hashCode;
}
