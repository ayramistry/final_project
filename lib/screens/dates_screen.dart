import "package:flutter/material.dart";
import "package:table_calendar/table_calendar.dart";
import "package:intl/intl.dart";

class DatesScreen extends StatefulWidget {
  const DatesScreen({super.key});

  @override
  State<DatesScreen> createState() => _DatesScreenState();
}

class _DatesScreenState extends State<DatesScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<String>> _events = {};

  List<String> _getEventsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _events[key] ?? [];
  }

  Future<void> _addEvent() async {
    final day = _selectedDay ?? _focusedDay;
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Add plan"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "e.g., Museum at 2pm",
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Cancel")),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, controller.text.trim()),
              child: const Text("Add"),
            ),
          ],
        );
      },
    );

    if (result == null || result.isEmpty) return;

    final key = DateTime(day.year, day.month, day.day);
    setState(() {
      _events.putIfAbsent(key, () => []);
      _events[key]!.add(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final selected = _selectedDay ?? _focusedDay;
    final plans = _getEventsForDay(selected);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dates"),
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addEvent,
        icon: const Icon(Icons.add),
        label: const Text("Add plan"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: cs.secondary.withOpacity(0.35),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: cs.primary,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: cs.tertiary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  eventLoader: _getEventsForDay,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Plans for ${DateFormat("EEE, MMM d").format(selected)}",
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: plans.isEmpty
                  ? Center(
                      child: Text(
                        "No plans yet.\nTap “Add plan” to create one ✨",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: cs.onSurface.withOpacity(0.7)),
                      ),
                    )
                  : ListView.separated(
                      itemCount: plans.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        return Card(
                          child: ListTile(
                            leading: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: cs.secondary.withOpacity(0.22),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(Icons.place, color: cs.onSurface),
                            ),
                            title: Text(plans[i]),
                            subtitle: Text(
                              "Demo entry",
                              style: TextStyle(
                                  color: cs.onSurface.withOpacity(0.6)),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
