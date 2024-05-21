import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projetfinal/whitetext.dart';

import 'models.dart';

class ConnexionPage extends StatefulWidget {
  @override
  _ConnexionPageState createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  final TextEditingController _nomUtilisateurController = TextEditingController();
  final TextEditingController _motDePasseController = TextEditingController();
  final DatabaseManager _dbManager = DatabaseManager();
  final ButtonStyle style = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20),backgroundColor: Colors.blue);

  Future<void> _connecter() async {
    final nomUtilisateur = _nomUtilisateurController.text;
    final motDePasse = _motDePasseController.text;

    if (nomUtilisateur.isEmpty || motDePasse.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    final utilisateur = await _dbManager.getUtilisateur(nomUtilisateur);
    if (utilisateur == null || utilisateur.motDePasse != motDePasse) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nom d\'utilisateur ou mot de passe incorrect')),
      );
      return;
    }

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
        title: const WhiteText('Connexion'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                  child: Image.asset('asset/images/img1.jpg',height: 200,)
              ),
        
              TextField(
                controller: _nomUtilisateurController,
                decoration: const InputDecoration(labelText: 'Nom d\'utilisateur'),
              ),
              TextField(
                controller: _motDePasseController,
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: style,
                onPressed: _connecter,
                child: const WhiteText('Se connecter'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/inscription');
                },
                child: const Text('S\'inscrire'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
