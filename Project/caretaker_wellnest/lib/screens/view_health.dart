import 'package:caretaker_wellnest/screens/update_health.dart';
import 'package:flutter/material.dart';

class ViewHealth extends StatefulWidget {
  const ViewHealth({super.key});

  @override
  State<ViewHealth> createState() => _ViewHealthState();
}

class _ViewHealthState extends State<ViewHealth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Health'),
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
                  MaterialPageRoute(builder: (context) => const UpdateHealth()),
                );
              },
              child: const Text('Manage Record'),
            ),
          
        ],
      ),
    );
  }
}