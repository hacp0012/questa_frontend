import 'package:encrypt_shared_preferences/provider.dart';
import 'package:questa/configs/c_consts.dart';

class CStore {
  static CStore? _instance;
  CStore._();
  static CStore get inst => _instance ??= CStore._();

  EncryptedSharedPreferences? _prefs;

  Future<void> initialize() async {
    await EncryptedSharedPreferences.initialize(CConsts.ENCRYPTION_KEY);
    _prefs = EncryptedSharedPreferences.getInstance();
  }

  // * LOGIN TOKEN * /
  // static String? get loginToken => inst._prefs!.getString(UserMv.loginTokenKey);

  // GETTERS /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  static EncryptedSharedPreferences get prefs => inst._prefs!;
}
