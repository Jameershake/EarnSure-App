import 'package:flutter/material.dart';
import 'post_job_screen.dart';
import '../services/api_service.dart';

class EmployerJobsScreen extends StatefulWidget {
  const EmployerJobsScreen({super.key});

  @override
  State<EmployerJobsScreen> createState() => _EmployerJobsScreenState();
}

class _EmployerJobsScreenState extends State<EmployerJobsScreen> {
  String _selectedFilter = 'all';
  bool _isLoading = true;
  List<Map<String, dynamic>> _jobs = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      print('🔵 LOAD JOBS: Fetching from /jobs/employer/my-jobs');

      final response = await ApiService.get('/jobs/employer/my-jobs');

      print('✅ Response Status: success=${response['success']}');
      print('📊 Jobs Data: ${response['jobs']}');

      if (response['success'] == true) {
        final List<dynamic>? jobs = response['jobs'];
        setState(() {
          _jobs = jobs?.cast<Map<String, dynamic>>() ?? [];
          _isLoading = false;
        });
        print('✅ Loaded ${_jobs.length} jobs');
      } else {
        setState(() {
          _error = response['message'] ?? 'Failed to load jobs';
          _isLoading = false;
        });
        print('❌ Backend error: ${response['message']}');
      }
    } catch (e) {
      print('❌ Error loading jobs: $e');
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getFilteredJobs() {
    if (_selectedFilter == 'all') {
      return _jobs;
    }
    return _jobs.where((job) => (job['status'] ?? 'active') == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _getFilteredJobs();

    return Scaffold(
      appBar: AppBar(
        title: Text('My Posted Jobs (${_jobs.length})'),
        backgroundColor: const Color(0xFF1E40AF),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadJobs,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PostJobScreen(),
                ),
              );
              print('🔵 Returned from PostJobScreen: $result');
              if (result == true) {
                print('🔄 Reloading jobs...');
                await Future.delayed(const Duration(milliseconds: 500));
                _loadJobs();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1E40AF).withOpacity(0.05),
            child: Row(
              children: [
                Expanded(
                  child: FilterChip(
                    label: const Text('Active'),
                    selected: _selectedFilter == 'active',
                    onSelected: (_) => setState(() => _selectedFilter = 'active'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilterChip(
                    label: const Text('Completed'),
                    selected: _selectedFilter == 'completed',
                    onSelected: (_) => setState(() => _selectedFilter = 'completed'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilterChip(
                    label: const Text('All'),
                    selected: _selectedFilter == 'all',
                    onSelected: (_) => setState(() => _selectedFilter = 'all'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF1E40AF),
                    ),
                  )
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
                            const SizedBox(height: 16),
                            Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _loadJobs,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E40AF),
                              ),
                            ),
                          ],
                        ),
                      )
                    : filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.work_outline, size: 80, color: Colors.grey[300]),
                                const SizedBox(height: 16),
                                const Text(
                                  'No jobs posted yet',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap + to post your first job',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const PostJobScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text('Post First Job'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1E40AF),
                                  ),
                                )
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadJobs,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final job = filtered[index];
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
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Colors.blue[50],
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  job['image'] ?? '💼',
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
                                                    job['title'] ?? 'Job',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    '₹${job['wage'] ?? 'N/A'}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.green,
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
                                                color: Colors.green.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                job['status'] ?? 'Active',
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          job['description'] ?? 'No description',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Icon(Icons.location_on_outlined,
                                                      size: 14, color: Colors.grey[600]),
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      job['location'] ?? 'Unknown',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[600],
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Row(
                                              children: [
                                                Icon(Icons.category, size: 14, color: Colors.grey[600]),
                                                const SizedBox(width: 4),
                                                Text(
                                                  job['category'] ?? 'Other',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}
