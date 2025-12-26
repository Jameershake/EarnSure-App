import 'package:flutter/material.dart';


class JobApplicantsScreen extends StatelessWidget {
  const JobApplicantsScreen({super.key});

  final List<Map<String, dynamic>> applicants = const [
    {
      'id': '1',
      'name': 'Rajesh Kumar',
      'rating': 4.5,
      'reviews': 45,
      'location': 'Delhi',
      'bio': 'Experienced painter with 5 years experience',
      'status': 'pending',
    },
    {
      'id': '2',
      'name': 'Priya Singh',
      'rating': 4.8,
      'reviews': 62,
      'location': 'Delhi',
      'bio': 'Professional painter, quality guaranteed',
      'status': 'accepted',
    },
    {
      'id': '3',
      'name': 'Amit Patel',
      'rating': 3.9,
      'reviews': 28,
      'location': 'Delhi',
      'bio': 'Affordable painting services',
      'status': 'pending',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Applicants'),
        backgroundColor: const Color(0xFF1E40AF),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: applicants.length,
        itemBuilder: (context, index) {
          final app = applicants[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xFF1E40AF),
                        child: Text(
                          app['name'][0],
                          style: const TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              app['name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                                Text(
                                  ' ${app['rating']} (${app['reviews']} reviews)',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: app['status'] == 'accepted'
                              ? Colors.green.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          app['status'] == 'accepted' ? 'Hired' : 'Pending',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: app['status'] == 'accepted' ? Colors.green : Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    app['bio'],
                    style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.5),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(app['location'], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('View profile')),
                            );
                          },
                          child: const Text('View Profile'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (app['status'] == 'pending')
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Hired ${app['name']}')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text('Hire'),
                          ),
                        ),
                    ],
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
