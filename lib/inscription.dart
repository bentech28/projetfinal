import 'package:flutter/material.dart';
import 'package:projetfinal/whitetext.dart'; // Importation d'un widget personnalisé pour le texte blanc

import 'models.dart'; // Importation des modèles, incluant probablement le DatabaseManager et les classes de données

class InscriptionPage extends StatefulWidget {
  @override
  _InscriptionPageState createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  // Contrôleurs pour les champs de saisie de texte
  final TextEditingController _nomUtilisateurController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _motDePasseController = TextEditingController();

  // Instance du gestionnaire de base de données
  final DatabaseManager _dbManager = DatabaseManager();

  // Style pour le bouton élevé
  final ButtonStyle style = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 20),
    backgroundColor: Colors.blue,
  );

  // Méthode asynchrone pour gérer l'inscription
  Future<void> _inscrire() async {
    final nomUtilisateur = _nomUtilisateurController.text;
    final email = _emailController.text;
    final motDePasse = _motDePasseController.text;

    // Vérification que les champs ne sont pas vides
    if (nomUtilisateur.isEmpty || email.isEmpty || motDePasse.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    // Vérification si l'utilisateur existe déjà dans la base de données
    final existingUser = await _dbManager.getUtilisateur(nomUtilisateur);
    if (existingUser != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le nom d\'utilisateur existe déjà')),
      );
      return;
    }

    // Création d'un nouvel utilisateur
    final utilisateur = Utilisateur(
      nomUtilisateur: nomUtilisateur,
      email: email,
      motDePasse: motDePasse,
    );

    // Insertion de l'utilisateur dans la base de données
    await _dbManager.insertUtilisateur(utilisateur);

    // Affichage d'un message de succès et navigation vers la page de connexion
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Inscription réussie')),
    );
    Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const WhiteText('Inscription'), // Titre de l'AppBar avec texte blanc
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
                decoration: InputDecoration(labelText: 'Nom d\'utilisateur'),
              ),

              // Champ de texte pour l'email
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),

              // Champ de texte pour le mot de passe avec obscureText pour masquer le texte
              TextField(
                controller: _motDePasseController,
                decoration: InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
              ),

              SizedBox(height: 20), // Espacement vertical de 20 pixels

              // Bouton pour s'inscrire
              ElevatedButton(
                onPressed: _inscrire, // Appelle la méthode _inscrire lorsqu'on appuie sur le bouton
                style: style,
                child: const WhiteText('S\'inscrire'), // Texte du bouton avec style blanc
              ),
            ],
          ),
        ),
      ),
    );
  }
}
