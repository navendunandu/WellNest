import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FamilyMember extends StatefulWidget {
  final String residentId;
  const FamilyMember({super.key, required this.residentId});

  @override
  State<FamilyMember> createState() => _FamilyMemberState();
}

class _FamilyMemberState extends State<FamilyMember> {
  final supabase = Supabase.instance.client;
  Map<String, dynamic>? familyMemberData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFamilyMemberDetails();
  }

  Future<void> fetchFamilyMemberDetails() async {
    try {
      // Step 1: Fetch familymember_id from tbl_resident
      final residentResponse = await supabase
          .from('tbl_resident')
          .select('familymember_id')
          .eq('resident_id', widget.residentId)
          .maybeSingle();

      if (residentResponse == null ||
          residentResponse['familymember_id'] == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final String familyMemberId = residentResponse['familymember_id'];

      // Step 2: Fetch family member details from tbl_familymember
      final familyResponse = await supabase
          .from('tbl_familymember')
          .select('*')
          .eq('familymember_id', familyMemberId)
          .maybeSingle();

      setState(() {
        familyMemberData = familyResponse;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching family member details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Family Member Details')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : familyMemberData == null
              ? const Center(child: Text('No family member found'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${familyMemberData!['familymember_name']}',
                          style: TextStyle(fontSize: 18)),
                      Text('Email: ${familyMemberData!['familymember_email']}',
                          style: TextStyle(fontSize: 18)),
                      Text('Phone: ${familyMemberData!['familymember_contact']}',
                          style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
    );
  }
}
