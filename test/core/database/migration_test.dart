import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/core/database/app_database.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('reopens after a v5 upgrade interrupted before saving the version',
      () async {
    final dir = await Directory.systemTemp.createTemp('migration_test');
    final file = File('${dir.path}/db.sqlite');
    addTearDown(() => dir.delete(recursive: true));

    // A fully created current database...
    var db = AppDatabase.forTesting(NativeDatabase(file));
    await db.recipeDao.getAllRecipes();
    await db.close();

    // ...whose version says 4 although is_mine was already added.
    final raw = sqlite3.open(file.path)..execute('PRAGMA user_version = 4');
    raw.dispose();

    db = AppDatabase.forTesting(NativeDatabase(file));
    await expectLater(db.recipeDao.getAllRecipes(), completes);
    await db.close();

    final check = sqlite3.open(file.path);
    expect(check.select('PRAGMA user_version').first.values.first, 5);
    check.dispose();
  });
}
