import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'jobs_list_screen.dart';
import 'edit_profile_screen.dart';
import 'earnings_screen.dart';
import 'my_applications_screen.dart';
import 'notifications_screen.dart';
import 'messages_screen.dart';
import 'reviews_screen.dart';
import 'settings_screen.dart';
import 'employer_jobs_screen.dart';
import 'job_applicants_screen.dart';
import 'employer_spending_screen.dart';
import 'worker_jobs_screen.dart'; // Import worker jobs screen
import 'package:shared_preferences/shared_preferences.dart';

void printToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  print('✅ Current token: $token');
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardTab(),
    const JobsTab(),
    const ProfileTab(),
    const MoreTab(),
  ];

  @override
  void initState() {
    super.initState();
    printToken(); // Called after super initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF1E40AF),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work_outline),
              activeIcon: Icon(Icons.work),
              label: 'Jobs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              activeIcon: Icon(Icons.menu_open),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== DASHBOARD TAB ====================
class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  void _navigateToJobs(BuildContext context, bool isWorker) {
    //final isWorker = auth.user?.role == 'worker';

if (isWorker) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => const WorkerJobsScreen()),
  );
} else {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => const EmployerJobsScreen()),
  );
}

  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    final isWorker = user?.role == 'worker';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 150,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFF1E40AF),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.name ?? 'User',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const NotificationsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Cards
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: isWorker ? 'Applied' : 'Posted',
                            value: '12',
                            icon: Icons.send_outlined,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: _StatCard(
                            title: 'Active',
                            value: '3',
                            icon: Icons.work_outline,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Expanded(
                          child: _StatCard(
                            title: 'Completed',
                            value: '45',
                            icon: Icons.check_circle_outline,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            title: isWorker ? 'Earnings' : 'Spent',
                            value: '₹18.5K',
                            icon: Icons.currency_rupee,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Quick Actions
                    Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Buttons for actions with navigation
                    if (isWorker) ...[
                      _ActionButton(
                        icon: Icons.account_balance_wallet_outlined,
                        title: 'Payments',
                        subtitle: 'View earnings',
                        color: Colors.orange,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const EarningsScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      _ActionButton(
                        icon: Icons.description_outlined,
                        title: 'My Applications',
                        subtitle: 'Track applications',
                        color: Colors.green,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const MyApplicationsScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      _ActionButton(
                        icon: Icons.work_outline,
                        title: 'Find Jobs',
                        subtitle: 'Browse available jobs',
                        color: Colors.blue,
                        onTap: () => _navigateToJobs(context, true),
                      ),
                    ] else ...[
                      _ActionButton(
                        icon: Icons.post_add,
                        title: 'My Posted Jobs',
                        subtitle: 'Manage jobs',
                        color: const Color(0xFF1E40AF),
                        onTap: () => _navigateToJobs(context, false),
                      ),
                      const SizedBox(height: 10),
                      _ActionButton(
                        icon: Icons.people_outline,
                        title: 'View Applicants',
                        subtitle: 'Review applications',
                        color: Colors.green,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const JobApplicantsScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      _ActionButton(
                        icon: Icons.receipt_long_outlined,
                        title: 'Spending',
                        subtitle: 'Track expenses',
                        color: Colors.orange,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const EmployerSpendingScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== JOBS TAB ====================
class JobsTab extends StatelessWidget {
  const JobsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final isWorker = auth.user?.role == 'worker';

    return isWorker ? const WorkerJobsScreen() : const JobsListScreen();
  }
}

// ==================== PROFILE TAB ====================
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
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
                        user?.name[0].toUpperCase() ?? 'U',
                        style: const TextStyle(
                          fontSize: 40,
                          color: Color(0xFF1E40AF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user?.name ?? 'User',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        user?.role == 'worker' ? '👷 Worker' : '💼 Employer',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Profile Options
              _ProfileOption(
                icon: Icons.edit_outlined,
                title: 'Edit Profile',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
              ),
              _ProfileOption(
                icon: Icons.verified_user_outlined,
                title: 'Verification',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Verification coming soon')),
                  );
                },
              ),
              _ProfileOption(
                icon: Icons.security_outlined,
                title: 'Security & Privacy',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Security settings coming soon')),
                  );
                },
              ),
              _ProfileOption(
                icon: Icons.payment_outlined,
                title: 'Payment Methods',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payment settings coming soon')),
                  );
                },
              ),
              _ProfileOption(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Help & Support coming soon')),
                  );
                },
              ),
              _ProfileOption(
                icon: Icons.info_outline,
                title: 'About EarnSure',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('EarnSure v1.0.0')),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Logout Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await auth.logout();
                      if (context.mounted) context.go('/login');
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== MORE TAB ====================
class MoreTab extends StatelessWidget {
  const MoreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
        backgroundColor: const Color(0xFF1E40AF),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications_outlined,
                color: Color(0xFF1E40AF)),
            title: const Text('Notifications'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const NotificationsScreen()),
              );
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.message_outlined, color: Color(0xFF1E40AF)),
            title: const Text('Messages'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const MessagesScreen()),
              );
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.star_outlined, color: Color(0xFF1E40AF)),
            title: const Text('Reviews'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ReviewsScreen()),
              );
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.settings_outlined, color: Color(0xFF1E40AF)),
            title: const Text('Settings'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ==================== HELPER WIDGETS ====================

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
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
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF1E40AF), size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
