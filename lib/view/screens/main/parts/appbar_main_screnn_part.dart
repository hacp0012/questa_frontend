part of '../main_screen.dart';

class AppbarMainScrennPart extends StatelessWidget {
  const AppbarMainScrennPart({super.key});

  @override
  Widget build(BuildContext context) {
    // Map userData = Dsi.of<UserMv>(context)?.data ?? {};

    return SliverAppBar(
      automaticallyImplyLeading: false,
      title: Image.asset('lib/assets/icons/logo_text_q_primary_color.png', width: 100),
      floating: true,
      snap: true,
      actions: [
        Badge(
          // label: '${context.dsi<Menemene>()?.value}'.t,
          // label: "${Dsi.of<Menemene>(context)?.value}".t,
          label: "0".t,
          offset: Offset(-6, 0),
          child: IconButtonWidget(
            onPressed: () => CRouter(context).goTo(NotificationsRoute()),
            icon: Icon(IconsaxPlusLinear.notification),
          ),
        ),
        // 9.gap,
        // CircleAvatar(
        //   backgroundImage: userData['picture'] == null
        //       ? null
        //       : Image.network(
        //           CNetworkFilesClass.picture(userData['picture'], scale: 36, defaultImage: 'logo'),
        //           errorBuilder: (context, error, stackTrace) => Icon(IconsaxPlusLinear.user),
        //         ).image,
        //   child: userData['picture'] != null ? null : Icon(IconsaxPlusLinear.user),
        // ).onTap(() => CRouter(context).goTo(UserProfileOptionRoute())),
      ],
    );
  }
}
