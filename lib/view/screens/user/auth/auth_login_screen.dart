import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:logger/logger.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/modules/c_api.dart';
import 'package:questa/modules/c_misc_class.dart';
import 'package:questa/modules/c_navigate.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/auto_routes/a_r_app.gr.dart';
import 'package:questa/view/screens/layouts/default_layout.dart';
import 'package:questa/view/theme/configs/tc_buttons.dart';
import 'package:questa/view/widgets/c_modal_widget.dart';
import 'package:questa/view/widgets/c_toast.dart';
import 'package:questa/view/widgets/divider_widget.dart';
import 'package:questa/view/widgets/spinner_widget.dart';
import 'package:run_it/run_it.dart';
import 'package:ui_value/ui_value.dart';

@RoutePage()
class AuthLoginScreen extends StatefulWidget {
  const AuthLoginScreen({super.key, this.onLogin});
  static const String routeId = "p196Ve11827neL02hz";
  final Function(bool success)? onLogin;

  @override
  State<AuthLoginScreen> createState() => _AuthLoginScreenState();
}

class _AuthLoginScreenState extends State<AuthLoginScreen> with UiValueMixin {
  late var isChecking = uiValue(false);

  TextEditingController phoneCode = TextEditingController(text: '243');
  TextEditingController phoneNumber = TextEditingController();

  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
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
        // BODY.
        body: Center(
          child: Column(
            children: [
              Expanded(
                // height: 270,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('lib/assets/icons/logo_q_primary_color.png', height: 126),
                      9.gap,
                      // Image.asset('lib/assets/icons/logo_text_secondary_color.png', height: 36),
                      Text(
                        "Questa",
                        style: Theme.of(
                          context,
                        ).textTheme.headlineLarge?.copyWith(fontFamily: CConsts.FONT_COMFORTAA, fontWeight: FontWeight.bold),
                      ),
                      "Profiltez des avantage | Rendez-vous service".t.muted,
                    ],
                  ),
                ),
              ),

              // FIELDS.
              Container(
                padding: EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: CConsts.LIGHT_COLOR,
                  borderRadius: BorderRadiusGeometry.vertical(top: Radius.elliptical(207, 18)),
                ),
                child: Column(
                  // padding: EdgeInsets.symmetric(horizontal: 18),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    18.gap,
                    Text(
                      "Connecter vous",
                      style: context.theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    9.gap,
                    Text(
                      "Veuillez vous connecter pour continuer",
                      textAlign: TextAlign.center,
                      style: context.theme.textTheme.titleMedium,
                    ).muted,

                    // FIELDS
                    18.gap,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: phoneCode,
                          readOnly: isChecking.value,
                          decoration: InputDecoration(hintText: "Code", prefixIcon: Icon(IconsaxPlusLinear.call)),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [CMiscClass.intInputFormater(length: 3)],
                        ).expanded(flex: 2),
                        9.gap,
                        TextField(
                          controller: phoneNumber,
                          readOnly: isChecking.value,
                          decoration: InputDecoration(hintText: "Telephone", prefixIcon: Icon(IconsaxPlusLinear.arrow_right)),
                          inputFormatters: [CMiscClass.intInputFormater(length: 9)],
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (value) => checkPhoneNumber(),
                        ).expanded(flex: 3),
                      ],
                    ),

                    // Row(
                    //   children: [
                    //     const Spacer(),
                    //     TextButton(
                    //       onPressed: () => CRouter(context).goTo(AuthForgotePasswordScreen.routeId),
                    //       child: Text("Mot de passe oublié ?"),
                    //     ),
                    //   ],
                    // ),
                    27.gap,
                    Row(
                      children: [
                        FilledButton.tonalIcon(
                          onPressed: isChecking.value ? null : checkPhoneNumber,
                          label: "Se connecter".t,
                          icon: isChecking.value ? SpinnerWidget(size: 19) : Icon(IconsaxPlusLinear.login),
                          style: TcButtonsLight.blackButtonTheme.copyWith(
                            padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 18)),
                          ),
                        ).expanded(),
                      ],
                    ),

                    9.gap,
                    DividerWidget(child: Text("Ou se connecter avec").muted),
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

                    9.gap,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Vous n'avez pas de compte ?").muted,
                        TextButton(
                          onPressed: () => CRouter(context).goTo(AuthRegisterRoute()),
                          child: Text("Créer un compte"),
                        ),
                      ],
                    ),

                    // SPACER.
                    18.gap,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;
  // METHODS =================================================================================================================
  void checkPhoneNumber() {
    if (phoneCode.text.isEmpty || phoneNumber.text.isEmpty || phoneNumber.text.length < 9) {
      CToast(context).warning("Veiller complete tout les champs comme il faut.".t);
      return;
    }

    isChecking.value = true;

    Map<String, dynamic> params = {'phoneCode': phoneCode.text, 'phoneNumber': phoneNumber.text};
    var req = CApi.request.post('/public/auth/6xppUs5vP', data: params);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['state'] == true) {
          tryLogin();
        } else {
          isChecking.value = false;
          CModalWidget(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Attention", style: context.theme.textTheme.titleLarge),
                9.gap,
                Text("Votre numero de telephone n'est pas reconnu comme un numero enregistre sur Questa."),
                18.gap,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => Navigator.pop(context), child: "Non".t),
                    9.gap,
                    FilledButton.tonalIcon(
                      onPressed: () {
                        CRouter(context).goTo(AuthRegisterRoute(phoneCode: phoneCode.text, phoneNumber: phoneNumber.text));
                        Navigator.pop(context);
                        phoneNumber.clear();
                      },
                      label: "Crer un compt".t,
                      iconAlignment: IconAlignment.end,
                      icon: Icon(IconsaxPlusLinear.arrow_right),
                    ),
                  ],
                ),
              ],
            ).withPadding(all: 12).constrained(maxWidth: 360),
          ).show();
        }
      },
      onError: (e) {
        Logger().e(e);
        CToast(context).error("Probleme de conxion.".t);
      },
    );
  }

  void tryLogin() {
    Map<String, dynamic> params = {'phoneCode': phoneCode.text, 'phoneNumber': phoneNumber.text};
    var req = CApi.request.post("/public/auth/9fjH0I0vT", data: params);
    req.whenComplete(() => isChecking.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          // CRouter(context).goTo(
          //   AuthOtpLoginScreen.routeId,
          //   queryParameters: {
          //     'phone_code': phoneCode.text,
          //     'phone_number': phoneNumber.text,
          //     'otp': run(() {
          //       if (kDebugMode) return res.data['otp']['otp'];
          //       return null;
          //     }),
          //   },
          // );
          context.router.push(
            AuthOtpLoginRoute(
              phoneCode: phoneCode.text,
              phoneNumber: phoneNumber.text,
              otp: run(() {
                if (kDebugMode) return res.data['otp']['otp'];
                return null;
              }),
            ),
          );
          phoneNumber.clear();
        } else {
          CToast(context).warning("La requette a echoue".t);
        }
      },
      onError: (e) {
        // Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }

  void logginViaGoogle() {}
}
