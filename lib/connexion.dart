import 'package:flutter/material.dart';
import 'package:projetfinal/whitetext.dart'; // Importation d'un widget personnalisé pour le texte blanc

import 'models.dart'; // Importation des modèles, incluant probablement le DatabaseManager et les classes de données

class ConnexionPage extends StatefulWidget {
  @override
  _ConnexionPageState createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  // Contrôleurs pour les champs de saisie de texte
  final TextEditingController _nomUtilisateurController = TextEditingController();
  final TextEditingController _motDePasseController = TextEditingController();

  // Instance du gestionnaire de base de données
  final DatabaseManager _dbManager = DatabaseManager();

  // Style pour le bouton élevé
  final ButtonStyle style = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 20),
    backgroundColor: Colors.blue,
  );

  // Méthode asynchrone pour gérer la connexion
  Future<void> _connecter() async {
    final nomUtilisateur = _nomUtilisateurController.text;
    final motDePasse = _motDePasseController.text;

    // Vérification que les champs ne sont pas vides
    if (nomUtilisateur.isEmpty || motDePasse.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    // Récupération de l'utilisateur depuis la base de données
    final utilisateur = await _dbManager.getUtilisateur(nomUtilisateur);

    // Vérification des informations d'identification
    if (utilisateur == null || utilisateur.motDePasse != motDePasse) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nom d\'utilisateur ou mot de passe incorrect')),
      );
      return;
    }

    // Affichage d'un message de succès et navigation vers la page d'accueil
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Connexion réussie')),
    );
    Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const WhiteText('Connexion'), // Titre de l'AppBar avec texte blanc
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Image avec coins arrondis
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('asset/images/img1.jpg', height: 200),
              ),

              // Champ de texte pour le nom d'utilisateur
              TextField(
                controller: _nomUtilisateurController,
                decoration: const InputDecoration(labelText: 'Nom d\'utilisateur'),
              ),

              // Champ de texte pour le mot de passe avec obscureText pour masquer le texte
              TextField(
                controller: _motDePasseController,
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
              ),

              const SizedBox(height: 20), // Espacement vertical de 20 pixels

              // Bouton pour se connecter
              ElevatedButton(
                style: style,
                onPressed: _connecter, // Appelle la méthode _connecter lorsqu'on appuie sur le bouton
                child: const WhiteText('Se connecter'), // Texte du bouton avec style blanc
              ),

              // Bouton textuel pour naviguer vers la page d'inscription
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/inscription'); // Navigation vers la page d'inscription
                },
                child: const Text('S\'inscrire'), // Texte du bouton
              ),
            ],
          ),
        ),
      ),
    );
  }
}
