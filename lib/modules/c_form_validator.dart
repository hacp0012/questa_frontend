class CFormValidator {
  List<Function> validators;

  CFormValidator(this.validators);

  String? validate(dynamic value) {
    for (Function validator in validators) {
      String? state = validator.call(value);

      if (state != null) {
        return state;
      }
    }

    return null;
  }

  // ---------------------------------------- :
  static Function required({String? message}) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return message ?? "Requis";
      } else {
        return null;
      }
    };
  }

  static Function numeric({String? message}) {
    return (String? value) {
      if (value != null && value.isNotEmpty) {
        return RegExp(r"[0-9\.]+").hasMatch(value) ? null : message ?? "Chaîne numérique requise";
      } else {
        return null;
      }
    };
  }

  static Function date({String? message}) {
    return (String? value) {
      if (value != null && value.isNotEmpty) {
        String newValue = value.replaceAll(RegExp(r'[\-/ ]'), '');

        return newValue.length == 8 ? null : message ?? "Date incomplete";
      } else {
        return null;
      }
    };
  }

  static Function max(int max, {String? message}) {
    return (String? value) {
      if (value != null && value.isNotEmpty) {
        return value.length <= max ? null : message ?? "Nombre des caractères doit être inférieur ou égale à $max";
      }

      return null;
    };
  }

  static Function min(int min, {String? message}) {
    return (String? value) {
      if (value != null && value.isNotEmpty) {
        return value.length >= min ? null : message ?? "Nombre des caractères doit être supérieur ou égale à $min";
      }

      return null;
    };
  }
}
