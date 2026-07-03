// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produce_template_dao.dart';

// ignore_for_file: type=lint
mixin _$ProduceTemplateDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProduceTemplatesTable get produceTemplates =>
      attachedDatabase.produceTemplates;
  ProduceTemplateDaoManager get managers => ProduceTemplateDaoManager(this);
}

class ProduceTemplateDaoManager {
  final _$ProduceTemplateDaoMixin _db;
  ProduceTemplateDaoManager(this._db);
  $$ProduceTemplatesTableTableManager get produceTemplates =>
      $$ProduceTemplatesTableTableManager(
        _db.attachedDatabase,
        _db.produceTemplates,
      );
}
