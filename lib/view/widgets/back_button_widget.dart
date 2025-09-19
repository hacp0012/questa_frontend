import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: IconButton(
        onPressed: () => context.back(),
        /*CRouter(context).goBack()*/
        icon: Icon(IconsaxPlusLinear.arrow_left),
      ),
    );
  }
}
