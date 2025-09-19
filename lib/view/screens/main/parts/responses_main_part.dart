part of '../main_screen.dart';

@RoutePage(name: "ResponsesMainPartRoute")
class ResponsesMainPart extends StatefulWidget {
  const ResponsesMainPart({super.key});

  @override
  State<ResponsesMainPart> createState() => _ResponsesMainPartState();
}

class _ResponsesMainPartState extends State<ResponsesMainPart>
    with AutomaticKeepAliveClientMixin<ResponsesMainPart>, UiValueMixin {
  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      slivers: [
        AppbarMainScrennPart(),

        SliverList(delegate: SliverChildListDelegate([ChatDiscusionsListPart()])),
      ],
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;

  @override
  bool get wantKeepAlive => true;
  // METHODS =================================================================================================================
}
