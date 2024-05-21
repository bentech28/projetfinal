import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Utilisateur {
  int? id;
  String nomUtilisateur;
  String email;
  String motDePasse;

  Utilisateur({
    required this.nomUtilisateur,
    required this.email,
    required this.motDePasse,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomUtilisateur': nomUtilisateur,
      'email': email,
      'motDePasse': motDePasse,
    };
  }

  @override
  String toString() {
    return 'Utilisateur{id: $id, nomUtilisateur: $nomUtilisateur, email: $email, motDePasse: $motDePasse}';
  }
}

class Note {
  int? id;
  String titre;
  String contenu;

  Note({
    required this.titre,
    required this.contenu,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'contenu': contenu,
    };
  }

  @override
  String toString() {
    return 'Note{id: $id, titre: $titre, contenu: $contenu}';
  }
}

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  late Database _database;
  bool _isInitialized = false;

  DatabaseManager._internal();

  factory DatabaseManager() {
    return _instance;
  }

  Future<void> initialize() async {
    if (!_isInitialized) {
      _database = await openDatabase(
        join(await getDatabasesPath(), 'my_database.db'),
        onCreate: (db, version) {
          db.execute(
            "CREATE TABLE utilisateurs(id INTEGER PRIMARY KEY AUTOINCREMENT, nomUtilisateur TEXT, email TEXT, motDePasse TEXT)",
          );
          db.execute(
            "CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, titre TEXT, contenu TEXT)",
          );
        },
        version: 1,
      );
      _isInitialized = true;
    }
  }

  Future<void> insertUtilisateur(Utilisateur utilisateur) async {
    await _ensureDatabaseInitialized();
    await _database.insert(
      'utilisateurs',
      utilisateur.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Utilisateur?> getUtilisateur(String nomUtilisateur) async {
    await _ensureDatabaseInitialized();
    final List<Map<String, dynamic>> maps = await _database.query(
      'utilisateurs',
      where: 'nomUtilisateur = ?',
      whereArgs: [nomUtilisateur],
    );
    if (maps.isNotEmpty) {
      return Utilisateur(
        id: maps.first['id'],
        nomUtilisateur: maps.first['nomUtilisateur'],
        email: maps.first['email'],
        motDePasse: maps.first['motDePasse'],
      );
    }
    return null;
  }

  Future<void> insertNote(Note note) async {
    await _ensureDatabaseInitialized();
    await _database.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Note>> getAllNotes() async {
    await _ensureDatabaseInitialized();
    final List<Map<String, dynamic>> maps = await _database.query('notes');
    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'],
        titre: maps[i]['titre'],
        contenu: maps[i]['contenu'],
      );
    });
  }

  Future<void> updateNote(Note note) async {
    await _ensureDatabaseInitialized();
    await _database.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(int id) async {
    await _ensureDatabaseInitialized();
    await _database.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> _ensureDatabaseInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }
}
