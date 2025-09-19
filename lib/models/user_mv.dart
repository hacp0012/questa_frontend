import 'dart:async';
import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:questa/dsi/data_sync_interface.dart';
import 'package:questa/modules/c_api.dart';
import 'package:questa/modules/c_store.dart';
import 'package:questa/view/auto_routes/a_r_auth_reevaluate.dart';
import 'package:run_it/run_it.dart';
import 'package:web/web.dart';

class UserMv extends DsiChangeNotifier {
  String userDataKey = '7BlU4jT2HCcXC8F70d';

  Map get data => jsonDecode(CStore.prefs.getString(userDataKey) ?? '{}');
  set data(Map p0) {
    CStore.prefs.setString(userDataKey, jsonEncode(p0));
    notifyListeners();
  }

  Future<void> load({VoidCallback? onFinish}) async {
    var res = CApi.request.get('/user/gVDdfKI4P');
    res.then((res) {
      // Logger().t(res.data);
      if (res.data is Map && res.data['success'] == true) {
        CStore.prefs.setString(userDataKey, jsonEncode(res.data['data']));
        onFinish?.call();
        notifyListeners();
      } else if (res.data == 'Unauthenticated') {
        //
      }
    }, onError: (e) {});
  }

  void login(String phoneCode, String phoneNumber, {String? otp, Function? onSuccess, Function? onError}) async {
    String deviceInfo;
    DeviceInfoPlugin deviceInfos = DeviceInfoPlugin();
    if (kIsWeb) {
      // deviceInfo = "Navigateur Web";
      deviceInfo = window.navigator.userAgent;
    } else {
      var android = await deviceInfos.androidInfo;
      deviceInfo = "${android.product} ${android.device} (${android.brand})";
    }

    var req = CApi.request.post(
      '/public/auth/yTpYXAmmq',
      data: {'otp': otp, 'phoneCode': phoneCode, 'phoneNumber': phoneNumber, 'device': deviceInfo},
    );
    req.then(
      (res) async {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          String token = res.data['token'];
          CApi.loginToken = token;

          await load(onFinish: () => onSuccess?.call());

          // onSuccess?.call();
        } else {
          onError?.call();
        }
      },
      onError: (e) {
        Logger().e(e);
        onError?.call();
      },
    );
  }

  static bool get isLoggedin => CApi.loginToken.isNotNull;

  void updateLastUseForLoginToken({VoidCallback? onFinish, VoidCallback? onError, VoidCallback? unAuthenticated}) {
    if (!isLoggedin) {
      onError?.call();
      return;
    }

    Map<String, dynamic> params = {'token': CApi.loginToken};
    var req = CApi.request.post('/auth/public/7kwr5FoME', data: params);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          onFinish?.call();
        } else if (res.data == 'Unauthenticated.') {
          unAuthenticated?.call();
        }
      },
      onError: (e) {
        // Logger().e(e);
        onError?.call();
      },
    );
  }

  // * PING LOGIN * //////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> pingLogin() async {
    if (CApi.loginToken != null) {
      var req = CApi.request.get('/auth/ping');
      req.then((res) {
        if (res.data is Map && res.data['message'] == 'Unauthenticated.') {
          cleanDatas();
          Dsi.model<ARAuthReevaluate>()!.reevaluate();
        }
      }, onError: (e) {});
    }
  }

  // ! LOGOUT ! //////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void logout({Function? onSuccess, Function? onError}) {
    String? loginToken = CApi.loginToken;

    var req = CApi.request.delete('/auth/gmz7ufNNt', queryParameters: {'token': loginToken});
    req.then(
      (res) {
        if (res.data is Map && res.data['success'] == true) {
          cleanDatas();
          onSuccess?.call();
        } else {
          onError?.call();
        }
      },
      onError: (e) {
        onError?.call();
      },
    );
  }

  // CLEANER. ----------------------------------------------------------------------------------------------------------------
  void cleanDatas() async {
    // CDraft.cleanAll();
    // CStore.prefs.remove(loginTokenKey);
    // CStore.prefs.remove(loginSessionKey);
    // CStore.prefs.remove(managerDataKey);
    await CStore.prefs.clear();
  }
}
