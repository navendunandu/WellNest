import 'package:caretaker_wellnest/main.dart';
import 'package:flutter/material.dart';
import 'view_routine.dart';
import 'view_medication.dart';
import 'view_health.dart';
import 'view_medappointments.dart';

class ResidentProfile extends StatefulWidget {
  String resident;
   ResidentProfile({super.key, required  this.resident});

  @override
  State<ResidentProfile> createState() => _ResidentProfileState();
}

class _ResidentProfileState extends State<ResidentProfile> {

  String name="";
  String dob="";
  String photo="";

Future<void> fetchresident() async
{
  try {
    final response=await supabase.from('tbl_resident').select().eq('resident_id', widget.resident).single();
    setState(() {
      name=response['resident_name'];
      photo=response['resident_photo'];
      dob=response['resident_dob'];
    });
  } catch (e) {
    print('Error is: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(230, 255, 252, 197), // Background color
      appBar: AppBar(
        title: Text('Resident Profile', style: TextStyle(color: Color.fromARGB(230, 255, 252, 197)), ),
        backgroundColor: const Color.fromARGB(255, 6, 28, 65),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.network(
                      photo, 
                      fit: BoxFit.cover,
                      width: 120,
                      height: 120,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [const Color.fromARGB(255, 160, 180, 231), const Color.fromARGB(255, 5, 33, 75)],
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       Text(
                        name, 
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Age: 75',
                        style: TextStyle(fontSize: 18, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildOptionButton('Manage Routine', Color.fromARGB(255, 87, 113, 157), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewRoutine()),
                );
              }),
              _buildOptionButton('Manage Medication', const Color.fromARGB(255, 44, 71, 118), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ViewMedication()),
                );
              }),
              _buildOptionButton('Manage Health Record', const Color.fromARGB(255, 24, 54, 105),
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewHealth()),
                );
              }),
              _buildOptionButton('Manage Appointments', const Color.fromARGB(255, 6, 28, 65),
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ViewMedappointments()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(String text, Color color, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, color: Color.fromARGB(230, 255, 252, 197)),
        ),
      ),
    );
  }
}
