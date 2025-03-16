import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewMedappointment extends StatefulWidget {
  String residentId;
  ViewMedappointment({super.key, required this.residentId});

  @override
  State<ViewMedappointment> createState() => _ViewMedappointmentState();
}

class _ViewMedappointmentState extends State<ViewMedappointment> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> appointments = [];

  Future<void> fetchAppointments() async {
    final response = await supabase
        .from('tbl_appointment')
        .select()
        .eq('resident_id', widget.residentId)
        .order('appointment_date', ascending: false);
    setState(() {
      appointments = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(230, 255, 252, 197),
        appBar: AppBar(
          title: const Text(
            'View Appointments',
            style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
                fontSize: 23),
          ),
          backgroundColor: Color.fromARGB(255, 0, 36, 94),
          foregroundColor: Colors.white,
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  appointments.isEmpty
                      ? const Center(
                          child: Text("No Appointments Available",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)))
                      : Expanded(
                          child: ListView.builder(
                            itemCount: appointments.length,
                            itemBuilder: (context, index) {
                              final appointment = appointments[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  title: Text(
                                      "Dr. ${appointment['appointment_name']}"),
                                  subtitle: Text(
                                    "Date: ${appointment['appointment_date']}\n"
                                    "Time: ${appointment['appointment_time']}",
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ])));
  }
}
