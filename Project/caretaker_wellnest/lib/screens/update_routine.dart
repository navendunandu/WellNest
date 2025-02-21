import 'package:flutter/material.dart';

class UpdateRoutine extends StatefulWidget {
  const UpdateRoutine({super.key});

  @override
  State<UpdateRoutine> createState() => _UpdateRoutineState();
}

class _UpdateRoutineState extends State<UpdateRoutine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Routine'),
      ),
      body: Column(
        children: [
          Text('Routine Data'),
          
          
        ],
      ),
    );
  }
}