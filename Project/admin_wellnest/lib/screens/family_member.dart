import 'package:admin_wellnest/main.dart';
import 'package:flutter/material.dart';

class FamilyMember extends StatefulWidget {
  final String id;
  const FamilyMember({super.key, required this.id});

  @override
  State<FamilyMember> createState() => _FamilyMemberState();
}

class _FamilyMemberState extends State<FamilyMember> {
  bool isLoading = true;
  List<Map<String, dynamic>> familyMembers = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await supabase
          .from("tbl_familymember")
          .select()
          .eq("familymember_id", widget.id);

      print("Fetched family member data: $response");
      setState(() {
        familyMembers = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Family Members',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 24, 56, 111),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity, // Ensure container takes full width
        height: double.infinity, // Ensure container takes full height
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 227, 242, 253),
              Color.fromARGB(255, 227, 242, 253),
            ],
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : familyMembers.isEmpty
                ? const Center(child: Text('No family members found'))
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Family Member Details',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 24, 56, 111),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Card(
                                  elevation: 4,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      columnSpacing: 16,
                                      columns: const [
                                        DataColumn(label: Text('Name')),
                                        DataColumn(label: Text('Address')),
                                        DataColumn(label: Text('Contact')),
                                        DataColumn(label: Text('Email')),
                                        DataColumn(label: Text('Photo')),
                                      ],
                                      rows: familyMembers
                                          .map((member) => DataRow(
                                                cells: [
                                                  DataCell(Text(member[
                                                          'familymember_name'] ??
                                                      '')),
                                                  DataCell(Text(member[
                                                          'familymember_address'] ??
                                                      '')),
                                                  DataCell(Text(
                                                      member['familymember_contact']
                                                              .toString() ??
                                                          '')),
                                                  DataCell(Text(member[
                                                          'familymember_email'] ??
                                                      '')),
                                                  DataCell(
                                                    member['familymember_photo'] !=
                                                            null
                                                        ? Image.network(
                                                            member[
                                                                'familymember_photo'],
                                                            width: 50,
                                                            height: 50,
                                                            errorBuilder: (context,
                                                                    error,
                                                                    stackTrace) =>
                                                                const Icon(Icons
                                                                    .broken_image),
                                                          )
                                                        : const Text(
                                                            'No Photo'),
                                                  ),
                                                ],
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
