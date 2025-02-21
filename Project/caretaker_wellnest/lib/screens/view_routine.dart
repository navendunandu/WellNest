import 'package:caretaker_wellnest/screens/update_routine.dart';
import 'package:flutter/material.dart';

class ViewRoutine extends StatefulWidget {
  const ViewRoutine({super.key});

  @override
  State<ViewRoutine> createState() => _ViewRoutineState();
}

class _ViewRoutineState extends State<ViewRoutine> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('View Routine'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UpdateRoutine()),
                );
              },
              child: const Text('Update Routine'),
            ),
        ],
      ),
    );
  }
}