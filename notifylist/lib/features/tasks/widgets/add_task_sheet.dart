import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notifylist/core/theme/app_theme.dart';
import 'package:notifylist/features/tasks/providers/tasks_providers.dart';

class AddTaskSheet extends ConsumerStatefulWidget  {
  const AddTaskSheet({super.key});

  @override
  ConsumerState<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends ConsumerState<AddTaskSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController(); 
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(picked.year, picked.month, picked.day, pickedTime.hour, pickedTime.minute);
        });
      }
    }
  }

  Future<void> _submit() async {
    if (_titleController.text.isEmpty) return;
    setState(() => _isLoading = true);

    await ref.read(tasksProvider.notifier).addTask(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
      ? null
      : _descriptionController.text.trim(),
      categoryId: 'default',
      scheduledAt: _selectedDate,
    );

    if (mounted) Navigator.of(context).pop(); 
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nueva Tarea',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )
          ),
          const SizedBox(height: 24),

          TextField(
            controller: _titleController,
            autofocus: true,
            style: const TextStyle(color: AppTheme.textPrimary),
            decoration: const InputDecoration(
              hintText: 'Título de la tarea',
              hintStyle: const TextStyle(color: AppTheme.textSecondary),
            )
          ),
          TextField(
            controller: _descriptionController,
            style: const TextStyle(color: AppTheme.textPrimary),
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Descripción (opcional)',
              hintStyle: const TextStyle(color: AppTheme.textSecondary),
              filled: true,
              fillColor: AppTheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide.none,
              )
            )
          ),
          const SizedBox(height: 12),

          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined,
                  color: AppTheme.textSecondary, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    _selectedDate == null
                    ? 'Fecha y hora (opcional)'
                    : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} ${_selectedDate!.hour.toString().padLeft(2, '0')}:${_selectedDate!.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: _selectedDate == null
                      ? AppTheme.textSecondary
                      : AppTheme.textPrimary,
                    )
                  ),
                  const Spacer(),
                  if (_selectedDate != null)
                    GestureDetector(
                      onTap: () => setState(() => _selectedDate = null),
                      child: const Icon(Icons.close, color: AppTheme.textSecondary, size: 20),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.textPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
              ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                  )
                )
                : const Text(
                  'Guardar tarea',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )            
          )
          
        ]
      )
    );
  }
}