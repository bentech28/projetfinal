import 'package:flutter/material.dart';

import 'accueil.dart';
import 'connexion.dart';
import 'inscription.dart';

void main() {
  runApp(const MonApplication());
}

class MonApplication extends StatelessWidget {
  const MonApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestion des Utilisateurs et Notes',
      initialRoute: '/',
      routes: {
        '/': (context) => ConnexionPage(),
        '/inscription': (context) => InscriptionPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
