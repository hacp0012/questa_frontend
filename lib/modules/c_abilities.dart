// ignore_for_file: constant_identifier_names

import 'package:run_it/run_it.dart';

/// User responsabilities names.
enum CAbility { PEUT_PUBLIER_ENSEIGNEMENT, PEUT_PUBLIER_COMMUNIQUE, AUCUN }

enum CAbilityRole { EVANGELISTE, PREDICATEUR, BERGER, MEMBRE }

/// User abilities checker.
class CAbilities {
  CAbilities() {
    // Map? manager = UserMv().data;

    // abilities = manager['abilities'] ?? []; // null | ACTIVE | INVALIDATE
    // role = manager['role'] ?? 'MEMBRE'; // 'EVANGELISTE', 'PREDICATEUR', 'BERGER', 'MEMBRE'
  }

  List abilities = [];
  String? role;

  /// Check whether the current manager have abilities.
  /// return [true] if only one role provided match with the manager role.
  static bool onlyCan(List<CAbility> abilities) {
    CAbilities cAbilities = CAbilities();

    if (cAbilities.abilities.isEmpty) return false;

    bool able = false;

    for (CAbility ability in abilities) {
      if (cAbilities.abilities.contains(ability.name)) able = true;
    }

    return able;
  }

  static bool only(List<CAbilityRole> roles) {
    CAbilities cAbilities = CAbilities();

    if (cAbilities.role.isNull) return false;

    for (CAbilityRole role in roles) {
      if (cAbilities.role == role.name) return true;
    }

    return false;
  }

  static String abilityDetail(String role) {
    String detail = switch (role) {
      'PEUT_PUBLIER_ENSEIGNEMENT' => 'PEUT PUBLIER UN ENSEIGNEMENT',
      'PEUT_PUBLIER_COMMUNIQUE' => 'PEUT PUBLIER COMMUNIQUE',
      _ => 'AUCUN',
    };

    return detail;
  }
}
