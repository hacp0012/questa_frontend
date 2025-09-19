// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:otp_text_field_v2/otp_field_style_v2.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/models/user_mv.dart';
import 'package:questa/modules/c_api.dart';
import 'package:questa/modules/c_misc_class.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/auto_routes/a_r_app.gr.dart';
import 'package:questa/view/screens/layouts/default_layout.dart';
import 'package:questa/view/widgets/back_button_widget.dart';
import 'package:questa/view/widgets/c_toast.dart';
import 'package:questa/view/widgets/spinner_widget.dart';
import 'package:run_it/run_it.dart';
import 'package:ui_value/ui_value.dart';

@RoutePage()
class AuthOtpLoginScreen extends StatefulWidget {
  const AuthOtpLoginScreen({
    super.key,
    @QueryParam() required this.phoneCode,
    @QueryParam() required this.phoneNumber,
    @QueryParam() this.isRegister = false,
    @QueryParam() this.otp,
  });

  static const String routeId = 'UGQ57HTRt';
  final String? phoneCode;
  final String? phoneNumber;
  final String? otp;
  final bool isRegister;

  @override
  State<AuthOtpLoginScreen> createState() => _AuthOtpLoginScreenState();
}

class _AuthOtpLoginScreenState extends State<AuthOtpLoginScreen> with UiValueMixin {
  late var isVerifying = uiValue(false);
  late var isRequestingOtp = uiValue(false);

  final OtpFieldControllerV2 otpFieldControllerV2 = OtpFieldControllerV2();
  String otp = '';

  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  @override
  void initState() {
    if (widget.phoneCode.isNull || widget.phoneNumber.isNull) {
      // CRouter(context).goBack();
    }

    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Scaffold(
        appBar: AppBar(title: "Vérification OTP".t, centerTitle: true, leading: BackButtonWidget()),

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(IconsaxPlusBroken.lock, size: 126, color: CConsts.COLOR_GREY_LIGHT),
              18.gap,
              Text(
                "Code de verification",
                style: context.theme.textTheme.titleLarge?.copyWith(fontFamily: CConsts.FONT_COMFORTAA),
              ),
              9.gap,
              Text(
                "Un code vous a été envoyé par SMS,\nveuillez le saisir ici. ${kDebugMode ? "[${widget.otp ?? ''}]" : ""}",
                style: context.theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),

              9.gap,
              OTPTextFieldV2(
                controller: otpFieldControllerV2,
                length: 4,
                width: 207,
                fieldStyle: FieldStyle.box,
                otpFieldStyle: OtpFieldStyle(focusBorderColor: context.theme.colorScheme.primary),
                fieldWidth: 9 * 5,
                keyboardType: TextInputType.number,
                inputFormatter: [CMiscClass.intInputFormater(length: 1)],
                outlineBorderRadius: CConsts.DEFAULT_RADIUS,
                onChanged: (value) => uiUpdate(() => otp = value),
              ).sized(width: 225),

              // ACTION.
              27.gap,
              FilledButton.tonalIcon(
                onPressed: run(() {
                  if (otp.length < 4) return null;
                  return isVerifying.value ? null : sendOTP;
                }),
                icon: isVerifying.value ? SpinnerWidget(size: 18) : Icon(IconsaxPlusLinear.send_1),
                label: "Vérifier le code".t,
                iconAlignment: IconAlignment.end,
                style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(18))),
                // style: TcButtonsLight.blackButtonTheme,
              ),
              18.gap,
              TextButton.icon(
                onPressed: isRequestingOtp.value ? null : resendOtp,
                icon: isRequestingOtp.value ? SpinnerWidget(size: 18) : Icon(IconsaxPlusLinear.mobile),
                label: "Rédemander le code".t,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;
  // METHODES ================================================================================================================
  void sendOTP() {
    if (otp.isEmpty || otp.length < 4) {
      CToast(context).warning("Le code n'est pas complet".t);
      return;
    }

    isVerifying.value = true;

    UserMv().login(
      widget.phoneCode!,
      widget.phoneNumber!,
      otp: otp,
      onSuccess: () {
        isVerifying.value = false;
        CToast(context).success("Bienvenue, vous êtes connecté avec succès".t);
        // CRouter(context).goTo(MainScreen.routeId);
        context.replaceRoute(MainScreenRoute());
      },
      onError: () {
        CToast(context).warning("Le code n'est pas valide".t);
        isVerifying.value = false;
      },
    );
  }

  void resendOtp() {
    isRequestingOtp.value = true;

    var req = CApi.request.post(
      '/public/auth/TuXaATu4X',
      data: {'phoneCode': widget.phoneCode, 'phoneNumber': widget.phoneNumber},
    );
    req.whenComplete(() => isRequestingOtp.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          CToast(context).success("Code renvoyé".t);
        } else {
          CToast(context).error("Une erreur est survenue".t);
        }
      },
      onError: (e) {
        // Logger().e(e);
        CToast(context).error("Impossible d'effectuer cette action.".t);
      },
    );
  }
}
