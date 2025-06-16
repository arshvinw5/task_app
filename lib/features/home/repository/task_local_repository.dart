import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_app/models/task_model.dart';
import 'package:task_app/models/user_model.dart';

class TaskLocalRepository {
  String tableName = 'tasks';

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
    final path = join(dbPath, "tasks.db");
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
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            uId TEXT NOT NULL,
            hexColor TEXT NOT NULL,
            dueAt TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            updatedAt TEXT NOT NULL,
            isSynced INTEGER NOT NULL
          )
        ''');
        }
      },
      //once the db is created
      onCreate: (db, version) async {
        //need to add table
        return db.execute(''' CREATE TABLE $tableName (
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          description TEXT NOT NULL,
          uId TEXT NOT NULL,
          hexColor TEXT NOT NULL,
          dueAt TEXT NOT NULL,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL,
          isSynced INTEGER NOT NULL
        )''');
      },
    );
  }

  //inset a task only by function
  Future<void> insertTask(TaskModel task) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [task.id]);
    await db.insert(tableName, task.toMap());
    print('inserted');
  }

  //insert a tasks as batch to db
  Future<void> insertTasks(List<TaskModel> taskList) async {
    final db = await database;
    final batch = db.batch();

    for (final tasks in taskList) {
      batch.insert(
        tableName,
        tasks.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<TaskModel>> getTask() async {
    final db = await database;
    final res = await db.query(tableName);
    if (res.isNotEmpty) {
      List<TaskModel> taskList = [];
      for (final elem in res) {
        taskList.add(TaskModel.fromMap(elem));
      }
      return taskList;
    }
    return [];
  }
}




      // onUpgrade: (db, oldVersion, newVersion) {
      //   if (oldVersion < newVersion) {
      //     // Create the new table
      //     db.execute('''
      //       CREATE TABLE $tableName (
      //         id TEXT PRIMARY KEY,
      //         title TEXT NOT NULL,
      //         description TEXT NOT NULL,
      //         uId TEXT NOT NULL,
      //         hexColor TEXT NOT NULL,
      //         dueAt TEXT NOT NULL,
      //         createdAt TEXT NOT NULL,
      //         updatedAt TEXT NOT NULL
      //       )
      //     ''');
      //   }
      // },