import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_app/models/user_model.dart';

class AuthLocalRepository {
  String tableName = 'users';

  //initially this db is null
  Database? _database;

  //getter
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
      //that is not goiing to be null any more
    }

    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    //dbpath store in auth.db file
    //this is path for open loacl db
    final path = join(dbPath, "auth.db");
    return openDatabase(
      path,
      version: 3,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          // Create the new table
          await db.execute('DROP TABLE $tableName');
          await db.execute('''
            CREATE TABLE $tableName (
              id TEXT PRIMARY KEY,
              name TEXT NOT NULL,
              email TEXT NOT NULL,
              token TEXT NOT NULL,
              password TEXT NOT NULL,
              confirmPassword TEXT NOT NULL,
              createdAt TEXT NOT NULL,
              updatedAt TEXT NOT NULL
            )
          ''');
        }
      },
      //once the db is created
      onCreate: (db, version) async {
        //need to add table
        return db.execute(''' CREATE TABLE $tableName (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          email TEXT NOT NULL,
          token TEXT NOT NULL,
          password TEXT NOT NULL,
          confirmPassword TEXT NOT NULL,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL
        )''');
      },
    );
  }

  //insert a user
  Future<void> insertUser(UserModel userModel) async {
    final db = await database;
    await db.insert(
      tableName,
      userModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserModel?> getUser() async {
    final db = await database;
    final res = await db.query(tableName, limit: 1);
    if (res.isNotEmpty) {
      return UserModel.fromMap(res.first);
    }
    return null;
  }

  //to logout user
  Future<void> logout() async {
    final db = await database;
    await db.delete(tableName);
  }
}
