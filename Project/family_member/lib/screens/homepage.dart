import 'package:family_member/screens/complaints.dart';
import 'package:family_member/screens/view_complaint.dart';
import 'package:flutter/material.dart';
import 'view_health.dart'; // Import ViewHealth
import 'view_medappointments.dart'; // Import ViewMedappointments
import 'payment.dart'; // Import PaymentPage

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(230, 255, 252, 197),
      appBar: AppBar(
        title: const Text("Family Member Home"),
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
                // TODO: Navigate to Profile Page (Placeholder)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profile Page Coming Soon!")),
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
                  MaterialPageRoute(builder: (context) => const ViewHealth()),
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
                      builder: (context) => const ViewMedappointments()),
                );
              },
            ),
            _buildMenuButton(
              context,
              icon: Icons.payment,
              label: "Payment",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PaymentPage()),
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
                  MaterialPageRoute(builder: (context) => const ViewComplaint())
                );
              },
            ),
            const Spacer(),
            // _buildMenuButton(
            //   context,
            //   icon: Icons.logout,
            //   label: "Log Out",
            //   color: Colors.red,
            //   onPressed: () {
            //     // TODO: Implement actual log out logic
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       const SnackBar(content: Text("Logging Out...")),
            //     );
            //     // Navigate back to login (Assuming LoginScreen exists)
            //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ));
            //   },
            // ),
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 0, 36, 94),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
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
