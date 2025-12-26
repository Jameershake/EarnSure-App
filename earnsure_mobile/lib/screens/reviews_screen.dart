import 'package:flutter/material.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  final List<Map<String, dynamic>> reviews = const [
    {
      'id': '1',
      'reviewer': 'Rajesh Kumar',
      'rating': 4.5,
      'comment': 'Excellent work! Very professional and timely.',
      'date': '2025-10-30',
      'avatar': 'R',
    },
    {
      'id': '2',
      'reviewer': 'Tech Startup',
      'rating': 5.0,
      'comment': 'Perfect! Delivered exactly as required.',
      'date': '2025-10-28',
      'avatar': 'T',
    },
    {
      'id': '3',
      'reviewer': 'Mr. Singh',
      'rating': 4.0,
      'comment': 'Good work. Would hire again.',
      'date': '2025-10-25',
      'avatar': 'S',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final avgRating = reviews.fold<double>(
          0,
          (sum, r) => sum + (r['rating'] as double),
        ) /
        reviews.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
        backgroundColor: const Color(0xFF1E40AF),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: const Color(0xFF1E40AF).withOpacity(0.05),
              child: Column(
                children: [
                  Text(
                    avgRating.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.star_rounded,
                        color: index < avgRating.toInt()
                            ? Colors.amber
                            : Colors.grey[300],
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${reviews.length} reviews',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFF1E40AF),
                            child: Text(
                              review['avatar'],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review['reviewer'],
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Row(
                                  children: [
                                    ...List.generate(
                                      5,
                                      (i) => Icon(
                                        Icons.star_rounded,
                                        size: 14,
                                        color: i < (review['rating'] as double).toInt()
                                            ? Colors.amber
                                            : Colors.grey[300],
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      review['date'],
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        review['comment'],
                        style: TextStyle(color: Colors.grey[700], height: 1.5),
                      ),
                      const SizedBox(height: 16),
                      Divider(color: Colors.grey[200]),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
