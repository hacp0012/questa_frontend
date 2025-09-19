import 'dart:convert';

import 'package:questa/modules/c_store.dart';

/// Store end manage draft data.
class CDraft {
  CDraft(this.id) {
    String? rawData = CStore.prefs.getString(_storkey);

    rawData ??= '{}';

    _draftBase = jsonDecode(rawData) as Map;

    // For OD :
    Map? idDraft = _draftBase[id];

    if (idDraft == null) {
      _draftBase[id] = {};

      idDraft = {};

      CStore.prefs.setString(_storkey, jsonEncode(_draftBase));
    }

    draft = idDraft;
  }

  // DATAS ------------------------------------------------------------------------------------------------------------------>
  final String id;

  final String _storkey = "9hKUVZM31pTP6HG1kbY3pe86guXQs0Zubyp5";

  Map _draftBase = {};

  Map draft = {};

  // METHODS ---------------------------------------------------------------------------------------------------------------->
  /// Get the drafted data.
  String? data(String key) => draft[key];

  /// Keen (conserve) data.
  void keep(String key, String text) {
    draft[key] = text;

    _draftBase[id] = draft;

    CStore.prefs.setString(_storkey, jsonEncode(_draftBase));
  }

  /// Free this instance.
  /// It will remove all stored data on this instance, referenced by it [id].
  void free() {
    _draftBase.remove(id);

    CStore.prefs.setString(_storkey, jsonEncode(_draftBase));
  }

  /// Clear all stored Drafts.
  static void cleanAll() => CStore.prefs.remove('9hKUVZM31pTP6HG1kbY3pe86guXQs0Zubyp5');
}
