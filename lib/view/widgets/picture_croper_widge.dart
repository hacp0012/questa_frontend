import 'dart:ui';

import 'package:crop_image/crop_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/widgets/c_modal_widget.dart';
import 'package:questa/view/widgets/spinner_widget.dart';

/// 6 / 4 : paysage
/// 1 : square
class PictureCroperWidge extends StatefulWidget {
  const PictureCroperWidge({super.key, this.aspectRatio, required this.file, required this.onCrop});
  final Uint8List file;
  final double? aspectRatio;
  final void Function(Uint8List? picture) onCrop;

  @override
  State<PictureCroperWidge> createState() => _PictureCroperWidgeState();

  static void showOnModel(
    BuildContext context, {
    required Uint8List file,
    double? aspectRatio,
    required void Function(Uint8List? picture) onCrop,
  }) {
    CModalWidget.fullscreen(
      context: context,
      child: PictureCroperWidge(file: file, aspectRatio: aspectRatio, onCrop: onCrop),
    ).show();
  }
}

class _PictureCroperWidgeState extends State<PictureCroperWidge> {
  bool isCropping = false;
  late final CropController cropController;

  @override
  void initState() {
    cropController = CropController(aspectRatio: widget.aspectRatio);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close_rounded)),
        actions: [
          FilledButton.icon(
            onPressed: () async {
              setState(() => isCropping = true);
              UiImageProvider ui = UiImageProvider(await cropController.croppedBitmap());
              var data = (await ui.image.toByteData(format: ImageByteFormat.png))?.buffer.asUint8List();
              Navigator.pop(context);
              widget.onCrop(data);
            },
            icon: isCropping ? SpinnerWidget(size: 14) : null,
            label: "Rogner".t,
          ),
        ],
      ),
      body: CropImage(controller: cropController, image: Image.memory(widget.file)),

      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton.filledTonal(onPressed: () => cropController.rotateLeft(), icon: Icon(IconsaxPlusLinear.rotate_left)),

          9.gap,
          "Rotation".t,
          9.gap,

          IconButton.filledTonal(onPressed: () => cropController.rotateRight(), icon: Icon(IconsaxPlusLinear.rotate_right)),
        ],
      ).withPadding(vertical: 9),
    );
  }
}
