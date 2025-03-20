import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Chat extends StatefulWidget {
  final String familyMemberId;
  final String caretakerId;

  const Chat({
    super.key,
    required this.familyMemberId,
    required this.caretakerId,
  });

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  /// Initialize chat by fetching messages and setting up listener
  Future<void> _initializeChat() async {
    await fetchMessages();
    listenForMessages();
  }

  /// Fetch chat history between family member and caretaker
  Future<void> fetchMessages() async {
    try {
      final response = await supabase
          .from('tbl_chat')
          .select()
          .match({
            'chat_fromfid': widget.familyMemberId,
            'chat_tocid': widget.caretakerId,
          })
          .or(
            'chat_fromcid.eq.${widget.caretakerId},chat_tofid.eq.${widget.familyMemberId}',
          )
          .order('datetime', ascending: true);

      if (mounted) {
        setState(() {
          messages =
              response.map((msg) => Map<String, dynamic>.from(msg)).toList();
          isLoading = false; // Done loading
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false; // Stop loading even on error
        });
        print('Error fetching messages: $e'); // Log error for debugging
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load messages: $e')),
        );
      }
    }
  }

  /// Listen for new messages in real time
  void listenForMessages() {
    supabase
        .from('tbl_chat')
        .stream(primaryKey: ['chat_id'])
        .order('datetime', ascending: true)
        .listen((snapshot) {
          print('🔄 New snapshot received: $snapshot'); // Debugging line
          if (mounted) {
            setState(() {
              final filteredMessages = snapshot.where((message) {
                return (message['chat_fromfid'] == widget.familyMemberId &&
                        message['chat_tocid'] == widget.caretakerId) ||
                    (message['chat_fromcid'] == widget.caretakerId &&
                        message['chat_tofid'] == widget.familyMemberId);
              }).toList();

              for (var message in filteredMessages) {
                if (!messages
                    .any((msg) => msg['chat_id'] == message['chat_id'])) {
                  messages.add(Map<String, dynamic>.from(message));
                }
              }
            });
          }
        })
        .onError((error) {
          print('Stream error: $error'); // Log stream errors
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Stream error: $error')),
            );
          }
        });
  }

  /// Send a new message
  Future<void> sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    try {
      await supabase.from('tbl_chat').insert({
        'chat_fromcid': null,
        'chat_fromfid': widget.familyMemberId,
        'chat_tocid': widget.caretakerId,
        'chat_tofid': null,
        'chat_content': messageText,
        'datetime': DateTime.now().toIso8601String(),
      });
      _messageController.clear();
    } catch (e) {
      print('Error sending message: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : messages.isEmpty
                    ? const Center(child: Text('No messages yet'))
                    : ListView.builder(
                        reverse: false,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe =
                              message['chat_fromfid'] == widget.familyMemberId;

                          return Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color:
                                    isMe ? Colors.blueAccent : Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                message['chat_content'] ?? '',
                                style: TextStyle(
                                    color: isMe ? Colors.white : Colors.black),
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
