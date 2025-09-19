import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:logger/logger.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/modules/c_api.dart';
import 'package:questa/modules/c_form_validator.dart';
import 'package:questa/modules/c_misc_class.dart';
import 'package:questa/modules/c_navigate.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/auto_routes/a_r_app.gr.dart';
import 'package:questa/view/screens/layouts/default_layout.dart';
import 'package:questa/view/theme/configs/tc_buttons.dart';
import 'package:questa/view/widgets/c_dropdown_select_widget.dart';
import 'package:questa/view/widgets/c_toast.dart';
import 'package:questa/view/widgets/divider_widget.dart';
import 'package:questa/view/widgets/spinner_widget.dart';
import 'package:ui_value/ui_value.dart';

@RoutePage()
class AuthRegisterScreen extends StatefulWidget {
  const AuthRegisterScreen({super.key, @QueryParam() this.phoneCode, @QueryParam() this.phoneNumber});
  static const String routeId = "KTGGPQxIMQLsWZsNtz";
  final String? phoneCode;
  final String? phoneNumber;

  @override
  State<AuthRegisterScreen> createState() => _AuthRegisterScreenState();
}

class _AuthRegisterScreenState extends State<AuthRegisterScreen> with UiValueMixin {
  late var isAcceptPolicy = uiValue(true);
  late var isRegistring = uiValue(false);
  late var isLoadingDetails = uiValue(false);

  var formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phoneCode = TextEditingController(text: '243');
  TextEditingController phoneNumber = TextEditingController();
  CDropdownController avenuesController = CDropdownController();

  List townsList = [];

  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void initState() {
    phoneCode = TextEditingController(text: widget.phoneCode ?? '243');
    phoneNumber = TextEditingController(text: widget.phoneNumber ?? '');

    super.initState();
    loadDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      navBarColor: CConsts.LIGHT_COLOR,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton.filledTonal(
            style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(CConsts.LIGHT_COLOR)),
            onPressed: () => context.back(), // CRouter(context).goBack(),
            icon: Icon(IconsaxPlusLinear.arrow_left),
          ),
          backgroundColor: Colors.transparent,
        ),

        // BODY.
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12),
          children: [
            18.gap,
            Image.asset('lib/assets/images/register_wellcome.png'),

            // FIELDS.
            Form(
              key: formKey,
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Créer un compte",
                    style: context.theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  9.gap,
                  Text(
                    "Questa vous souhaite la bienvenue",
                    textAlign: TextAlign.center,
                    style: context.theme.textTheme.titleMedium,
                  ).muted,

                  // FIELDS
                  27.gap,
                  TextFormField(
                    controller: name,
                    decoration: InputDecoration(hintText: "Nom", prefixIcon: Icon(IconsaxPlusLinear.user)),
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    validator: CFormValidator([CFormValidator.required()]).validate,
                  ),
                  9.gap,
                  TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      hint: "Email".t.stickThis("Non obligatoire".t.muted),
                      prefixIcon: Icon(IconsaxPlusLinear.paperclip),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  9.gap,
                  TextFormField(
                    controller: address,
                    minLines: 1,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Adresse",
                      helperText: "Entrez la référence de votre adresse. Ex. Ibanda Av Sai tout près de chez Shaba.",
                      helperMaxLines: 2,
                      prefixIcon: Icon(IconsaxPlusLinear.map_1),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.streetAddress,
                    textInputAction: TextInputAction.next,
                    validator: CFormValidator([CFormValidator.required()]).validate,
                  ),
                  9.gap,
                  CDropdownSelectWidget(
                    controller: avenuesController,
                    leading: Icon(IconsaxPlusLinear.map),
                    enabled: isLoadingDetails.value == false,
                    placeholder: "Sélectionnez votre avenue",
                    title: "Avenue".t,
                    subtitle: "Choisissez l'avenue dans laquelle vous êtes.".t,
                    showFilterField: true,
                    showDragHandle: false,
                    options: townsList.map((e) {
                      return CDropdownOption(
                        value: e['avenue']['id'].toString(),
                        label: "${e['avenue']['name']}",
                        subtitle: "${e['ville']['name']}, ${e['province']['name']}, ${e['pays']['name']}",
                      );
                    }).toList(),
                  ),
                  18.gap,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: phoneCode,
                        readOnly: isRegistring.value,
                        decoration: InputDecoration(hintText: "Code", prefixIcon: Icon(IconsaxPlusLinear.call)),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [CMiscClass.intInputFormater(length: 3)],
                        validator: CFormValidator([CFormValidator.required()]).validate,
                      ).expanded(flex: 2),
                      9.gap,
                      TextFormField(
                        controller: phoneNumber,
                        readOnly: isRegistring.value,
                        decoration: InputDecoration(hintText: "Telephone", prefixIcon: Icon(IconsaxPlusLinear.arrow_right)),
                        inputFormatters: [CMiscClass.intInputFormater(length: 9)],
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.send,
                        validator: CFormValidator([CFormValidator.required(), CFormValidator.min(9)]).validate,
                      ).expanded(flex: 3),
                    ],
                  ),
                  18.gap,
                  Row(
                    children: [
                      Checkbox(value: isAcceptPolicy.value, onChanged: (state) => isAcceptPolicy.value = state ?? false),
                      9.gap,
                      "En continuant vous acceptez les conditions et termes (ici)".t.muted
                          .cursorClick(onClick: () => CRouter(context).goTo(PrivacyPolicyRoute()))
                          .expanded(),
                    ],
                  ),
                  9.gap,
                  Row(
                    children: [
                      FilledButton.tonalIcon(
                        onPressed: isAcceptPolicy.value == false || isRegistring.value ? null : startRegistring,
                        label: "S'enregistrer".t,
                        icon: isRegistring.value ? SpinnerWidget(size: 18) : Icon(IconsaxPlusLinear.save_2),
                        style: isAcceptPolicy.value == false || isRegistring.value
                            ? null
                            : TcButtonsLight.blackButtonTheme.copyWith(
                                padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 9)),
                              ),
                      ).expanded(),
                    ],
                  ),

                  18.gap,
                  DividerWidget(alignment: TextAlign.center, child: Text("Ou s'enregistrer avec").muted),
                  9.gap,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {},
                        label: "Google".t.bold,
                        icon: Image.asset('lib/assets/images/google_logo.png', height: 18),
                        style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(18))),
                      ),
                    ],
                  ),

                  18.gap,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Vous avez déjà un compte ?").muted,
                      TextButton(
                        onPressed: () {
                          CRouter(context).goTo(AuthLoginRoute());
                        },
                        child: Text("Connectez-vous"),
                      ),
                    ],
                  ),

                  // SPACER.
                  27.gap,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;
  // METHODS =================================================================================================================
  void startRegistring() {
    if ((formKey.currentState?.validate() ?? false) && avenuesController.singleValue.isNotEmpty) {
      isRegistring.value = true;

      Map<String, dynamic> params = {
        'name': name.text,
        'email': email.text,
        'avenueId': avenuesController.singleValue,
        'address': address.text,
        'phoneCode': phoneCode.text,
        'phoneNumber': phoneNumber.text,
      };

      var req = CApi.request.post('/public/register/tl03x3XcW', data: params);
      req.whenComplete(() => isRegistring.value = false);
      req.then(
        (res) {
          Logger().t(res.data);
          if (res.data is Map && res.data['success'] == true) {
            CToast(context).success("Vous êtes enregistré avec succès.".t);
            // CRouter(context).goBack();
            context.back();
          } else {
            CToast(context).warning("Impossible de réaliser cette action pour l'instant.".t);
          }
        },
        onError: (e) {
          // Logger().e(e);
          CToast(context).error("Probleme de connexion.".t);
        },
      );
    } else {
      CToast(context).warning("Veuillez compléter tous les champs comme il faut.".t);
    }
  }

  void loadDetails() {
    isLoadingDetails.value = true;

    Map<String, dynamic> params = {};
    var req = CApi.request.get('/public/register/8X4UTS9V8', queryParameters: params);
    req.whenComplete(() => isLoadingDetails.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          townsList = res.data['regions'] ?? [];
        } else {
          CToast(context).warning("Impossible d'avoir la liste des villes.".t);
        }
      },
      onError: (e) {
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }

  void registerWithGoogle() {}
}
