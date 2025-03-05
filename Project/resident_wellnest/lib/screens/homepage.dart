import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String? residentName;
  String? residentPhoto;

  @override
  void initState() {
    super.initState();
    fetchResidentData();
  }

  Future<void> fetchResidentData() async {
    try {
      final supabase = Supabase.instance.client;

      // Fetch the first resident (modify query as per your requirement)
      final response = await supabase
          .from('tbl_resident')
          .select('resident_name, resident_photo')
          .limit(1)
          .single();

      setState(() {
        residentName = response['resident_name'];
        residentPhoto = response['resident_photo'];
      });
    } catch (error) {
      print("Error fetching resident data: $error");
    }
  }

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
            Text(
              residentName != null ? "Welcome, $residentName!" : "Welcome!",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: residentPhoto != null
                  ? NetworkImage(residentPhoto!)
                  : const AssetImage('assets/default_avatar.png')
                      as ImageProvider,
            ),
            const SizedBox(height: 20),
            _buildMenuButton(
              context,
              icon: Icons.person,
              label: "View Profile",
              onPressed: () {},
            ),
            _buildMenuButton(
              context,
              icon: Icons.medical_services,
              label: "Health Record",
              onPressed: () {},
            ),
            _buildMenuButton(
              context,
              icon: Icons.calendar_today,
              label: "Medical Appointment",
              onPressed: () {},
            ),
            _buildMenuButton(
              context,
              icon: Icons.payment,
              label: "Pay Now",
              onPressed: () {},
            ),
            _buildMenuButton(
              context,
              icon: Icons.feedback,
              label: "Complaint",
              onPressed: () {},
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
          color: const Color.fromARGB(255, 0, 36, 94),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(10),
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
