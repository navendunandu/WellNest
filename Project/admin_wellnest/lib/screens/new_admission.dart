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
      final response =
          await supabase.from('tbl_resident').select().eq('resident_status', 0);
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

  void confirmAction(String residentId, int status, String action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$action Resident'),
          content: Text('Are you sure you want to $action this resident?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                updateResidentStatus(residentId, status);
                Navigator.of(context).pop();
              },
              child: Text(action),
            ),
          ],
        );
      },
    );
  }

  void accept(String residentId) => confirmAction(residentId, 1, 'Accept');

  void reject(String residentId) => confirmAction(residentId, 2, 'Reject');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color.fromARGB(255, 227, 242, 253),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(51),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(8),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: const Color(0xFFEEEEEE),
          dataTableTheme: DataTableThemeData(
            headingTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 24, 56, 111),
              fontSize: 16,
            ),
            dataTextStyle: const TextStyle(
              color: Color(0xFF333333),
              fontSize: 14,
            ),
          ),
        ),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            const Color(0xFFF5F7FA),
          ),
          dataRowColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return const Color(0xFFE8F0FE);
              }
              return Colors.transparent;
            },
          ),
          horizontalMargin: 20,
          columnSpacing: 25,
          dividerThickness: 1,
          border: TableBorder(
            horizontalInside: BorderSide(
              width: 1,
              color: Colors.grey.withAlpha(51),
            ),
            top: BorderSide(
              width: 1,
              color: Colors.grey.withAlpha(51),
            ),
            bottom: BorderSide(
              width: 1,
              color: Colors.grey.withAlpha(51),
            ),
          ),
          showBottomBorder: true,
          columns: const [
            DataColumn(label: Text("Sl.No")),
            DataColumn(label: Text("Resident Name")),
            DataColumn(label: Text("Room ID")),
            DataColumn(label: Text("Relation ID")),
            DataColumn(label: Text("Contact")),
            DataColumn(label: Text("Email")),
            DataColumn(label: Text("Action")),
          ],
          rows: _filetypeList.asMap().entries.map((entry) {
            return DataRow(
              color: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  return entry.key % 2 == 0
                      ? const Color(0xFFFAFAFA)
                      : Colors.white;
                },
              ),
              cells: [
                DataCell(Text((entry.key + 1).toString())),
                DataCell(Text(entry.value['resident_name'].toString())),
                DataCell(Text(entry.value['room_id'].toString())),
                DataCell(Text(entry.value['relation_id'].toString())),
                DataCell(Text(entry.value['resident_contact'].toString())),
                DataCell(Text(entry.value['resident_email'].toString())),
                DataCell(Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () =>
                          accept(entry.value['resident_id'].toString()),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () =>
                          reject(entry.value['resident_id'].toString()),
                    ),
                  ],
                )),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
