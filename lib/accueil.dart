import 'package:flutter/material.dart';
import 'package:projetfinal/whitetext.dart';

import 'models.dart'; // Importation des modèles, incluant probablement le DatabaseManager et les classes de données

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Instance du gestionnaire de base de données
  final DatabaseManager _dbManager = DatabaseManager();
  // Contrôleurs pour les champs de saisie de texte
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _contenuController = TextEditingController();
  // Future pour récupérer les notes
  late Future<List<Note>> _notesFuture;

  @override
  void initState() {
    super.initState();
    // Initialisation du Future pour récupérer toutes les notes
    _notesFuture = _dbManager.getAllNotes();
  }

  // Méthode asynchrone pour ajouter une note
  Future<void> _addNote() async {
    final titre = _titreController.text;
    final contenu = _contenuController.text;

    // Vérification que les champs ne sont pas vides
    if (titre.isEmpty || contenu.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    // Création d'une nouvelle note
    final note = Note(
      titre: titre,
      contenu: contenu,
    );

    // Insertion de la note dans la base de données
    await _dbManager.insertNote(note);
    setState(() {
      _notesFuture = _dbManager.getAllNotes();
    });
    // Réinitialisation des contrôleurs de texte et fermeture de la boîte de dialogue
    _titreController.clear();
    _contenuController.clear();
    Navigator.of(context).pop();
  }

  // Méthode pour mettre à jour une note existante
  Future<void> _updateNote(Note note) async {
    // Pré-remplissage des contrôleurs de texte avec les valeurs actuelles de la note
    _titreController.text = note.titre;
    _contenuController.text = note.contenu;

    // Affichage d'une boîte de dialogue pour modifier la note
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier la note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titreController,
                decoration: const InputDecoration(labelText: 'Titre'),
              ),
              TextField(
                controller: _contenuController,
                decoration: const InputDecoration(labelText: 'Contenu'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Mise à jour des valeurs de la note
                note.titre = _titreController.text;
                note.contenu = _contenuController.text;

                // Vérification que les champs ne sont pas vides
                if (note.titre.isEmpty || note.contenu.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Veuillez remplir tous les champs')),
                  );
                  return;
                }

                // Mise à jour de la note dans la base de données
                await _dbManager.updateNote(note);
                setState(() {
                  _notesFuture = _dbManager.getAllNotes();
                });
                _titreController.clear();
                _contenuController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  // Méthode pour confirmer la suppression d'une note
  Future<void> _deleteNoteConfirm(int id) async {
    // Affichage d'une boîte de dialogue de confirmation
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer la note'),
          content: const Text('Voulez-vous vraiment supprimer cette note ?'),
          actions: [
            TextButton(
              onPressed: () async {
                // Suppression de la note de la base de données
                await _dbManager.deleteNote(id);
                setState(() {
                  _notesFuture = _dbManager.getAllNotes();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Supprimer'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const WhiteText('To do List'), // Titre de l'AppBar avec texte blanc
      ),
      body: FutureBuilder<List<Note>>(
        future: _notesFuture,
        builder: (context, snapshot) {
          // Affichage d'un indicateur de progression si les données sont en cours de chargement
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
            // Affichage d'un message d'erreur si une erreur survient
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
            // Affichage d'un message si aucune note n'est disponible
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune note disponible'));
            // Affichage de la liste des notes
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final note = snapshot.data![index];
                return Card(
                  elevation: 3,
                  child: ListTile(
                    title: Text(note.titre),
                    subtitle: Text(note.contenu),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _updateNote(note);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteNoteConfirm(note.id!);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      // Bouton pour ajouter une nouvelle note
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Ajouter une note'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titreController,
                      decoration: const InputDecoration(labelText: 'Titre'),
                    ),
                    TextField(
                      controller: _contenuController,
                      decoration: const InputDecoration(labelText: 'Contenu'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await _addNote();
                    },
                    child: const Text('Ajouter'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
