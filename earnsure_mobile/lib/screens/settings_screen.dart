import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF1E40AF),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          // Notifications
          ListTile(
            leading: const Icon(Icons.notifications_outlined, color: Color(0xFF1E40AF)),
            title: const Text('Notifications'),
            trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notification settings')),
              );
            },
          ),
          const Divider(),

          // Language
          ListTile(
            leading: const Icon(Icons.language, color: Color(0xFF1E40AF)),
            title: const Text('Language'),
            trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Language settings')),
              );
            },
          ),
          const Divider(),

          // Privacy Policy
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined, color: Color(0xFF1E40AF)),
            title: const Text('Privacy Policy'),
            trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy Policy')),
              );
            },
          ),
          const Divider(),

          // Terms & Conditions
          ListTile(
            leading: const Icon(Icons.description_outlined, color: Color(0xFF1E40AF)),
            title: const Text('Terms & Conditions'),
            trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Terms & Conditions')),
              );
            },
          ),
          const Divider(),

          // About
          ListTile(
            leading: const Icon(Icons.info_outlined, color: Color(0xFF1E40AF)),
            title: const Text('About EarnSure'),
            trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('EarnSure v1.0.0')),
              );
            },
          ),
          const Divider(),

          // Version
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                'App Version 1.0.0',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
