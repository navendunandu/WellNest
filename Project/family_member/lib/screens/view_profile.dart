import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewProfile extends StatefulWidget {
  final String profile; // Assuming this is the resident_id (UUID)

  const ViewProfile({super.key, required this.profile});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  final SupabaseClient supabase = Supabase.instance.client;
  Map<String, dynamic>? residentData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchResidentProfile();
  }

  Future<void> fetchResidentProfile() async {
    final response = await supabase
        .from('tbl_resident')
        .select()
        .eq('resident_id', widget.profile)
        .maybeSingle();

    if (mounted) {
      setState(() {
        residentData = response;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(230, 255, 252, 197),
      appBar: AppBar(
        title: const Text(
          'Resident Profile',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 36, 94),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : residentData == null
              ? const Center(child: Text("No profile found"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: residentData!['resident_photo'] == null
                                  ? NetworkImage(residentData!['resident_photo'])
                                  : const AssetImage(
                                          'assets/default_avatar.png')
                                      as ImageProvider,
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          SizedBox(
                            height: 20,
                          ),
                          profileRow("Name", residentData!['resident_name']),
                          profileRow(
                              "Address", residentData!['resident_address']),
                          profileRow("Contact",
                              residentData!['resident_contact'].toString()),
                          profileRow("Email", residentData!['resident_email']),
                          profileRow(
                              "Date of Birth", residentData!['resident_dob']),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget profileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color.fromARGB(255, 0, 36, 94),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
