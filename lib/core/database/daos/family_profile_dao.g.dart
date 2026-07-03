// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_profile_dao.dart';

// ignore_for_file: type=lint
mixin _$FamilyProfileDaoMixin on DatabaseAccessor<AppDatabase> {
  $FamilyProfilesTable get familyProfiles => attachedDatabase.familyProfiles;
  FamilyProfileDaoManager get managers => FamilyProfileDaoManager(this);
}

class FamilyProfileDaoManager {
  final _$FamilyProfileDaoMixin _db;
  FamilyProfileDaoManager(this._db);
  $$FamilyProfilesTableTableManager get familyProfiles =>
      $$FamilyProfilesTableTableManager(
        _db.attachedDatabase,
        _db.familyProfiles,
      );
}
