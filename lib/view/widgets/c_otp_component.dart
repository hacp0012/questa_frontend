import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:otp_text_field_v2/otp_field_style_v2.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/modules/c_misc_class.dart';

class COtpComponent extends StatefulWidget {
  const COtpComponent({
    super.key,
    required this.phoneCode,
    required this.phoneNumber,

    // Callbacks :
    this.onFailed,
    this.onStartFetching,
    this.onSuccess,
  });

  final String phoneNumber;
  final String phoneCode;

  final void Function(String opt, String phone)? onStartFetching;
  final void Function(Map data)? onSuccess;
  final void Function()? onFailed;

  @override
  State<COtpComponent> createState() => _COtpComponentState();
}

class _COtpComponentState extends State<COtpComponent> {
  final GlobalKey globalKey = GlobalKey();
  final OtpFieldControllerV2 otpFieldControllerV2 = OtpFieldControllerV2();

  String otpState = 'otp';

  @override
  void setState(VoidCallback fn) => super.setState(fn);

  @override
  Widget build(BuildContext context) {
    switch (otpState) {
      case 'loading':
        return SizedBox(
          width: 9 * 27,
          child: LinearProgressIndicator(borderRadius: BorderRadius.circular(5.4)),
        ).animate().fadeIn(duration: 900.ms).slideY(begin: -1.5, curve: Curves.easeInOut, duration: 540.ms);

      default:
        return Animate(
          effects: [
            FadeEffect(duration: 500.ms),
            const SlideEffect(curve: Curves.easeInOut, begin: Offset(0.0, 0.5)),
          ],

          child: OTPTextFieldV2(
            controller: otpFieldControllerV2,
            length: 4,
            width: 207,
            fieldStyle: FieldStyle.box,
            otpFieldStyle: CMiscClass.whenBrightnessOf<OtpFieldStyle>(
              context,
              dark: OtpFieldStyle(
                enabledBorderColor: Colors.white,
                // backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
            fieldWidth: 9 * 5,
            keyboardType: TextInputType.number,
            outlineBorderRadius: CConsts.DEFAULT_RADIUS / 2,
            onCompleted: fintching,
          ),
        );
    }
  }

  // --- FUNCTIONS -->
  // void detectOtpSms() => COtpHandlerClass.readFromSms.then((code) {}, onError: (error) {});

  void fintching(String otpCode) {
    setState(() {
      widget.onStartFetching?.call(otpCode, '');
      otpFieldControllerV2.clear();
      otpState = 'loading';
    });

    // Fetching :
    // COtpHandlerClass.validate(
    //   otpCode,
    //   onSuccess: (data) {
    //     setState(() => otpState = 'finish');
    //     widget.onSuccess?.call(data);
    //   },
    //   onFailed: () {
    //     setState(() => otpState = 'finish');
    //     widget.onFailed?.call();
    //   },
    // );
  }
}
