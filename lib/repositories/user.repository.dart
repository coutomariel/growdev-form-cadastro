import 'package:form_cadastro/database.config/db.dart';
import 'package:form_cadastro/model/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserRepository {

  Future<Database> _getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), DATABASE_NAME),
      onCreate: (db, version) {
        return db.execute(CREATE_USER_TABLE_SCRIPT);
      },
      version: DB_VERSION,
    );
  }

  Future<List<User>> getAllUsers() async {
    try {
      final Database db = await _getDatabase();
      var res = await db.query(TABLE_USER);
      List<User> list =
          res.isNotEmpty ? res.map((u) => User.fromJson(u)).toList() : [];
      return list;
    } catch (e) {
      print(e);
      return List<User>();
    }
  }

  Future<int> create(User user) async {
    try {
      final Database db = await _getDatabase();
      return await db.insert(
        TABLE_USER,
        user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> update(User user) async {
    try {
      final Database db = await _getDatabase();
      return await db.update(
        TABLE_USER,
        user.toJson(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

  delete(int id) async {
    try {
      final Database db = await _getDatabase();
      await db.delete(
        TABLE_USER,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print(e);
      return;
    }
  }
}
