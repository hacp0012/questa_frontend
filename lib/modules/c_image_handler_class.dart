import 'package:questa/configs/c_consts.dart';

class CNetworkFilesClass {
  CNetworkFilesClass();

  static const int defaultScaleSize = 45;

  /// Get image http path by Public Id
  static String picture(String? pid, {int scale = defaultScaleSize, String defaultImage = 'logo'}) {
    var uri = Uri.parse("${CConsts.API_URL}/questa_v1/get/picture/$pid/$scale/$defaultImage");

    return uri.toString();
  }

  // Get audi file content
  static String file(String? pid) {
    var uri = Uri.parse("${CConsts.API_URL}/questa_v1/get/file/$pid");

    return uri.toString();
  }
}
