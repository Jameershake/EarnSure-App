import 'package:flutter/material.dart';

class EmployerSpendingScreen extends StatelessWidget {
  const EmployerSpendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spending'),
        backgroundColor: const Color(0xFF1E40AF),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Spending Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Spent',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '₹87,500',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('This Month', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                          const SizedBox(height: 4),
                          const Text('₹25,000', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Jobs Posted', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                          const SizedBox(height: 4),
                          const Text('42', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recent Transactions
            Text(
              'Recent Payments',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                final transactions = [
                  ('House Painting', 'Rajesh Kumar', '₹5,000', '-'),
                  ('Website Dev', 'Tech Startup', '₹10,000', '-'),
                  ('Plumbing', 'Mr. Singh', '₹2,000', '-'),
                  ('Cleaning', 'Jane Doe', '₹3,500', '-'),
                  ('Delivery', 'Local Store', '₹4,500', '-'),
                ];
                final trans = transactions[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.red.withOpacity(0.1),
                          child: const Icon(Icons.payment, color: Colors.red),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(trans.$1, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                              Text(trans.$2, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                            ],
                          ),
                        ),
                        Text(trans.$3, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red)),
                      ],
                    ),
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
