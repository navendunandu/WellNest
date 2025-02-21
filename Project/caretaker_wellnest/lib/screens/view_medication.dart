import 'package:caretaker_wellnest/screens/update_medication.dart';
import 'package:flutter/material.dart';

class ViewMedication extends StatefulWidget {
  const ViewMedication({super.key});

  @override
  State<ViewMedication> createState() => _ViewMedicationState();
}

class _ViewMedicationState extends State<ViewMedication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Medication'),
      
      ),
      body: Column(
        children: [
          SizedBox(height: 24),
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
                MaterialPageRoute(builder: (context) => UpdateMedication()),
              );
            },
            child: const Text('Update medication'),
          ),
        ]
      )
    );
  }
}