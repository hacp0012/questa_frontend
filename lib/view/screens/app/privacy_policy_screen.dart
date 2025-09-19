import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/screens/layouts/default_layout.dart';
import 'package:questa/view/widgets/back_button_widget.dart';

@RoutePage()
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});
  static const String routeId = "CS935FOS8";

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(leading: BackButtonWidget(), centerTitle: true, title: const Text("Privacy Policy")),

        // BDOY
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12),
          children: [
            77.gap,
            // Image.asset("lib/assets/icons/logo_q_white_bg_primary_color.png", height: 126),
            Image.asset("lib/assets/icons/logo_text_q_primary_color.png", height: 45),
            Text("Privacy Policy", textAlign: TextAlign.center),

            27.gap,
            Text(
              "Conditions générales d’utilisation et politique de confidentialité",
              style: context.theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            9.gap,
            Text("""
Dernière mise à jour : 15/08/2025

Conditions Générales d’Utilisation (CGU)

1. Présentation de la plateforme

Questa est une application mobile et web qui facilite la mise en relation entre des personnes ayant des besoins spécifiques (demandeurs) et celles disposant de compétences techniques, scientifiques, artistiques ou pratiques (Taskers). Elle permet de publier des tâches, de proposer des services ou produits, et de conclure des marchés dans un cadre sécurisé.

2. Inscription et accès

L’inscription est ouverte à toute personne majeure disposant d’un numéro de téléphone ou d’une adresse email valide. Chaque utilisateur dispose d’un profil personnel et peut accéder à des fonctionnalités selon son rôle (demandeur ou Tasker).

3. Fonctionnement général

Les demandeurs publient des tâches avec des détails : type, urgence, lieu, budget, etc. Les Taskers reçoivent des notifications selon leurs compétences et peuvent postuler. La mise en relation est activée via un système de tokens.

4. Système de tokens

Les tokens sont la monnaie virtuelle de la plateforme. Ils permettent :
- De postuler à une tâche
- De conclure un marché (accès aux coordonnées)
- De promouvoir son profil ou portfolio
- De recevoir des notifications SMS
- D’échanger avec les utilisateurs

Les tokens sont achetés avec de l’argent réel et peuvent être transférés entre Taskers.

5. Revenus et opportunités

Questa offre aux Taskers la possibilité de :
- Gagner de l’argent en réalisant des tâches
- Créer des revenus passifs grâce à la visibilité de leur profil et portfolio
- Valoriser leurs compétences dans des domaines à forte demande (réparation, art, tech, science…)

6. Engagements des utilisateurs
Chaque utilisateur s’engage à :
- Fournir des informations exactes
- Respecter les règles de courtoisie et de confidentialité
- Ne pas partager d’informations personnelles avant la conclusion d’un marché

7. Responsabilité

Questa n’est pas responsable de la qualité des prestations ou des biens échangés. Un système de notation et de signalement est mis en place pour garantir la fiabilité des échanges.

Politique de Confidentialité

1. Collecte des données

Questa collecte uniquement les données nécessaires suivantes :
- Identité (nom, téléphone, email)
- Compétences, publications, tâches
- Historique d’interactions et de transactions

2. Utilisation des données

Les données collectées par Questa sont principalement utilisées pour :
- Faciliter la mise en relation
- Personnaliser les notifications
- Gérer les tokens et les profils

3. Protection des données

Conformément à la loi n°20/017 de la RDC, au Code du Numérique, et aux standards internationaux (RGPD, ISO/IEC 27701), Questa met en œuvre les mesures suivantes :

Mesures techniques :
- Chiffrement des données sensibles
- Hébergement sécurisé
- Authentification forte
- Journalisation des accès
- Sauvegardes régulières

Mesures organisationnelles :
- Nomination d’un Responsable de la Sécurité des Systèmes d’Information (RSSI)
- Formation des équipes
- Analyse d’impact sur la vie privée (AIPD)
- Politique de gestion des incidents
Prévention :
- Un algorithme puissant est mis en place pour bloque tout partage d’informations personnelles avant la conclusion d’un marché
- Les données ne sont jamais revendues à des tiers

4. Droits des utilisateurs

Chaque utilisateur peut :
- Accéder à ses données
- Demander leur modification ou suppression
- Retirer son consentement
- S’opposer au traitement automatisé

5. Conformité internationale
Questa respecte les principes fondamentaux du Règlement Général sur la Protection des Données et de la Convention de Malabo :
- Consentement explicite
- Minimisation des données
- Transparence
- Droit à l’oubli
- Portabilité des données

            """, style: context.theme.textTheme.bodyMedium?.copyWith(fontFamily: CConsts.FONT_ISTOK)),

            // SPACER.
            81.gap,
          ],
        ),
      ),
    );
  }
}
