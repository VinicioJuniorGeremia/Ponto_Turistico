import 'package:sqflite/sqlite_api.dart';
import '../model/tarefa.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseProvider {
  static const _dbName = 'cadastro_tarefas.db';
  static const _dbVersion = 2;


  DatabaseProvider._init();
  static final DatabaseProvider instance = DatabaseProvider._init();


  Database? _database;



  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final dbPath = '$databasesPath/$_dbName';
    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE ${Tarefa.NOME_TABELA} (
        ${Tarefa.CAMPO_ID} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Tarefa.CAMPO_DESCRICAO} TEXT NOT NULL,
        ${Tarefa.CAMPO_NOME} TEXT,
        ${Tarefa.CAMPO_DIFERENCIAIS} TEXT,
        ${Tarefa.CAMPO_INCLUSAO} TEXT,
        ${Tarefa.CAMPO_LATITUDE} REAL,
        ${Tarefa.CAMPO_LONGITUDE} REAL
      );
    ''');

  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {

  }


  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }

  }

}
///fim



