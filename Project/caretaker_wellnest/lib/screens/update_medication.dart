import 'package:flutter/material.dart';

class UpdateMedication extends StatefulWidget {
  const UpdateMedication({super.key});

  @override
  State<UpdateMedication> createState() => _UpdateMedicationState();
}

class _UpdateMedicationState extends State<UpdateMedication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Medication'),
      ),
      body: Column(
        children: [
          Text('Medication Data'),
          
          
        ],
      ),
    );
  }
}