import 'package:caretaker_wellnest/components/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

import 'update_medication.dart';

class ViewMedication extends StatefulWidget {
  const ViewMedication({super.key});

  @override
  State<ViewMedication> createState() => _ViewMedicationState();
}

class _ViewMedicationState extends State<ViewMedication> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> medications = [];

  @override
  void initState() {
    super.initState();
    fetchMedications();
  }

  Future<void> fetchMedications() async {
    try {
      final response = await supabase.from('tbl_medication').select();

      print("Supabase Response: $response"); // Debugging Output

      setState(() {
        medications = List<Map<String, dynamic>>.from(response);
      });

      if (medications.isEmpty) {
        print("No medications found in the database.");
      } else {
        print("Medications fetched successfully: $medications");
      }

      // Schedule notifications for medications
      for (var medication in medications) {
        scheduleNotification(medication);
      }
    } catch (error) {
      print("Error fetching medications: $error");
    }
  }

  void scheduleNotification(Map<String, dynamic> medication) {
    String time = medication['medication_timing']; // Format: HH:mm:ss
    int count = medication['medication_count'];
    String name = medication['medication_time']; // Medication Name

    DateTime now = DateTime.now();
    DateTime medicationDateTime = DateTime(
      now.year, now.month, now.day,
      int.parse(time.split(":")[0]), // Hour
      int.parse(time.split(":")[1]), // Minute
    );

    // Schedule a notification 10 minutes before the medication time
    DateTime reminderTime =
        medicationDateTime.subtract(const Duration(minutes: 10));

    if (reminderTime.isAfter(now)) {
      NotificationService.scheduleNotification(
        medicationDateTime.millisecondsSinceEpoch ~/ 1000, // Unique ID
        "Medication Reminder: $name",
        reminderTime,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View Medication')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            medications.isEmpty
                ? const Center(child: Text("No Medications Available"))
                : Expanded(
                    child: ListView.builder(
                      itemCount: medications.length,
                      itemBuilder: (context, index) {
                        final medication = medications[index];
                        String formattedTime = DateFormat('hh:mm a').format(
                            DateTime.parse(
                                "2000-01-01 ${medication['medication_timing']}"));
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                                "Medication: ${medication['medication_time']}"),
                            subtitle: Text(
                              "Time: $formattedTime\nCount: ${medication['medication_count']}",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 36, 94),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateMedication()),
                );
              },
              child: const Text(
                'Update Medication',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
