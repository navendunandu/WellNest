import 'package:admin_wellnest/main.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewAdmission extends StatefulWidget {
  const NewAdmission({super.key});

  @override
  State<NewAdmission> createState() => _NewAdmissionState();
}

class _NewAdmissionState extends State<NewAdmission> {
  List<Map<String, dynamic>> _filetypeList = [];

  @override
  void initState() {
    super.initState();
    fetchFiletype();
  }

  Future<void> fetchFiletype() async {
    try {
      final response = await supabase.from('tbl_resident').select();
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

  void accept(String residentId) {
    updateResidentStatus(residentId, 1);
  }

  void reject(String residentId) {
    updateResidentStatus(residentId, 2);
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
          return DataRow(cells: [
            DataCell(Text((entry.key + 1).toString())),
            DataCell(Text(entry.value['resident_name'].toString())),
            DataCell(Text(entry.value['room_id'].toString())),
            DataCell(Text(entry.value['relation_id'].toString())),
            DataCell(Text(entry.value['resident_contact'].toString())),
            DataCell(Text(entry.value['resident_email'].toString())),
            DataCell(Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    accept(entry.value['resident_id'].toString());
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.highlight_remove_outlined),
                  onPressed: () {
                    reject(entry.value['resident_id'].toString());
                  },
                ),
              ],
            )),
          ]);
        }).toList());
  }
}
