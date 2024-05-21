import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models.dart';

class InscriptionPage extends StatefulWidget {
  @override
  _InscriptionPageState createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final TextEditingController _nomUtilisateurController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _motDePasseController = TextEditingController();
  final DatabaseManager _dbManager = DatabaseManager();

  Future<void> _inscrire() async {
    final nomUtilisateur = _nomUtilisateurController.text;
    final email = _emailController.text;
    final motDePasse = _motDePasseController.text;

    if (nomUtilisateur.isEmpty || email.isEmpty || motDePasse.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    final existingUser = await _dbManager.getUtilisateur(nomUtilisateur);
    if (existingUser != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le nom d\'utilisateur existe déjà')),
      );
      return;
    }

    final utilisateur = Utilisateur(
      nomUtilisateur: nomUtilisateur,
      email: email,
      motDePasse: motDePasse,
    );

    await _dbManager.insertUtilisateur(utilisateur);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Inscription réussie')),
    );
    Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomUtilisateurController,
              decoration: InputDecoration(labelText: 'Nom d\'utilisateur'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _motDePasseController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _inscrire,
              child: Text('S\'inscrire'),
            ),
          ],
        ),
      ),
    );
  }
}
