import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference<Map<String, dynamic>> _messagesCollection;
  late StreamSubscription<QuerySnapshot> _messagesSubscription;

  @override
  void initState() {
    super.initState();
    _messagesCollection = _firestore.collection('messages');
    _messagesSubscription = _messagesCollection.snapshots().listen((snapshot) {
      // Update the UI with the latest messages
      setState(() {});
    });
  }

  @override
  void dispose() {
    _messagesSubscription.cancel();
    super.dispose();
  }

  void _sendMessage() async {
    final messageText = _textController.text.trim();
    if (messageText.isNotEmpty) {
      try {
        // Add the message to Firestore
        await _messagesCollection.add({
          'text': messageText,
          'timestamp': FieldValue.serverTimestamp(),
          'sender': 'currentUser', // Replace with actual user ID
        });

        // Clear the text field
        _textController.clear();
      } catch (error) {
        // Handle errors
        print('Error sending message: $error');
      }
    }
  }

  // ... (rest of the code from the previous example)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading messages'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs.reversed;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages.elementAt(index).data()
                        as Map<String, dynamic>;

                    final messageText = message['text'];
                    final messageSender = message['sender'];
                    final messageTimestamp = message['timestamp'] as Timestamp?;

                    return MessageBubble(
                      text: messageText,
                      sender: messageSender,
                      isMe: messageSender ==
                          'currentUser', // Adjust for actual user ID
                      timestamp: messageTimestamp,
                    );
                  },
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message',
                  ),
                ),
              ),
              IconButton(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;
  final Timestamp? timestamp;

  const MessageBubble({
    super.key,
    required this.text,
    required this.sender,
    required this.isMe,
    this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isMe ? 30 : 0),
              topRight: Radius.circular(isMe ? 0 : 30),
              bottomLeft: const Radius.circular(30),
              bottomRight: const Radius.circular(30),
            ),
            elevation: 5,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          Text(
            // Format the timestamp as desired
            '${DateTime.fromMillisecondsSinceEpoch(timestamp?.millisecondsSinceEpoch ?? 2).toLocal()}',
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
