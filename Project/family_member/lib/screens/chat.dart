import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Chat extends StatefulWidget {
  final String familyMemberId; // Family Member's ID
  final String caretakerId; // Caretaker's ID

  const Chat({super.key, required this.familyMemberId, required this.caretakerId});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    fetchMessages(); // Load chat history
    listenForMessages(); // Listen for new messages
  }

  /// Fetch chat history between the family member and caretaker
  Future<void> fetchMessages() async {
    final response = await supabase
        .from('messages')
        .select()
        .or('sender_id.eq.${widget.familyMemberId},receiver_id.eq.${widget.familyMemberId}')
        .order('timestamp', ascending: true);

    if (mounted) {
      setState(() {
        messages = List<Map<String, dynamic>>.from(response);
      });
    }
  }

  void listenForMessages() {
  // Listen for messages where the family member is the receiver
  supabase
      .from('messages')
      .stream(primaryKey: ['message_id'])
      .eq('receiver_id', widget.familyMemberId)
      .listen((snapshot) {
    if (mounted) {
      setState(() {
        messages.addAll(snapshot);
      });
    }
  });

  // Listen for messages where the family member is the sender
  supabase
      .from('messages')
      .stream(primaryKey: ['message_id'])
      .eq('sender_id', widget.familyMemberId)
      .listen((snapshot) {
    if (mounted) {
      setState(() {
        messages.addAll(snapshot);
      });
    }
  });
}


  /// Send a new message
  Future<void> sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    await supabase.from('messages').insert({
      'sender_id': widget.familyMemberId,
      'receiver_id': widget.caretakerId,
      'content': messageText,
      'timestamp': DateTime.now().toIso8601String(),
    });

    _messageController.clear(); // Clear input field
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: false,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message['sender_id'] == widget.familyMemberId;

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message['content'],
                      style: TextStyle(color: isMe ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
