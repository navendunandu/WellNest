import 'package:flutter/material.dart';
import 'complaints.dart'; // Import the Complaints page

class ViewComplaint extends StatelessWidget {
  const ViewComplaint({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(230, 255, 252, 197),
      appBar: AppBar(
        title: const Text("View Complaints", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 0, 36, 94),
        elevation: 4,
        shadowColor: Colors.black45,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 8,
            shadowColor: Colors.black45,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Your Complaints",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Placeholder for complaints list
                  Expanded(
                    child: ListView.builder(
                      itemCount: 5, // Change this dynamically when fetching real data
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            title: Text("Complaint #${index + 1}"),
                            subtitle: const Text("Complaint description goes here..."),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // Floating "New" Button at Bottom
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Complaints()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 0, 36, 94),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
