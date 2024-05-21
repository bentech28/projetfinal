import 'package:flutter/material.dart';
import 'package:projetfinal/whitetext.dart';

import 'models.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseManager _dbManager = DatabaseManager();
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _contenuController = TextEditingController();
  late Future<List<Note>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _notesFuture = _dbManager.getAllNotes();
  }

  Future<void> _addNote() async {
    final titre = _titreController.text;
    final contenu = _contenuController.text;

    if (titre.isEmpty || contenu.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    final note = Note(
      titre: titre,
      contenu: contenu,
    );

    await _dbManager.insertNote(note);
    setState(() {
      _notesFuture = _dbManager.getAllNotes();
    });
    _titreController.clear();
    _contenuController.clear();
    Navigator.of(context).pop();
  }

  Future<void> _updateNote(Note note) async {
    _titreController.text = note.titre;
    _contenuController.text = note.contenu;

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
                note.titre = _titreController.text;
                note.contenu = _contenuController.text;

                if (note.titre.isEmpty || note.contenu.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Veuillez remplir tous les champs')),
                  );
                  return;
                }

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

  Future<void> _deleteNoteConfirm(int id) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer la note'),
          content: const Text('Voulez-vous vraiment supprimer cette note ?'),
          actions: [
            TextButton(
              onPressed: () async {
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
        title: const WhiteText('To do List'),
      ),
      body: FutureBuilder<List<Note>>(
        future: _notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune note disponible'));
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
                          icon: const Icon(Icons.edit,color: Colors.blue,),
                          onPressed: () {
                            _updateNote(note);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,color: Colors.red,),
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
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}
