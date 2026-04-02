import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notifylist/core/database/app_database.dart';
import 'package:notifylist/core/theme/app_theme.dart';
import 'package:notifylist/features/tasks/providers/tasks_providers.dart';

class TaskCard extends ConsumerWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: GestureDetector(
            onTap: () => ref.read(tasksProvider.notifier).toggleTask(task),
            child: AnimatedContainer(duration: const Duration(milliseconds: 200),
            width: 28, 
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: task.isCompleted ? AppTheme.completed : Colors.transparent,
              border: Border.all(
                color: task.isCompleted ? AppTheme.completed : AppTheme.secondary,
                width: 2,
              ),
            ),
            child: task.isCompleted ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            color: task.isCompleted ? AppTheme.textSecondary : AppTheme.textPrimary,
            fontSize: 16,
            decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        subtitle: task.description != null ? Text(
          task.description!,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 13,
          )
        ) : null,
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: AppTheme.danger),
          onPressed: () => ref.read(tasksProvider.notifier).deleteTask(task.id),
        ),
      ),
    );
  }
}