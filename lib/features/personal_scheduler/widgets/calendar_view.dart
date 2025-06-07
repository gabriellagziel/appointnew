import 'package:flutter/material.dart';

class CalendarView extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const CalendarView({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => onDateSelected(selectedDate.subtract(const Duration(days: 1))),
        ),
        Text(
          '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () => onDateSelected(selectedDate.add(const Duration(days: 1))),
        ),
      ],
    );
  }
}
