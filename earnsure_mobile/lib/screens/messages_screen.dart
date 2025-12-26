import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  final List<Map<String, dynamic>> conversations = const [
    {
      'id': '1',
      'name': 'Rajesh Kumar',
      'message': 'Great work on the painting!',
      'time': '10:30 AM',
      'avatar': 'R',
      'unread': true,
    },
    {
      'id': '2',
      'name': 'Tech Startup',
      'message': 'Can you start next Monday?',
      'time': '09:15 AM',
      'avatar': 'T',
      'unread': false,
    },
    {
      'id': '3',
      'name': 'Mr. Singh',
      'message': 'Thank you for the quick response',
      'time': 'Yesterday',
      'avatar': 'S',
      'unread': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: const Color(0xFF1E40AF),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conv = conversations[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF1E40AF),
              child: Text(
                conv['avatar'],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(conv['name']),
            subtitle: Text(
              conv['message'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(conv['time'], style: const TextStyle(fontSize: 12)),
                if (conv['unread'])
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening chat with ${conv['name']}')),
              );
            },
          );
        },
      ),
    );
  }
}
