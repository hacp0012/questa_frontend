import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:logger/logger.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/modules/c_api.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/theme/configs/tc_buttons.dart';
import 'package:questa/view/widgets/c_toast.dart';
import 'package:questa/view/widgets/spinner_widget.dart';
import 'package:ui_value/ui_value.dart';

class SkillReaderWidget extends StatefulWidget {
  const SkillReaderWidget({super.key, required this.skillId});
  final String skillId;

  @override
  State<SkillReaderWidget> createState() => _SkillReaderWidgetState();

  static void onBottomSheet(BuildContext context, {required skillId}) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SkillReaderWidget(skillId: skillId);
      },
    );
  }
}

class _SkillReaderWidgetState extends State<SkillReaderWidget> with UiValueMixin {
  late var isLoading = uiValue(false);

  // String? _picture;
  Map _skill = {};
  List _topics = [];
  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void initState() {
    super.initState();
    loadDetails();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 147,
              child: Center(child: Icon(IconsaxPlusBroken.briefcase, size: 81, color: CConsts.COLOR_BLUE_LIGHT)),
            ),
            Builder(
              builder: (context) {
                if (isLoading.value) {
                  return SizedBox(
                    height: 180,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [SpinnerWidget(size: 27), 9.gap, "Chargement".t.muted],
                      ),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${_skill['name'] ?? 'Sans nom'}",
                      style: context.theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (_skill['short_description'] != null)
                      Text("${_skill['short_description']}", style: context.theme.textTheme.labelMedium),
                    if (_skill['description'] != null)
                      Text(
                        "${_skill['description']}",
                        style: context.theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    12.gap,
                    "Sujet".t.muted,
                    6.gap,
                    Wrap(spacing: 0, runSpacing: 0, children: [..._topics.map((e) => Chip(label: "$e".t))]),
                  ],
                ).animate().fadeIn();
              },
            ),

            // ACTIONS.
            18.gap,
            Row(
              children: [
                FilledButton.tonalIcon(
                  style: TcButtonsLight.blackButtonTheme,
                  onPressed: () => Navigator.pop(context),
                  label: "FERMER".t,
                ).expanded(),
              ],
            ),
            18.gap,
          ],
        ),
      ),
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;
  // METHODS =================================================================================================================
  void loadDetails() {
    isLoading.value = true;

    Map<String, dynamic> params = {'skillId': widget.skillId};
    var req = CApi.request.get('/app/QyM1SLLhA', queryParameters: params);
    req.whenComplete(() => isLoading.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          // _picture = res.data['data']?['picture'];
          _skill = res.data['data']?['skill'] ?? {};
          _topics = ((res.data['data']?['skill']?['topics'] ?? []) as String).split(',');
        } else {
          CToast(context).warning("Impossible de charger les infos.".t);
          Navigator.pop(context);
        }
      },
      onError: (e) {
        Logger().e(e);
        CToast(context).error("".t);
      },
    );
  }
}
