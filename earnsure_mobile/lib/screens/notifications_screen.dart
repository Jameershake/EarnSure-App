import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  final List<Map<String, dynamic>> notifications = const [
    {
      'id': '1',
      'title': 'Job Accepted!',
      'message': 'Your application for House Painting was accepted',
      'time': '2 hours ago',
      'icon': Icons.check_circle,
      'color': Colors.green,
    },
    {
      'id': '2',
      'title': 'New Job Posted',
      'message': 'Website Development - ₹25000',
      'time': '4 hours ago',
      'icon': Icons.work,
      'color': Colors.blue,
    },
    {
      'id': '3',
      'title': 'Payment Received',
      'message': '₹5000 added to your wallet',
      'time': '1 day ago',
      'icon': Icons.account_balance_wallet,
      'color': Colors.green,
    },
    {
      'id': '4',
      'title': 'Application Rejected',
      'message': 'Your application was not selected',
      'time': '2 days ago',
      'icon': Icons.close,
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFF1E40AF),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All marked as read')),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: (notif['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      notif['icon'] as IconData,
                      color: notif['color'] as Color,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notif['title'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notif['message'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notif['time'],
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
