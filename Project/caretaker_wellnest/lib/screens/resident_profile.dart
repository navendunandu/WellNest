import 'package:caretaker_wellnest/main.dart';
import 'package:flutter/material.dart';
import 'view_routine.dart';
import 'view_medication.dart';
import 'view_health.dart';
import 'view_medappointments.dart';

class ResidentProfile extends StatefulWidget {
  String resident;
  ResidentProfile({super.key, required this.resident});

  @override
  State<ResidentProfile> createState() => _ResidentProfileState();
}

class _ResidentProfileState extends State<ResidentProfile> {
  String name = "";
  String dob = "";
  String photo = "";
  String resident_age = "";
  String resident_id = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchresident();
  }

  Future<void> fetchresident() async {
    try {
      final response = await supabase
          .from('tbl_resident')
          .select()
          .eq('resident_id', widget.resident)
          .single();

      setState(() {
        name = response['resident_name'];
        photo = response['resident_photo'];
        dob = response[
            'resident_dob']; // Assuming this is a string in 'YYYY-MM-DD' format
        resident_age = _calculateAge(DateTime.parse(dob))
            .toString(); // Convert to DateTime & get age
        resident_id = response['resident_id'];
      });
    } catch (e) {
      print('Error is: $e');
    }
  }

  int _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--; // Adjust if birthday hasn't occurred this year
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(230, 255, 252, 197), // Background color
      appBar: AppBar(
        title: Text(
          'Resident Profile',
          style: TextStyle(color: Color.fromARGB(230, 255, 252, 197)),
        ),
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
                      colors: [
                        const Color.fromARGB(255, 160, 180, 231),
                        const Color.fromARGB(255, 5, 33, 75)
                      ],
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
                      Text(
                        resident_age,
                        style: TextStyle(fontSize: 18, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildOptionButton(
                  'Manage Routine', Color.fromARGB(255, 87, 113, 157), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewRoutine(
                            resident_id: resident_id,
                          )),
                );
              }),
              _buildOptionButton(
                  'Manage Medication', const Color.fromARGB(255, 44, 71, 118),
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewMedication(
                            resident_id: resident_id,
                          )),
                );
              }),
              _buildOptionButton('Manage Health Record',
                  const Color.fromARGB(255, 24, 54, 105), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewHealth(
                            resident_id: resident_id,
                          )),
                );
              }),
              _buildOptionButton(
                  'Manage Appointments', const Color.fromARGB(255, 6, 28, 65),
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewMedappointments(
                            resident_id: resident_id,
                          )),
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
          style: const TextStyle(
              fontSize: 18, color: Color.fromARGB(230, 255, 252, 197)),
        ),
      ),
    );
  }
}
