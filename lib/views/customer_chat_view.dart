import 'package:flutter/material.dart';

class CustomerChatView extends StatefulWidget {
  const CustomerChatView({super.key});

  @override
  State<CustomerChatView> createState() => _CustomerChatViewState();
}

class _CustomerChatViewState extends State<CustomerChatView> {
  // Add variables for user input and chat messages if not using provider
  final List<String> _chatMessages = ["Issue-01", "Issue-02", "Issue-03", "Issue-04", "Issue-05"];
  // TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _chatMessages.length, // Replace with appropriate data length
                itemBuilder: (context, index) {
                  // Replace ChatMessage with your data model
                  // ChatMessage message = _chatMessages[index];
                  return _buildChatMessage(_chatMessages[index]);
                },
              ),
            ),
            // Add a text input and send button if not using provider
            // _buildChatInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatMessage(String message) {
    // Replace with your chat message UI implementation
    return ListTile(
      title: Text(message),
      // subtitle: Text(message.message),
      // trailing: Text(
      //   message.timestamp.toString(),
      // ),
    );
  }

  // Build a text input and send button if not using provider
  // Widget _buildChatInput() {
  //   return Padding(
  //     padding: EdgeInsets.all(8.0),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: TextField(
  //             controller: _messageController,
  //             decoration: InputDecoration(labelText: 'Enter your message...'),
  //           ),
  //         ),
  //         ElevatedButton(
  //           onPressed: _sendMessage,
  //           child: Text('Send'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Implement _sendMessage method if not using provider
  // void _sendMessage() {
  //   if (_messageController.text.trim().isNotEmpty) {
  //     ChatMessage newMessage = ChatMessage(
  //       // Construct your message object
  //       sender: 'You',
  //       message: _messageController.text.trim(),
  //       timestamp: DateTime.now(),
  //     );
  //     // Add logic to send the message or update the provider if applicable
  //     setState(() {
  //       _chatMessages.add(newMessage);
  //       _messageController.clear();
  //     });
  //   }
  // }
}
