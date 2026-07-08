import 'package:drift/native.dart';
import 'package:pure_pantry/core/database/app_database.dart';

/// Creates a fresh in-memory database for testing.
///
/// Each call returns an independent instance — call `db.close()` in tearDown.
AppDatabase createTestDatabase() {
  return AppDatabase.forTesting(NativeDatabase.memory());
}
