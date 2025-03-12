import 'package:family_member/screens/view_caretaker.dart';
import 'package:family_member/screens/view_complaint.dart';
import 'package:family_member/screens/view_profile.dart';
import 'package:flutter/material.dart';
import 'view_health.dart'; // Import ViewHealth
import 'view_medappointments.dart'; // Import ViewMedappointments
import 'payment.dart'; // Import PaymentPage

class HomePage extends StatelessWidget {
  String profile;
   HomePage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(230, 255, 252, 197),
      appBar: AppBar(
        title: const Text("Homepage"),
        backgroundColor: const Color.fromARGB(255, 0, 36, 94),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            _buildMenuButton(
              context,
              icon: Icons.person,
              label: "View Profile",
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewProfile(
                  profile: profile,
                ),));
              },
            ),
            _buildMenuButton(
              context,
              icon: Icons.person_2_outlined,
              label: "View Caretaker",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewCaretaker(
                    resId: profile,
                  )),
                );
              },
            ),
            _buildMenuButton(
              context,
              icon: Icons.medical_services,
              label: "Health Record",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewHealth(
                    profile: profile,
                  )),
                );
              },
            ),
            _buildMenuButton(
              context,
              icon: Icons.calendar_today,
              label: "Medical Appointment",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewMedappointments(
                        profile:profile,
                      )),
                );
              },
            ),
            _buildMenuButton(
              context,
              icon: Icons.payment,
              label: "Pay Now",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentPage(residentId: profile)),
                );
              },
            ),
            _buildMenuButton(
              context,
              icon: Icons.feedback,
              label: "Complaint",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewComplaint(
                  ))
                );
              },
            ),
            const Spacer(),
           
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color color = Colors.white,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 0, 36, 94),
          borderRadius: BorderRadius.circular(12),),
          
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
      
      ),
    );
  }
}
