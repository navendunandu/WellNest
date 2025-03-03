import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageComplaints extends StatefulWidget {
  const ManageComplaints({super.key});

  @override
  _ManageComplaintsState createState() => _ManageComplaintsState();
}

class _ManageComplaintsState extends State<ManageComplaints> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> complaints = [];
  final Map<int, TextEditingController> _replyControllers = {};

  @override
  void initState() {
    super.initState();
    _fetchComplaints();
  }

  Future<void> _fetchComplaints() async {
    final response = await supabase.from('tbl_complaint').select('*');
    setState(() {
      complaints = response;
    });
  }

  Future<void> _submitReply(int complaintId) async {
    final replyText = _replyControllers[complaintId]?.text.trim();
    if (replyText != null && replyText.isNotEmpty) {
      await supabase.from('tbl_complaint').update(
          {'complaint_reply': replyText}).eq('complaint_id', complaintId);
      _replyControllers[complaintId]?.clear();
      _fetchComplaints();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: complaints.length,
      itemBuilder: (context, index) {
        final complaint = complaints[index];
        final complaintId = complaint['complaint_id'];
        _replyControllers.putIfAbsent(
            complaintId, () => TextEditingController());

        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title: ${complaint['complaint_title']}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Date: ${complaint['complaint_date']}'),
                Text('Priority: ${complaint['complaint_priority']}'),
                Text('Content: ${complaint['complaint_content']}'),
                const SizedBox(height: 10),
                TextField(
                  controller: _replyControllers[complaintId],
                  decoration: InputDecoration(
                    labelText: 'Reply',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _submitReply(complaintId),
                  child: const Text('Submit Reply'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
