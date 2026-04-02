import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notifylist/core/database/app_database.dart';
import 'package:notifylist/main.dart';

// Provider que usaran los widgets para acceder a las diferentes tareas
final tasksProvider = AsyncNotifierProvider<TasksNotifier, List<Task>>(TasksNotifier.new);

class TasksNotifier extends AsyncNotifier<List<Task>> {
  //Se inicia al cargar el provider
  // Carga todas las "Tasks" de la base de datos
  @override
  Future<List<Task>> build() async {
    return _fetchTasks();
  }

  // Obtener todos los "Tasks" de la base de datos ordenados por fecha de creación
  Future<List<Task>> _fetchTasks() async {
    return database.select(database.tasks).get();
  }

  // Agregar una nueva "Task" a la base de datos
  Future<void> addTask({
    required String title,
    String? description,
    required String categoryId,
    DateTime? scheduledAt,
  }) async {
    final newTask = TasksCompanion(
      title: Value(title),
      description: Value(description),
      categoryId: Value(categoryId),
      scheduledAt: Value(scheduledAt),
      isCompleted: Value(false),
      createdAt: Value(DateTime.now())
    );

    await database.into(database.tasks).insert(newTask);
    ref.invalidateSelf();
  }
  // Marcar si la "task" esta completada o no
  Future<void> toggleTask(Task task) async {
    await (database.update(database.tasks)
      ..where((t) => t.id.equals(task.id)))
      .write(TasksCompanion(
        isCompleted: Value(!task.isCompleted)
      ));
      ref.invalidateSelf();
  } 
   
  // Eliminar "Task" de la base de datos
  Future<void> deleteTask(int id) async {
    await (database.delete(database.tasks)
      ..where((t) => t.id.equals(id)))
      .go();
    ref.invalidateSelf();
  }
}

