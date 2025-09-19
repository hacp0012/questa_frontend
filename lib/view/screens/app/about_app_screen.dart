import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/screens/layouts/default_layout.dart';
import 'package:questa/view/widgets/back_button_widget.dart';

@RoutePage()
class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({super.key});
  static const String routeId = "ilkFpVxqr";

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(leading: BackButtonWidget(), centerTitle: true, title: "A propos".t),

        // BODY.
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12),
          children: [
            77.gap,
            Image.asset("lib/assets/icons/logo_q_white_bg_primary_color.png", height: 126),
            Image.asset("lib/assets/icons/logo_text_q_primary_color.png", height: 45),
            Text("Version ${CConsts.APP_VERSION}", textAlign: TextAlign.center),
            Text("(c)${DateTime.now().year} - tout droit reserve", textAlign: TextAlign.center),

            // DETAILS.
            18.gap,
            Text("À propos de Questa", style: context.theme.textTheme.titleLarge, textAlign: TextAlign.center),
            9.gap,
            Text("""
Questa est bien plus qu’une application : c’est un pont entre les talents et les besoins réels. Elle permet à chacun — et surtout aux jeunes — de transformer leurs savoir-faire en opportunités concrètes, en répondant à des tâches proposées par d'autres utilisateurs.

Dans un monde où les compétences techniques et scientifiques sont de plus en plus recherchées, beaucoup ne savent pas comment les valoriser. Questa vient combler ce vide. Que vous sachiez coder, réparer, concevoir, analyser, ou organiser, votre savoir a de la valeur — et peut vous générer des revenus, parfois même passifs, en fonction des missions que vous choisissez.

Notre objectif est simple : rendre visible ce qui est utile, et faciliter les échanges équitables entre ceux qui ont des compétences et ceux qui ont des tâches à accomplir. Grâce à une interface intuitive et une communauté bienveillante, Questa vous aide à monétiser vos talents, à développer votre réseau, et à construire votre avenir professionnel, un projet à la fois.

Rejoignez Questa et faites partie d’un mouvement où chaque compétence compte, et où chaque tâche accomplie peut être une source de revenus, de reconnaissance et de croissance personnelle.
            """, style: context.theme.textTheme.bodyMedium?.copyWith(fontFamily: CConsts.FONT_ISTOK)),

            // ENGLISH VERSION
            27.gap,
            Text("""
ENGLISH VERSION.

Questa is more than just an app — it’s a bridge between skills and real-world needs. It empowers everyone — especially young people — to turn their know-how into real opportunities by responding to tasks posted by others in the community.

In today’s world, technical and scientific skills are in high demand, yet many don’t know how to showcase or monetize them. Questa fills that gap. Whether you can code, fix, design, analyze, or organize, your skills have value — and can help you earn money, even passive income, depending on the tasks you choose.

Our goal is simple: to make useful skills visible, and to facilitate fair exchanges between those who have expertise and those who need it. With an intuitive interface and a supportive community, Questa helps you monetize your talents, grow your network, and build your future, one task at a time.

Join Questa and be part of a movement where every skill matters, and every completed task can be a source of income, recognition, and personal growth.
            """, style: context.theme.textTheme.bodyMedium?.copyWith(fontFamily: CConsts.FONT_ISTOK)).muted,

            // SPACER.
            81.gap,
          ],
        ),
      ),
    );
  }
}
