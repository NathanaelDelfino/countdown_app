import 'package:countdown_app/constaints/containts.dart';
import 'package:countdown_app/homepage/controller/countdown_controller.dart';
import 'package:countdown_app/homepage/domain/entity/countdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonAddNewCountdown extends StatelessWidget {
  const ButtonAddNewCountdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const FormToCreateCountdown(),
        );
      },
      child: const Icon(Icons.add),
    );
  }
}

class FormToCreateCountdown extends StatefulWidget {
  const FormToCreateCountdown({
    Key? key,
  }) : super(key: key);

  @override
  State<FormToCreateCountdown> createState() => _FormToCreateCountdownState();
}

class _FormToCreateCountdownState extends State<FormToCreateCountdown> {
  TextEditingController titleController = TextEditingController(text: "");
  DateTime dateTime = DateTime.now();
  TimeOfDay timeOfDay = TimeOfDay.now();

  void setDateTime({DateTime? date, TimeOfDay? time}) {
    final dateTime = date ?? this.dateTime;
    final timeOfDay = time ?? this.timeOfDay;
    setState(() {
      this.dateTime = DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        timeOfDay.hour,
        timeOfDay.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add new countdown',
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final dateTime = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: kLastDateDateTimePicker,
                      );
                      if (dateTime != null) {
                        setDateTime(date: dateTime);
                      }
                    },
                    icon: const Icon(Icons.calendar_month),
                    label: const Text("Date"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final timeOfDay = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        initialEntryMode: TimePickerEntryMode.dial,
                      );
                      if (timeOfDay != null) {
                        setDateTime(time: timeOfDay);
                      }
                    },
                    icon: const Icon(Icons.access_time),
                    label: const Text("Time"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Provider.of<CountdownController>(context, listen: false)
                    .addCountdown(
                  Countdown(
                    title: titleController.text,
                    date: dateTime,
                  ),
                );
                Navigator.of(context).pop();
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}
