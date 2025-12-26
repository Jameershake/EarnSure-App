import 'package:flutter/material.dart';

class MyApplicationsScreen extends StatefulWidget {
  const MyApplicationsScreen({super.key});

  @override
  State<MyApplicationsScreen> createState() => _MyApplicationsScreenState();
}

class _MyApplicationsScreenState extends State<MyApplicationsScreen> {
  String _selectedFilter = 'all';

  final List<Map<String, dynamic>> _applications = [
    {
      'id': '1',
      'jobTitle': 'House Painting',
      'employer': 'Rajesh Kumar',
      'wage': 5000,
      'location': 'Delhi',
      'appliedDate': '2025-10-30',
      'status': 'accepted',
      'rating': 4.5,
      'image': '🏠',
    },
    {
      'id': '2',
      'jobTitle': 'Website Development',
      'employer': 'Tech Startup',
      'wage': 25000,
      'location': 'Bangalore',
      'appliedDate': '2025-10-29',
      'status': 'pending',
      'rating': 4.8,
      'image': '💻',
    },
    {
      'id': '3',
      'jobTitle': 'Plumbing Repair',
      'employer': 'Mr. Singh',
      'wage': 2000,
      'location': 'Mumbai',
      'appliedDate': '2025-10-28',
      'status': 'rejected',
      'rating': 4.2,
      'image': '🔧',
    },
    {
      'id': '4',
      'jobTitle': 'Grocery Delivery',
      'employer': 'Local Store',
      'wage': 500,
      'location': 'Delhi',
      'appliedDate': '2025-10-27',
      'status': 'accepted',
      'rating': 4.0,
      'image': '🛒',
    },
    {
      'id': '5',
      'jobTitle': 'Data Entry Work',
      'employer': 'ABC Company',
      'wage': 3000,
      'location': 'Remote',
      'appliedDate': '2025-10-20',
      'status': 'pending',
      'rating': 3.9,
      'image': '📊',
    },
  ];

  List<Map<String, dynamic>> _getFilteredApplications() {
    if (_selectedFilter == 'all') {
      return _applications;
    }
    return _applications
        .where((app) => app['status'] == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredApplications = _getFilteredApplications();
    final totalApplied = _applications.length;
    final accepted =
        _applications.where((app) => app['status'] == 'accepted').length;
    final pending =
        _applications.where((app) => app['status'] == 'pending').length;
    final rejected =
        _applications.where((app) => app['status'] == 'rejected').length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Applications'),
        backgroundColor: const Color(0xFF1E40AF),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: const Color(0xFF1E40AF).withOpacity(0.05),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Applied',
                            value: totalApplied.toString(),
                            color: Colors.blue,
                            icon: Icons.send,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            title: 'Accepted',
                            value: accepted.toString(),
                            color: Colors.green,
                            icon: Icons.check_circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Pending',
                            value: pending.toString(),
                            color: Colors.orange,
                            icon: Icons.schedule,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            title: 'Rejected',
                            value: rejected.toString(),
                            color: Colors.red,
                            icon: Icons.close,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filter Applications',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _FilterChip(
                            label: 'All',
                            isSelected: _selectedFilter == 'all',
                            onTap: () {
                              setState(() => _selectedFilter = 'all');
                            },
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Pending',
                            isSelected: _selectedFilter == 'pending',
                            onTap: () {
                              setState(() => _selectedFilter = 'pending');
                            },
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Accepted',
                            isSelected: _selectedFilter == 'accepted',
                            onTap: () {
                              setState(() => _selectedFilter = 'accepted');
                            },
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Rejected',
                            isSelected: _selectedFilter == 'rejected',
                            onTap: () {
                              setState(() => _selectedFilter = 'rejected');
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (filteredApplications.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No applications found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: List.generate(
                      filteredApplications.length,
                      (index) {
                        final application = filteredApplications[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == filteredApplications.length - 1
                                ? 0
                                : 12,
                          ),
                          child: _ApplicationCard(application: application),
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
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

class _ApplicationCard extends StatelessWidget {
  final Map<String, dynamic> application;

  const _ApplicationCard({required this.application});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'accepted':
        return 'Accepted ✓';
      case 'pending':
        return 'Pending';
      case 'rejected':
        return 'Rejected ✗';
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
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    application['image'],
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      application['jobTitle'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      application['employer'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      _getStatusColor(application['status']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getStatusLabel(application['status']),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(application['status']),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey[200]),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wage',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${application['wage']}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E40AF),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    application['location'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Applied',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    application['appliedDate'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildButton(context),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening job details...')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1E40AF),
                    side: const BorderSide(color: Color(0xFF1E40AF)),
                  ),
                  child: const Text('Details', style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    if (application['status'] == 'pending') {
      return OutlinedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Application withdrawn')),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
        ),
        child: const Text('Withdraw', style: TextStyle(fontSize: 12)),
      );
    } else if (application['status'] == 'accepted') {
      return ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Starting job...')),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        child: const Text('Start Job', style: TextStyle(fontSize: 12)),
      );
    } else {
      return OutlinedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Reopening job search...')),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF1E40AF),
          side: const BorderSide(color: Color(0xFF1E40AF)),
        ),
        child: const Text('Browse Similar', style: TextStyle(fontSize: 12)),
      );
    }
  }
}
