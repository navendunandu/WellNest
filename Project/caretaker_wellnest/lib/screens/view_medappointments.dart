import 'package:caretaker_wellnest/screens/update_medappointments.dart';
import 'package:flutter/material.dart';

class ViewMedappointments extends StatefulWidget {
  const ViewMedappointments({super.key});

  @override
  State<ViewMedappointments> createState() => _ViewMedappointmentsState();
}

class _ViewMedappointmentsState extends State<ViewMedappointments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Appointments'),
      
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
                MaterialPageRoute(builder: (context) => UpdateMedappointments()),
              );
            },
            child: const Text('Update Appointments'),
          ),
        ]
      )
    );
  }
}