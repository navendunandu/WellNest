import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              "Admin Dashboard",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                MetricCard(title: "Total Residents", value: "120", icon: Icons.people),
                MetricCard(title: "Total Caretakers", value: "15", icon: Icons.medical_services),
                MetricCard(title: "Pending Bookings", value: "5", icon: Icons.book),
                MetricCard(title: "Pending Payments", value: "3", icon: Icons.payment),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: [
                ActionButton(icon: Icons.people, label: "Manage Residents", onPressed: () {}),
                ActionButton(icon: Icons.medical_services, label: "Manage Caretakers", onPressed: () {}),
                ActionButton(icon: Icons.book, label: "View Bookings", onPressed: () {}),
                ActionButton(icon: Icons.payment, label: "View Payments", onPressed: () {}),
                ActionButton(icon: Icons.feedback, label: "View Feedback", onPressed: () {}),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Recent Bookings",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DataTable(
              columns: const [
                DataColumn(label: Text("Resident Name")),
                DataColumn(label: Text("Booking Date")),
                DataColumn(label: Text("Status")),
              ],
              rows: const [
                DataRow(cells: [
                  DataCell(Text("John Doe")),
                  DataCell(Text("2023-10-01")),
                  DataCell(Text("Pending")),
                ]),
                DataRow(cells: [
                  DataCell(Text("Jane Smith")),
                  DataCell(Text("2023-10-02")),
                  DataCell(Text("Approved")),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 40),
              Text(title, style: const TextStyle(fontSize: 16)),
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}