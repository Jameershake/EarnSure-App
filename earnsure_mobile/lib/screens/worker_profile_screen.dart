import 'package:flutter/material.dart';

class WorkerProfileScreen extends StatelessWidget {
  final Map<String, dynamic> worker;

  const WorkerProfileScreen({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Profile'),
        backgroundColor: const Color(0xFF1E40AF),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(
                      worker['name'][0],
                      style: const TextStyle(
                        fontSize: 40,
                        color: Color(0xFF1E40AF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    worker['name'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                      Text(
                        ' ${worker['rating']} (${worker['reviews']} reviews)',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Info Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bio
                  Text(
                    'About',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Text(
                      worker['bio'],
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Stats
                  Text(
                    'Statistics',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _StatBox('Jobs Completed', '${45 + int.parse(worker['reviews'].toString())}'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatBox('Repeat Clients', '12'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Location
                  Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red[700]),
                        const SizedBox(width: 12),
                        Text(
                          worker['location'],
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Reviews Section
                  Text(
                    'Recent Reviews',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._buildReviews(),

                  const SizedBox(height: 20),

                  // Action Buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Opening chat with ${worker['name']}'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E40AF),
                      ),
                      child: const Text('Send Message'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added ${worker['name']} to favorites'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text('Add to Favorites'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildReviews() {
    final reviews = [
      {
        'name': 'John Doe',
        'rating': 5.0,
        'comment': 'Excellent work! Very professional'
      },
      {
        'name': 'Jane Smith',
        'rating': 4.5,
        'comment': 'Good quality, would hire again'
      },
    ];

    return reviews.map((review) {
      final rating = review['rating'] as double;
      final name = review['name'] as String;
      final comment = review['comment'] as String;

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: i < rating.toInt()
                            ? Colors.amber
                            : Colors.grey[300],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                comment,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _StatBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E40AF),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
