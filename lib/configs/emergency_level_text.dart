class EmergencyLevelText {
  EmergencyLevelText(this._key);
  String? _key;

  // 'IMMEDIATE', 'TODAY', 'SHORT_TERM', 'FLEXIBLE'
  String imediate = "Imediat";
  String toDay = "Aujourd'huit";
  String shortTerm = "Court terme";
  String flexible = "Flexible";

  String get text {
    switch (_key) {
      case 'IMMEDIATE':
        return imediate;
      case 'TODAY':
        return toDay;
      case 'SHORT_TERM':
        return shortTerm;
      case 'FLEXIBLE':
        return flexible;
      default:
        return "N/A";
    }
  }

  String? get value => _key;
}
