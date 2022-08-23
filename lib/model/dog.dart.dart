import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Dog {
  final int id;
  final String name;
  final int age;

  const Dog({
    required this.id,
    required this.name,
    required this.age,
  });

  // To store database, convert dog into a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }

  static Future<void> insertDog(Database database, Dog dog) async {
    final db = await database;

    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  static Future<List<Dog>> dogs(Database database) async {
    final db = await database;
    // fetch all dogs from table.
    final List<Map<String, dynamic>> maps = await db.query('dogs');

    // Convert the List<Map<String, dynamic>> int a List<Dog>.
    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
      );
    });
  }

  static Future<void> updateDog(Database database, Dog dog) async {
    final db = await database;
    await db.update(
      'dogs',
      dog.toMap(),
      where: 'id = ?',
      whereArgs: [dog.id],
    );
  }

  static Future<void> deleteDog(Database database,  int id) async {
    final db = await database;
    await db.delete(
      'dogs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}