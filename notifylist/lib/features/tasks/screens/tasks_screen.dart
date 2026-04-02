import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notifylist/core/theme/app_theme.dart';
import 'package:notifylist/features/tasks/providers/tasks_providers.dart';
import 'package:notifylist/features/tasks/widgets/task_card.dart';
import 'package:notifylist/features/tasks/widgets/add_task_sheet.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.category_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: tasksAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: AppTheme.danger),
          ),
        ),
        data: (tasks) {
          if (tasks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: AppTheme.textSecondary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No hay tareas pendientes',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '¡Pulsa + para agregar una nueva tarea!',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return TaskCard(task: tasks[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: AppTheme.cardColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (_) => const AddTaskSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}