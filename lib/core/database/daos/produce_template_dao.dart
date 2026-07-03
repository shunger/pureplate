import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/produce_templates_table.dart';

part 'produce_template_dao.g.dart';

@DriftAccessor(tables: [ProduceTemplates])
class ProduceTemplateDao extends DatabaseAccessor<AppDatabase>
    with _$ProduceTemplateDaoMixin {
  ProduceTemplateDao(super.db);

  Future<List<ProduceTemplate>> getAllTemplates() =>
      (select(produceTemplates)..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .get();

  Stream<List<ProduceTemplate>> watchAllTemplates() =>
      (select(produceTemplates)..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .watch();

  Future<List<ProduceTemplate>> searchTemplates(String query) {
    final pattern = '%$query%';
    return (select(produceTemplates)
          ..where((t) => t.name.like(pattern) | t.pluCode.like(pattern)))
        .get();
  }

  Future<void> insertTemplate(ProduceTemplatesCompanion template) =>
      into(produceTemplates).insertOnConflictUpdate(template);

  Future<void> deleteTemplate(String id) =>
      (delete(produceTemplates)..where((t) => t.id.equals(id))).go();

  Future<int> getTemplateCount() async {
    final count = countAll();
    final query = selectOnly(produceTemplates)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }
}
