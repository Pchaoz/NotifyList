import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:notifylist/features/categories/models/category.dart';
import 'package:notifylist/features/tasks/models/task.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Tasks, Categories])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(tasks, tasks.scheduledDate);
            await m.addColumn(tasks, tasks.startTime);
            await m.addColumn(tasks, tasks.endTime);
            await m.addColumn(tasks, tasks.weekDays);
          }
        },
      );

}



LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'notifylist.sqlite'));
    return NativeDatabase(file);
  });
}