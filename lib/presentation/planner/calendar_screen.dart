import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/theme/app_theme.dart';
import 'providers/planner_provider.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final assignmentsAsync = ref.watch(
      plannerAssignmentsProvider(
        start: _focusedDay.subtract(const Duration(days: 31)),
        end: _focusedDay.add(const Duration(days: 31)),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Workout Calendar')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (day) {
              final assignments = assignmentsAsync.valueOrNull;
              if (assignments == null) return [];

              final dateStr =
                  "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
              final events = <String>[];

              final workouts = assignments['details']['workouts'] as List;
              if (workouts.any((w) => w['date'] == dateStr))
                events.add('workout');

              final diets = assignments['details']['diet'] as List;
              if (diets.any((d) => d['date'] == dateStr)) events.add('diet');

              return events;
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: assignmentsAsync.when(
              data: (assignments) {
                final dateStr =
                    "${_selectedDay!.year}-${_selectedDay!.month.toString().padLeft(2, '0')}-${_selectedDay!.day.toString().padLeft(2, '0')}";

                final workouts = (assignments['details']['workouts'] as List)
                    .where((w) => w['date'] == dateStr)
                    .toList();

                final diets = (assignments['details']['diet'] as List)
                    .where((d) => d['date'] == dateStr)
                    .toList();

                if (workouts.isEmpty && diets.isEmpty) {
                  return const Center(
                    child: Text('No activities scheduled for this day'),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (workouts.isNotEmpty) ...[
                      const Text('Workouts', style: AppTextStyles.h3),
                      const SizedBox(height: 8),
                      ...workouts.map(
                        (w) => Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.fitness_center,
                              color: AppColors.primary,
                            ),
                            title: Text(w['name'] ?? 'Rest Day'),
                            subtitle: Text(
                              w['type'] == 'rest'
                                  ? 'Recovery day'
                                  : 'Workout session',
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (diets.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      const Text('Diet Plan', style: AppTextStyles.h3),
                      const SizedBox(height: 8),
                      ...diets.map(
                        (d) => Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.restaurant,
                              color: Colors.green,
                            ),
                            title: Text(d['name']),
                            subtitle: const Text('Meals for today'),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
