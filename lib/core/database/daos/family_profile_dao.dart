import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/family_profiles_table.dart';

part 'family_profile_dao.g.dart';

@DriftAccessor(tables: [FamilyProfiles])
class FamilyProfileDao extends DatabaseAccessor<AppDatabase>
    with _$FamilyProfileDaoMixin {
  FamilyProfileDao(super.db);

  Future<FamilyProfile?> getProfile() =>
      (select(familyProfiles)..limit(1)).getSingleOrNull();

  Stream<FamilyProfile?> watchProfile() =>
      (select(familyProfiles)..limit(1)).watchSingleOrNull();

  Future<void> upsertProfile(FamilyProfilesCompanion profile) =>
      into(familyProfiles).insertOnConflictUpdate(profile);

  Future<void> deleteProfile(String id) =>
      (delete(familyProfiles)..where((p) => p.id.equals(id))).go();
}
