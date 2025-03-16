import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FamProfile extends StatefulWidget {
  final String familymemberID;

  const FamProfile({super.key, required this.familymemberID});

  @override
  State<FamProfile> createState() => _FamProfileState();
}

class _FamProfileState extends State<FamProfile> {
  final SupabaseClient supabase = Supabase.instance.client;
  Map<String, dynamic>? familyData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFamilyProfile();
  }

  Future<void> fetchFamilyProfile() async {
    final response = await supabase
        .from('tbl_familymember')
        .select()
        .eq('familymember_id', widget.familymemberID)
        .maybeSingle();

    if (mounted) {
      setState(() {
        familyData = response;
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
          'Family Member Profile',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 36, 94),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ?Center(child: Text("No profile found"))
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
                      child: _buildViewProfile(),
                    ),
                  ),
                ),
    );
  }

  Widget _buildViewProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundImage: familyData!['familymember_photo'] != null
                ? NetworkImage(familyData!['familymember_photo'])
                : const AssetImage('assets/default_avatar.png')
                    as ImageProvider,
          ),
        ),
        const SizedBox(height: 20),
        profileRow("Name", familyData!['familymember_name'] ?? 'N/A'),
        profileRow("Email", familyData!['familymember_email'] ?? 'N/A'),
        profileRow("Address", familyData!['familymember_address'] ?? 'N/A'),
        profileRow("Phone", familyData!['familymember_contact'].toString() ?? 'N/A'),
      ],
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
