import 'package:caretaker_wellnest/components/notification_service.dart';
import 'package:caretaker_wellnest/screens/update_routine.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewRoutine extends StatefulWidget {
  const ViewRoutine({super.key});

  @override
  State<ViewRoutine> createState() => _ViewRoutineState();
}

class _ViewRoutineState extends State<ViewRoutine> {
  final supabase = Supabase.instance.client;
  Map<String, String> routineData = {}; // No default values

  @override
  void initState() {
    super.initState();
    NotificationService.init();
    fetchAndScheduleRoutine();
  }

  Future<void> fetchAndScheduleRoutine() async {
    try {
      final response = await supabase.from('tbl_routine').select().single();
      print("Fetched Routine Data: $response");

      if (response != null) {
        Map<String, String> tempData = {};

        Map<String, String> routineMapping = {
          'routine_waketime': 'Wake Time',
          'routine_bftime': 'Breakfast Time',
          'routine_lunchtime': 'Lunch Time',
          'routine_exercisetime': 'Exercise Time',
          'routine_calltime': 'Call Time',
          'routine_dinnertime': 'Dinner Time',
          'routine_sleeptime': 'Sleep Time'
        };

        response.forEach((key, value) {
          if (routineMapping.containsKey(key) && value != null) {
            tempData[routineMapping[key]!] = value;
          }
        });

        setState(() {
          routineData = tempData;
        });

        // Schedule notifications
        routineData.forEach((name, time) {
          try {
            DateTime routineTime = DateTime.parse("2025-02-27 $time");
            print("Scheduling notification for $name at $routineTime");
            NotificationService.scheduleNotification(
                routineData.keys.toList().indexOf(name), name, routineTime);
          } catch (e) {
            print("Error parsing time for $name: $e");
          }
        });
      }
    } catch (e) {
      print("Error fetching data from Supabase: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View Routine')),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: routineData.isEmpty
                ? const Center(child: Text("No routine data available."))
                : ListView.builder(
                    itemCount: routineData.length,
                    itemBuilder: (context, index) {
                      String routineName = routineData.keys.elementAt(index);
                      String routineTime = routineData.values.elementAt(index);
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(routineName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(routineTime),
                          leading:
                              const Icon(Icons.access_time, color: Colors.blue),
                        ),
                      );
                    },
                  ),
          ),
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
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
