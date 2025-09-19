import 'package:auto_route/annotations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:logger/logger.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/modules/c_api.dart';
import 'package:questa/modules/c_image_handler_class.dart';
import 'package:questa/modules/c_navigate.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/screens/layouts/default_layout.dart';
import 'package:questa/view/widgets/back_button_widget.dart';
import 'package:questa/view/widgets/c_toast.dart';
import 'package:questa/view/widgets/commenter_widget.dart';
import 'package:questa/view/widgets/photo_viewer_widget.dart';
import 'package:questa/view/widgets/skill_reader_widget.dart';
import 'package:questa/view/widgets/spinner_widget.dart';
import 'package:ui_value/ui_value.dart';

@RoutePage()
class TaskerPortfolioReadScreen extends StatefulWidget {
  const TaskerPortfolioReadScreen({super.key, @QueryParam() this.portfolioId});
  final String? portfolioId;

  @override
  State<TaskerPortfolioReadScreen> createState() => _TaskerPortfolioReadScreenState();
}

class _TaskerPortfolioReadScreenState extends State<TaskerPortfolioReadScreen> with UiValueMixin {
  late var isLoading = uiValue(false);

  var carousselOption = CarouselOptions(
    height: 306,
    aspectRatio: 16 / 9,
    viewportFraction: .8,
    initialPage: 0,
    enableInfiniteScroll: true,
    // enlargeStrategy: CenterPageEnlargeStrategy.height,
    reverse: false,
    autoPlay: true,
    autoPlayInterval: Duration(seconds: 6),
    autoPlayAnimationDuration: Duration(milliseconds: 801),
    autoPlayCurve: Curves.fastOutSlowIn,
    enlargeCenterPage: true,
    enlargeFactor: 0.0,
    onPageChanged: (index, reason) => '',
    scrollDirection: Axis.horizontal,
  );

  Map _item = {};
  List _pictures = [];
  Map _user = {};
  Map _reactions = {};
  Map _skill = {};
  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    loadDetails();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Scaffold(
        // BODY.
        body: CustomScrollView(
          slivers: [
            SliverAppBar(floating: true, snap: true, title: "Portfolio".t, leading: BackButtonWidget(), actions: []),

            SliverList(
              delegate: SliverChildListDelegate([
                18.gap,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Portfolio",
                      style: context.theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: CConsts.FONT_COMFORTAA,
                      ),
                    ),
                    Text("${_user['name'] ?? 'N/A'}", style: TextStyle(fontWeight: FontWeight.bold)),

                    18.gap,
                    Text("${_item['title'] ?? 'N/A'}", style: context.theme.textTheme.titleLarge),
                  ],
                ).withPadding(horizontal: 12).asSkeleton(enabled: isLoading.value),
                9.gap,

                CarouselSlider(
                  options: carousselOption,
                  items: _pictures.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return InkWell(
                          onTap: () => PhotoViewerWidget.fullscreenModal(
                            context,
                            title: "Portfolio",
                            urls: [for (String pid in _pictures) CNetworkFilesClass.picture(pid)],
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: CConsts.COLOR_GREY_LIGHT,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Image.network(
                              CNetworkFilesClass.picture(i),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(child: Icon(IconsaxPlusLinear.image, size: 54));
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(child: SpinnerWidget(size: 18));
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ).asSkeleton(enabled: isLoading.value),

                // REACTIONS.
                18.gap,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    "J'aime ceci".t,
                    4.5.gap,
                    TextButton.icon(onPressed: () {}, label: "123K".t, icon: Icon(IconsaxPlusLinear.like_1)),
                    Spacer(),
                    TextButton.icon(onPressed: null, label: "123K Deals".t, icon: Icon(IconsaxPlusLinear.chart)),
                  ],
                ).withPadding(horizontal: 12).asSkeleton(enabled: isLoading.value),

                9.gap,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_skill.isNotEmpty) ...[
                      Chip(
                        label: "${_skill['name'] ?? 'N/A'}".t,
                      ).cursorClick(onClick: () => SkillReaderWidget.onBottomSheet(context, skillId: _skill['id'] ?? '---')),
                      4.5.gap,
                    ],

                    // DESCRIPTION.
                    Text("${_item['description']}", style: context.theme.textTheme.bodyLarge),
                  ],
                ).withPadding(horizontal: 12).asSkeleton(enabled: isLoading.value),

                // COMMENTS
                18.gap,
                CommenterWidget(
                  model: 'App\\Models\\PortfolioItem',
                  modelId: widget.portfolioId ?? '---',
                ).withPadding(horizontal: 12),

                // SPACER.
                81.gap,
              ]),
            ),
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
    _reactions;

    Map<String, dynamic> params = {'portfolioId': widget.portfolioId ?? '---'};
    var req = CApi.request.get('/user/tasker/qDoZWZjHL', queryParameters: params);
    req.whenComplete(() => isLoading.value = false);
    req.then(
      (res) {
        // Logger().t(res.data);
        if (res.data is Map && res.data['success'] == true) {
          // CToast(context).success("".t);
          _item = res.data['data']['item'] ?? {};
          _pictures = res.data['data']['pictures'] ?? [];
          _user = res.data['data']['user'] ?? {};
          _reactions = res.data['data']['reactions'] ?? {};
          _skill = res.data['data']['skill'] ?? {};
        } else {
          CToast(context).warning("Impossible de charger les donnees du portfolio.".t);
          CRouter(context).goBack();
        }
      },
      onError: (e) {
        Logger().e(e);
        CToast(context).error("Probleme de connexion.".t);
      },
    );
  }
}
