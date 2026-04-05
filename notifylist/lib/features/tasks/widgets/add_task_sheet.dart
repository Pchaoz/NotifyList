import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notifylist/core/theme/app_theme.dart';
import 'package:notifylist/features/tasks/providers/tasks_providers.dart';

class AddTaskSheet extends ConsumerStatefulWidget {
  const AddTaskSheet({super.key});

  @override
  ConsumerState<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends ConsumerState<AddTaskSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final List<int> _selectedWeekDays = [];
  bool _isLoading = false;

  static const _weekDayNames = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

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
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _startTime = picked);
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _endTime = picked);
  }

  // Convierte TimeOfDay a minutos desde medianoche
  int? _toMinutes(TimeOfDay? time) {
    if (time == null) return null;
    return time.hour * 60 + time.minute;
  }

  // Convierte lista de días a String "1,3,5"
  String? _weekDaysToString() {
    if (_selectedWeekDays.isEmpty) return null;
    final sorted = [..._selectedWeekDays]..sort();
    return sorted.join(',');
  }

  Future<void> _submit() async {
    if (_titleController.text.trim().isEmpty) return;
    setState(() => _isLoading = true);

    await ref.read(tasksProvider.notifier).addTask(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      categoryId: 'default',
      scheduledDate: _selectedDate,
      startTime: _toMinutes(_startTime),
      endTime: _toMinutes(_endTime),
      weekDays: _weekDaysToString(),
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
      child: SingleChildScrollView(
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
              ),
            ),
            const SizedBox(height: 24),

            // Campo título
            TextField(
              controller: _titleController,
              autofocus: true,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: 'Título de la tarea',
                hintStyle: const TextStyle(color: AppTheme.textSecondary),
                filled: true,
                fillColor: AppTheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Campo descripción
            TextField(
              controller: _descriptionController,
              style: const TextStyle(color: AppTheme.textPrimary),
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Descripción (opcional)',
                hintStyle: const TextStyle(color: AppTheme.textSecondary),
                filled: true,
                fillColor: AppTheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Selector fecha concreta
            _SectionLabel(label: 'Fecha concreta'),
            const SizedBox(height: 8),
            _OptionRow(
              icon: Icons.calendar_today_outlined,
              label: _selectedDate == null
                  ? 'Seleccionar fecha'
                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
              isSet: _selectedDate != null,
              onTap: _pickDate,
              onClear: () => setState(() => _selectedDate = null),
            ),
            const SizedBox(height: 16),

            // Días de la semana
            _SectionLabel(label: 'Días de la semana'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final day = index + 1;
                final isSelected = _selectedWeekDays.contains(day);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      isSelected
                          ? _selectedWeekDays.remove(day)
                          : _selectedWeekDays.add(day);
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? AppTheme.primary : AppTheme.surface,
                    ),
                    child: Center(
                      child: Text(
                        _weekDayNames[index],
                        style: TextStyle(
                          color: isSelected
                              ? AppTheme.textPrimary
                              : AppTheme.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),

            // Hora inicio y fin
            _SectionLabel(label: 'Horario'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _OptionRow(
                    icon: Icons.schedule_outlined,
                    label: _startTime == null
                        ? 'Hora inicio'
                        : _startTime!.format(context),
                    isSet: _startTime != null,
                    onTap: _pickStartTime,
                    onClear: () => setState(() => _startTime = null),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _OptionRow(
                    icon: Icons.schedule_outlined,
                    label: _endTime == null
                        ? 'Hora fin'
                        : _endTime!.format(context),
                    isSet: _endTime != null,
                    onTap: _pickEndTime,
                    onClear: () => setState(() => _endTime = null),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Botón guardar
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
                        ),
                      )
                    : const Text(
                        'Guardar tarea',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget reutilizable para el label de sección
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppTheme.textSecondary,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}

// Widget reutilizable para filas de opciones con botón de borrar
class _OptionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSet;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _OptionRow({
    required this.icon,
    required this.label,
    required this.isSet,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: isSet
              ? Border.all(color: AppTheme.primary, width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isSet ? AppTheme.primary : AppTheme.textSecondary,
                size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSet ? AppTheme.textPrimary : AppTheme.textSecondary,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSet)
              GestureDetector(
                onTap: onClear,
                child: const Icon(Icons.close,
                    color: AppTheme.textSecondary, size: 16),
              ),
          ],
        ),
      ),
    );
  }
}