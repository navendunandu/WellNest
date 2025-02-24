import 'package:admin_wellnest/main.dart';
import 'package:admin_wellnest/screens/assign_caretaker.dart';
import 'package:flutter/material.dart';

class ManageResident extends StatefulWidget {
  const ManageResident({super.key});

  @override
  State<ManageResident> createState() => _ManageResidentState();
}

class _ManageResidentState extends State<ManageResident> {
  List<Map<String, dynamic>> _filetypeList = [];

  @override
  void initState() {
    super.initState();
    fetchFiletype();
  }

  Future<void> fetchFiletype() async {
    try {
      final response =
          await supabase.from('tbl_resident').select().gt('resident_status', 0).neq('resident_status', 2);
      setState(() {
        _filetypeList = response;
      });
    } catch (e) {
      print("ERROR FETCHING FILE TYPE DATA: $e");
    }
  }
  Future<void> updateResidentStatus(String residentId, int status) async {
    try {
      await supabase.from('tbl_resident').update(
          {'resident_status': status}).match({'resident_id': residentId});
      fetchFiletype();
    } catch (e) {
      print("ERROR UPDATING RESIDENT STATUS: $e");
    }
  }
void paymentVerify(String residentId) {
    updateResidentStatus(residentId, 3);
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
        columns: const [
          DataColumn(label: Text("Sl.No")),
          DataColumn(label: Text("Resident_Name")),
          DataColumn(label: Text("Room_ID")),
          DataColumn(label: Text("Relation_ID")),
          DataColumn(label: Text("Resident_Contact")),
          DataColumn(label: Text("Resident_Email")),
          DataColumn(label: Text("Action")),
        ],
        rows: _filetypeList.asMap().entries.map((entry) {
          print(entry.value);
          return DataRow(
            cells: [
            DataCell(Text((entry.key + 1).toString())),
            DataCell(Text(entry.value['resident_name'].toString())),
            DataCell(Text(entry.value['room_id'].toString())),
            DataCell(Text(entry.value['relation_id'].toString())),
            DataCell(Text(entry.value['resident_contact'].toString())),
            DataCell(Text(entry.value['resident_email'].toString())),
            DataCell(
              entry.value['resident_status'] == 1
                  ? Row(
                      children: [
                        Text("Payment Pending.."),
                        IconButton(
                          icon: Icon(Icons.verified),
                          onPressed: () {
                            paymentVerify(entry.value['resident_id'].toString());
                          },
                        ),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AssignCaretaker(id: entry.value['resident_id']),));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 24, 56, 111),
                        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Assign",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
            ),
          ]);
        }).toList());
  }
}