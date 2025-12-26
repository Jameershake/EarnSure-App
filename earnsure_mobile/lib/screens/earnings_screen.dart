import 'package:flutter/material.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  String _selectedPeriod = 'month';

  final List<Map<String, dynamic>> _transactions = [
    {
      'id': '1',
      'jobTitle': 'House Painting',
      'amount': 5000,
      'status': 'completed',
      'date': '2025-10-30',
      'employer': 'Rajesh Kumar',
    },
    {
      'id': '2',
      'jobTitle': 'Plumbing Repair',
      'amount': 2000,
      'status': 'pending',
      'date': '2025-10-29',
      'employer': 'Mr. Singh',
    },
    {
      'id': '3',
      'jobTitle': 'Grocery Delivery',
      'amount': 500,
      'status': 'completed',
      'date': '2025-10-28',
      'employer': 'Local Store',
    },
    {
      'id': '4',
      'jobTitle': 'Website Development',
      'amount': 10000,
      'status': 'completed',
      'date': '2025-10-25',
      'employer': 'Tech Startup',
    },
    {
      'id': '5',
      'jobTitle': 'Data Entry Work',
      'amount': 3000,
      'status': 'completed',
      'date': '2025-10-20',
      'employer': 'ABC Company',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final totalEarnings =
        _transactions.fold<int>(0, (sum, t) => sum + (t['amount'] as int));
    final completedEarnings = _transactions
        .where((t) => t['status'] == 'completed')
        .fold<int>(0, (sum, t) => sum + (t['amount'] as int));
    final pendingEarnings = _transactions
        .where((t) => t['status'] == 'pending')
        .fold<int>(0, (sum, t) => sum + (t['amount'] as int));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Earnings'),
        backgroundColor: const Color(0xFF1E40AF),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Earnings Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Earnings',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹$totalEarnings',
                      style: const TextStyle(
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
                            Text(
                              'Completed',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹$completedEarnings',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pending',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹$pendingEarnings',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Quick Action Buttons
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.download,
                      label: 'Withdraw',
                      color: Colors.green,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Withdraw feature coming soon!'),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.history,
                      label: 'History',
                      color: Colors.blue,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Opening transaction history...'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Period Filter
              Text(
                'Transactions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _PeriodChip(
                      label: 'This Week',
                      isSelected: _selectedPeriod == 'week',
                      onTap: () {
                        setState(() => _selectedPeriod = 'week');
                      },
                    ),
                    const SizedBox(width: 8),
                    _PeriodChip(
                      label: 'This Month',
                      isSelected: _selectedPeriod == 'month',
                      onTap: () {
                        setState(() => _selectedPeriod = 'month');
                      },
                    ),
                    const SizedBox(width: 8),
                    _PeriodChip(
                      label: 'All Time',
                      isSelected: _selectedPeriod == 'all',
                      onTap: () {
                        setState(() => _selectedPeriod = 'all');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Transactions List
              ..._transactions.asMap().entries.map((entry) {
                final index = entry.key;
                final transaction = entry.value;
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: index == _transactions.length - 1 ? 0 : 12),
                  child: _TransactionCard(transaction: transaction),
                );
              }),

              const SizedBox(height: 24),

              // Bank Account Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFCD34D)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.account_balance, color: Colors.orange[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bank Account',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.orange[900],
                            ),
                          ),
                          Text(
                            'ICICI Bank - ****1234',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.edit, color: Colors.orange[700], size: 20),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// HELPER WIDGETS

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeriodChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFF1E40AF).withOpacity(0.2),
      side: BorderSide(
        color: isSelected ? const Color(0xFF1E40AF) : Colors.grey[300]!,
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const _TransactionCard({required this.transaction});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'completed':
        return 'Completed';
      case 'pending':
        return 'Pending';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.work_outline, color: Color(0xFF1E40AF)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['jobTitle'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  transaction['employer'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${transaction['amount']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(transaction['status']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _getStatusLabel(transaction['status']),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(transaction['status']),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
