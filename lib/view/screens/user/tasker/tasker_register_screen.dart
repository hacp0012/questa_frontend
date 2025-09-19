import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:logger/logger.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/dsi/data_sync_interface.dart';
import 'package:questa/models/user_mv.dart';
import 'package:questa/modules/c_api.dart';
import 'package:questa/modules/c_form_validator.dart';
import 'package:questa/modules/c_navigate.dart';
import 'package:questa/modules/c_s_draft.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/screens/layouts/default_layout.dart';
import 'package:questa/view/theme/configs/tc_buttons.dart';
import 'package:questa/view/widgets/back_button_widget.dart';
import 'package:questa/view/widgets/c_dropdown_select_widget.dart';
import 'package:questa/view/widgets/c_modal_widget.dart';
import 'package:questa/view/widgets/c_toast.dart';
import 'package:questa/view/widgets/spinner_widget.dart';
import 'package:ui_value/ui_value.dart';

@RoutePage()
class TaskerRegisterScreen extends StatefulWidget {
  const TaskerRegisterScreen({super.key});
  static const String routeId = "772900701239530147027995998";

  @override
  State<TaskerRegisterScreen> createState() => _TaskerRegisterScreenState();
}

class _TaskerRegisterScreenState extends State<TaskerRegisterScreen> with UiValueMixin {
  late var isSHowingAppbarTitle = uiValue(false);
  late var isLoadingDetails = uiValue(false);
  late var isStartCreating = uiValue(false);

  ScrollController scrollController = ScrollController();
  CDraft draft = CDraft('011f9r791715724485632d097R4');

  var formKey = GlobalKey<FormState>();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactsController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  CDropdownController workDomanisController = CDropdownController();
  CDropdownController avenueController = CDropdownController();

  List townsList = [];
  List skillsList = [];

  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void initState() {
    addressController.text = draft.data('address') ?? '';
    descriptionController.text = draft.data('description') ?? '';
    contactsController.text = draft.data('contacts') ?? '';

    super.initState();
    scrollController.addListener(() {
      if (scrollController.offset < 126) {
        isSHowingAppbarTitle.value = scrollController.offset > 45;
      }
    });

    loadDetails();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: BackButtonWidget(),
          title: isSHowingAppbarTitle.value ? "Cree votre profile Professionel".t.animate().fadeIn() : null,
        ),

        // BODY.
        body: ListView(
          controller: scrollController,
          padding: EdgeInsets.symmetric(horizontal: 12),
          children: [
            72.gap,

            Text(
              "Cree votre profile \nProfessionel",
              style: context.theme.textTheme.titleLarge?.copyWith(fontFamily: CConsts.FONT_COMFORTAA),
            ),

            18.gap,
            Text(
              "Vous devez note que certains de vos informations du profile utilisateur seron melange avec "
              "celle de votre profile professionel pour completer votre profil.",
            ),

            Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  9.gap,
                  if (workDomanisController.singleValue.isNotEmpty) Text("Domains des competences").animate().fadeIn(),
                  CDropdownSelectWidget(
                    controller: workDomanisController,
                    leading: Icon(IconsaxPlusLinear.briefcase),
                    enabled: isLoadingDetails.value == false,
                    isMultiSelector: true,
                    placeholder: "Domains de competences",
                    title: "Domains de competences".t,
                    subtitle: "Choisissez des domaines de competences.".t,
                    showFilterField: true,
                    showDragHandle: false,
                    onChanged: (value, values) => uiUpdate(),
                    options: skillsList.map((e) {
                      return CDropdownOption(
                        value: e['id'],
                        label: "${e['name']}",
                        // subtitle: "${e['ville']['name']}, ${e['province']['name']}, ${e['pays']['name']}",
                        trailing: Icon(IconsaxPlusLinear.briefcase),
                      );
                    }).toList(),
                  ),

                  18.gap,
                  if (addressController.text.isNotEmpty) Text("Adresse").animate().fadeIn(),
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(hintText: "Adresse", prefixIcon: Icon(IconsaxPlusLinear.map_1)),
                    onChanged: (value) {
                      draft.keep('address', value);
                      uiUpdate();
                    },
                    minLines: 1,
                    maxLines: 3,
                    validator: CFormValidator([CFormValidator.required(), CFormValidator.min(3)]).validate,
                  ),
                  9.gap,
                  if (avenueController.singleValue.isNotEmpty) Text("Avenue").animate().fadeIn(),
                  CDropdownSelectWidget(
                    controller: avenueController,
                    leading: Icon(IconsaxPlusLinear.map),
                    enabled: isLoadingDetails.value == false,
                    placeholder: "Sélectionnez votre avenue",
                    title: "Avenue (professionnel)".t,
                    subtitle: "Choisissez l'avenue dans laquelle vous êtes.".t,
                    showFilterField: true,
                    showDragHandle: false,
                    onChanged: (value, values) => uiUpdate(),
                    options: townsList.map((e) {
                      return CDropdownOption(
                        value: e['avenue']['id'].toString(),
                        label: "${e['avenue']['name']}",
                        subtitle: "${e['ville']['name']}, ${e['province']['name']}, ${e['pays']['name']}",
                      );
                    }).toList(),
                  ),
                  9.gap,
                  if (contactsController.text.isNotEmpty) Text("Contacts").animate().fadeIn(),
                  TextFormField(
                    controller: contactsController,
                    decoration: InputDecoration(
                      hintText: "Plus des contacts",
                      helperText: "Telephones ou emails, separer par des (virgules).",
                      prefixIcon: Icon(IconsaxPlusLinear.personalcard),
                    ),
                    onChanged: (value) {
                      draft.keep('contacts', value);
                      uiUpdate();
                    },
                    minLines: 1,
                    maxLines: 3,
                    validator: CFormValidator([CFormValidator.required(), CFormValidator.min(3)]).validate,
                  ),

                  18.gap,
                  if (descriptionController.text.isNotEmpty) Text("Descriptions").animate().fadeIn(),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(hintText: "Descriptions"),
                    onChanged: (value) {
                      draft.keep('description', value);
                      uiUpdate();
                    },
                    minLines: 1,
                    maxLines: 18,
                    validator: CFormValidator([CFormValidator.required(), CFormValidator.min(9)]).validate,
                  ),
                ],
              ),
            ),

            18.gap,
            Icon(
              IconsaxPlusLinear.info_circle,
            ).stickThis(Text("Apres vous pouvez definir plus tard vos portes folios a votre souhait").expanded()),

            18.gap,
            Text("Creer"),
            Text("En continuen vous etes daccord avec la politique Questa sur les profile professionnel.").muted,
            Row(
              children: [
                FilledButton.tonalIcon(
                  style: TcButtonsLight.blackButtonTheme,
                  onPressed: isStartCreating.value ? null : _openAlertDialog,
                  icon: isStartCreating.value ? SpinnerWidget(size: 18) : null,
                  label: Text("Cree le profile"),
                ),
              ],
            ),

            // SPCER.
            81.gap,
          ],
        ),
      ),
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;
  // METHODS =================================================================================================================
  void loadDetails() {
    isLoadingDetails.value = true;

    Map<String, dynamic> params = {};
    var req = CApi.request.get('/user/tasker/rlyBL1Zd7', queryParameters: params);
    req.whenComplete(() => isLoadingDetails.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          townsList = res.data['data']['avenues'] ?? [];
          skillsList = res.data['data']['skills'] ?? [];
        } else {
          CToast(context).warning("Impossible de charger les meta donnees.".t);
        }
      },
      onError: (e) {
        // Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }

  void startCreating() {
    isStartCreating.value = true;

    Map<String, dynamic> params = {
      'skillIds': workDomanisController.values,
      'avenueId': avenueController.singleValue,
      'addressRef': addressController.text,
      'description': descriptionController.text,
      'contacts': contactsController.text,
    };
    var req = CApi.request.post('/user/tasker/5CVlNFotj', data: params);
    req.whenComplete(() => isStartCreating.value = false);
    req.then(
      (res) async {
        Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          CToast(context, 4.seconds).success("Votre profile professionel cree avec succes.".t);
          Dsi.of<UserMv>(context)?.load(onFinish: () => Dsi.call('011f9r791715724485632d097R4'));

          draft.free();

          await Future.delayed(1500.milliseconds);
          CRouter(context).goBack();
        } else {
          CToast(context).warning("Une erreur est survenu lors de traitement des donnes.".t);
        }
      },
      onError: (e) {
        Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }

  void _openAlertDialog() {
    if ((formKey.currentState?.validate() ?? false) &&
        avenueController.singleValue.isNotEmpty &&
        workDomanisController.values.isNotEmpty) {
      CModalWidget(
        context,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Attention", style: context.theme.textTheme.titleLarge),
            9.gap,
            Text("Vous avez bien verifier vos entres."),
            9.gap,
            Text("Par apres vous serez demande, d'evoyer vos identites a Questa."),
            18.gap,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: "Annuler".t),
                9.gap,
                FilledButton.tonalIcon(
                  style: TcButtonsLight.blackButtonTheme,
                  onPressed: () {
                    Navigator.pop(context);
                    startCreating();
                  },
                  icon: Icon(Icons.check),
                  label: "OK, j'accepte".t,
                ),
              ],
            ),
          ],
        ).withPadding(all: 12),
      ).show();
    } else {
      CToast(context, 2.seconds).warning("Certains champs sont obligatoir.".t);
    }
  }
}
