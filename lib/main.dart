import 'package:flutter/material.dart';

// Importation des différentes pages de l'application
import 'accueil.dart';
import 'connexion.dart';
import 'inscription.dart';

// Fonction principale qui exécute l'application
void main() {
  runApp(const MonApplication());
}

// Classe principale de l'application
class MonApplication extends StatelessWidget {
  const MonApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Supprime le bandeau de débogage
      title: 'Gestion des Utilisateurs et Notes', // Titre de l'application
      initialRoute: '/', // Définition de la route initiale
      routes: {
        '/': (context) => ConnexionPage(), // Route pour la page de connexion
        '/inscription': (context) => InscriptionPage(), // Route pour la page d'inscription
        '/home': (context) => HomePage(), // Route pour la page d'accueil
      },
    );
  }
}
