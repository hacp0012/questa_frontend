import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/widgets/c_modal_widget.dart';
import 'package:questa/view/widgets/c_toast.dart';
import 'package:run_it/run_it.dart';
import 'package:ui_value/ui_value.dart';

class PhotoViewerWidget extends StatefulWidget {
  const PhotoViewerWidget({super.key, this.urls, this.asset, this.title});
  final List<String>? urls;
  final String? asset;
  final String? title;

  @override
  State<PhotoViewerWidget> createState() => _PhotoViewerWidgetState();

  static void fullscreenModal(BuildContext context, {String? title, List<String>? urls, String? asset}) {
    if (asset.isNull && (urls?.isEmpty == true || urls.isNull)) {
      CToast(context).warning("Aucun contenu disponible".t);
      return;
    }

    CModalWidget.fullscreen(
      context: context,
      child: PhotoViewerWidget(
        urls: urls,
        asset: asset,
        title: title,
      ).animate().fadeIn().slideY(curve: Curves.easeIn, begin: 270, end: 0),
    ).show();
  }
}

class _PhotoViewerWidgetState extends State<PhotoViewerWidget> with UiValueMixin {
  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void initState() {
    super.initState();
    if (widget.asset != null && (widget.urls?.isEmpty == true || widget.urls.isNull)) {
      CToast(context).warning("Aucun contenu disponible".t);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // backgroundColor: context.theme.colorScheme.surface.withAlpha(136),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close_rounded)),
        title: widget.title?.t ?? "Image".t,
      ),

      // BODY.
      body: Builder(
        builder: (context) {
          if (widget.asset != null && (widget.urls?.isEmpty == true || widget.urls.isNull)) {
            return PhotoView(imageProvider: AssetImage(widget.asset!));
          }

          return PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: Image.network(
                  widget.urls![index],
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(IconsaxPlusLinear.gallery, size: 81).sized(height: 270, width: double.infinity);
                  },
                ).image,
                initialScale: 0.8,
                // heroAttributes: PhotoViewHeroAttributes(tag: galleryItems[index].id),
              );
            },
            itemCount: widget.urls?.length,
            loadingBuilder: (context, event) {
              return Center(child: SizedBox(width: 20.0, height: 20.0, child: CircularProgressIndicator()));
            },
            backgroundDecoration: BoxDecoration(),
            pageController: PageController(),
            onPageChanged: (index) => '',
          );
        },
      ),
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;
  // METHODS =================================================================================================================
}
