import 'package:big_picture/constants/gaps.dart';
import 'package:big_picture/constants/sizes.dart';
import 'package:flutter/material.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> with Sizes, Gaps {
  final List<String> weekly = '일,월,화,수,목,금,토'.split(',');
  late final List<DateTime> days;

  int selectedDay = 0;
  Map<int, List<String>> todo = {};

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now().day;

    var now = DateTime.now();
    var startDate = now.add(Duration(days: -1 * now.weekday));
    days = List.generate(7, (index) => startDate.add(Duration(days: index)));
    todo = {
      for (var element in days)
        element.day: (element.day % 2 == 0 ? ['1', '2', '3', '4', '5'] : [])
    };
  }

  void _onDayTextTap(int day) {
    setState(() {
      selectedDay = selectedDay == day ? 0 : day;
    });
  }

  Widget dayText(int day, ThemeData theme) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => _onDayTextTap(day),
          child: SizedBox(
            width: size20 + size10,
            height: size20 + size10,
            child: Container(
              decoration: selectedDay == day
                  ? BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(20),
                    )
                  : null,
              child: Text(
                '$day',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
        ),
        if (todo[day]!.isNotEmpty)
          Transform.translate(
            offset: Offset(size10, size32 + size3),
            child: Container(
              width: size10,
              height: size10,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Card(
      child: Container(
        height: 350,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekly
                  .map(
                    (e) => SizedBox(
                      width: 30,
                      height: 30,
                      child: Text(
                        e,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: days.map((e) => dayText(e.day, theme)).toList(),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            todo[selectedDay]!.isEmpty
                ? Text(
                    '일정이 없습니다.',
                    style: theme.textTheme.bodyMedium,
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: todo[selectedDay]!.length,
                      itemBuilder: (context, index) => Text(
                        todo[selectedDay]![0],
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
