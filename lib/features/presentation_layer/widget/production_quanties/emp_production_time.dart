import 'package:flutter/material.dart';

class UpdateTime extends StatefulWidget {
  final void Function(String) onTimeChanged; // Made onTimeChanged required

  UpdateTime({Key? key, required this.onTimeChanged}) : super(key: key);

  @override
  State<UpdateTime> createState() => _UpdateTimeState();
}

class _UpdateTimeState extends State<UpdateTime> {
  late DateTime now;
  late int currentYear;
  late int currentMonth;
  late int currentDay;
  late int currentHour;
  late int currentMinute;
  late int currentSecond;
  late String currentTime; // Initialized to avoid null check

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    currentYear = now.year;
    currentMonth = now.month;
    currentDay = now.day;
    currentHour = now.hour;
    currentMinute = now.minute;
    currentSecond=now.second;
    currentTime =
        '$currentYear-$currentMonth-$currentDay $currentHour:${currentMinute.toString().padLeft(2, '0')}:${currentSecond.toString()}'; // Initial time display
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            // Decrease time by 30 minutes
            setState(() {
              if (currentMinute >= 30) {
                currentMinute -= 30;
              } else {
                if (currentHour == 0) {
                  currentHour = 23;
                  currentMinute = 30;
                } else {
                  currentHour -= 1;
                  currentMinute = 30;
                }
              }
            });
            updateTime(); // Update time after each change
          },
          child: Text('- 30 Mins'),
        ),
        SizedBox(
          width: 16,
        ),
        ElevatedButton(
          onPressed: () {
            // Increase time by 30 minutes
            setState(() {
              if (currentMinute < 30) {
                currentMinute += 30;
              } else {
                if (currentHour == 23) {
                  currentHour = 0;
                  currentMinute = 0;
                } else {
                  currentHour += 1;
                  currentMinute = 0;
                  
                }
              }
            });
            updateTime(); // Update time after each change
          },
          child: Text('+ 30 Mins'),
        ),
        SizedBox(
          width: 16,
        ),
        ElevatedButton(
          onPressed: () async {
            final TimeOfDay? result = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(hour: currentHour, minute: currentMinute, ),
              initialEntryMode: TimePickerEntryMode.input,
              builder: (BuildContext context, Widget? child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    alwaysUse24HourFormat: true,
                  ),
                  child: child!,
                );
              },
            );

            if (result != null) {
              setState(() {
                // Update only the time part, keeping the date part fixed
                currentHour = result.hour;
                currentMinute = result.minute;
                
              });
              updateTime();
            }
          },
          child: Text("Set Time"),
        ),
      ],
    );
  }

  void updateTime() {
    setState(() {
      currentTime =
          '$currentYear-$currentMonth-$currentDay $currentHour:${currentMinute.toString().padLeft(2, '0')}:${currentSecond.toString()}'; // Update currentTime
    });
    widget.onTimeChanged(currentTime); // Call the callback with the updated time
  }
}
