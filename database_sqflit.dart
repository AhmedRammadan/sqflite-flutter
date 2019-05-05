import 'package:learn_flutter/models/post.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseSqflit {
  Database db;
  Future<Database> database() async {
    var database = openDatabase(join(await getDatabasesPath(), 'posts.db'),
        version: 1, onCreate: (db, version) {
      return db.execute(
          'create table posts(id integer,userId integer,title text,body text)');
    });
    return database;
  }

  void insertPost(Post post) async {
    await db.insert('posts', post.toMap(post),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  void deletePost(int id) async {
    await db.delete('posts', where: 'id = ?', whereArgs: [id]);
  }

  createDB() async {
    db = await database();
  }

  void upData(Post post) async {
    await db.update('posts', post.toMap(post),
        whereArgs: [post.id], where: 'id = ?');
  }

  Future<List<Post>> posts() async {
    List<Map<String, dynamic>> map = await db.query('posts');
    return List.generate(map.length, (index) {
      return Post.fromJson(map[index]);
    });
  }
}

Future<Database> createDatabase() async {
  Database database =
      await openDatabase(join(await getDatabasesPath(), 'test.db'), version: 1,
          onCreate: (db, version) {
    return db.execute(
        'create table if not Exist test (id integer,title text,body text,userId integer)');
  });
  return database;
}

void addPost(Post post) async {
  Database db = await createDatabase();
  db.insert('test', post.toMap(post),
      conflictAlgorithm: ConflictAlgorithm.replace);
}

void deletPost(int id, Post post) async {
  Database db = await createDatabase();
  await db.delete('test', where: 'id = ?', whereArgs: [id]);
  db.insert('test', post.toMap(post));
  db.update('test', post.toMap(post), where: 'id = ?', whereArgs: [post.id]);     
  List<Map<String, dynamic>> map = await db.query('test');
  List.generate(map.length, (index) => 'ahmedd$index');
}
