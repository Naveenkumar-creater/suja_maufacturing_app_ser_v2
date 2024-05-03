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
  late String currentTime; 
  late int currentSecond;// Initialized to avoid null check

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    currentYear = now.year;
    currentMonth = now.month;
    currentDay = now.day;
    currentHour = now.hour;
    currentMinute = now.minute;
    currentSecond= now.second;
    currentTime =
        '$currentYear-$currentMonth-$currentDay $currentHour:${currentMinute.toString().padLeft(2, '0')}:${currentSecond.toString()}'; // Initial time display
    print('$currentYear-----------------------');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
       
        ElevatedButton(
          onPressed: () {
            if (currentMinute >= 30) {
              setState(() {
                currentMinute -= 30;
              });
            } else {
              if (currentHour == 1) {
                setState(() {
                  currentHour = 24;
                  currentMinute = 30;
                });
              } else {
                setState(() {
                  currentHour -= 1;
                  currentMinute = 30;
                });
              }
            }
            updateTime(); // Update time after each change
          },
          child: Text('- 30 Mins'),
        ),
        SizedBox(
          width: 16,
        ),
        ElevatedButton(
          onPressed: () {
            if (currentHour == 24 && currentMinute == 30) {
              setState(() {
                currentHour = 1;
                currentMinute = 0;
              });
            } else if (currentHour == 24 && currentMinute < 30) {
              setState(() {
                currentMinute = 30;
              });
            } else if (currentMinute < 30) {
              setState(() {
                currentMinute = 30;
              });
            } else if (currentMinute == 30) {
              setState(() {
                currentMinute = 0;
                currentHour +=
                    1; // Increment hour if adding 30 minutes makes it exceed 60 minutes
              });
            } else if (currentMinute == 0 || currentMinute == 00) {
              setState(() {
                currentMinute = 30;
              });
            }
            updateTime(); // Update time after each change
          },
          child: Text('+ 30 Mins'),
        ),
      ],
    );
  }

  void updateTime() {
    setState(() {
      currentTime =
          '$currentYear-$currentMonth-$currentDay $currentHour:${currentMinute.toString()}:${currentSecond.toString()}'; // Update currentTime
    });
    widget
        .onTimeChanged(currentTime); // Call the callback with the updated time
  }
}
