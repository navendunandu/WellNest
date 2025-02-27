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

  @override
  void initState() {
    super.initState();
    NotificationService.init();
    fetchAndScheduleRoutine();
  }

  Future<void> fetchAndScheduleRoutine() async {
    final response = await supabase.from('tbl_routine').select().single();
    
    if (response != null) {
      List<String> routineNames = [
        'Wake Time', 'Breakfast Time', 'Lunch Time', 'Exercise Time',
        'Call Time', 'Dinner Time', 'Sleep Time'
      ];

      List<String> routineKeys = [
        'routine_waketime', 'routine_bftime', 'routine_lunchtime',
        'routine_exercisetime', 'routine_calltime', 'routine_dinnertime', 'routine_sleeptime'
      ];

      for (int i = 0; i < routineKeys.length; i++) {
        if (response[routineKeys[i]] != null) {
          DateTime routineTime = DateTime.parse("2025-02-27 ${response[routineKeys[i]]}");
          NotificationService.scheduleNotification(i, routineNames[i], routineTime);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('View Routine')),
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
