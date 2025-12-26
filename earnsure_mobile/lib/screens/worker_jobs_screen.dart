import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'job_details_screen.dart';

class WorkerJobsScreen extends StatefulWidget {
  const WorkerJobsScreen({super.key});

  @override
  State<WorkerJobsScreen> createState() => _WorkerJobsScreenState();
}

class _WorkerJobsScreenState extends State<WorkerJobsScreen> {
  bool _isLoading = false;
  String? _error;
  List<Map<String, dynamic>> _jobs = [];
  String _selectedFilter = 'all'; // all, active, completed

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await ApiService.get('/jobs');
      if (response['success'] == true) {
        final List<dynamic>? jobs = response['jobs'];
        setState(() {
          _jobs = jobs?.cast<Map<String, dynamic>>() ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = response['message'] ?? 'Failed to load jobs';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _applyToJob(String jobId) async {
    try {
      print('Applying to job ID: $jobId');  // Debug print
      final response = await ApiService.post('/jobs/$jobId/apply', {});
      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully applied to job')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to apply for the job')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error applying to job: $e')),
      );
    }
  }

  List<Map<String, dynamic>> _getFilteredJobs() {
    if (_selectedFilter == 'all') return _jobs;
    return _jobs.where((job) => (job['status'] ?? 'active') == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final jobs = _getFilteredJobs();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Jobs'),
        backgroundColor: const Color(0xFF1E40AF),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadJobs,
            tooltip: 'Refresh',
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
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF1E40AF)))
                : _error != null
                    ? Center(child: Text(_error!))
                    : jobs.isEmpty
                        ? const Center(
                            child: Text(
                              'No jobs available',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: jobs.length,
                            itemBuilder: (context, index) {
                              final job = jobs[index];
                              return _JobCard(
                                job: job,
                                onApply: () => _applyToJob(job['_id'].toString()),
                                onViewDetails: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => JobDetailsScreen(job: job),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  final VoidCallback onApply;
  final VoidCallback onViewDetails;

  const _JobCard({
    required this.job,
    required this.onApply,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final employerName = (job['employer'] is Map && job['employer'] != null)
        ? job['employer']['name'] ?? ''
        : '';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(job['image'] ?? '💼', style: const TextStyle(fontSize: 32)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(job['title'] ?? '',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('by $employerName',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(children: [
                    Text(job['category'] ?? '',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.orange[700],
                            fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Icon(Icons.location_on_outlined, size: 12, color: Colors.grey[500]),
                    const SizedBox(width: 2),
                    Text(job['location'] ?? '',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                  ]),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1E40AF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('₹${job['wage'] ?? 'N/A'}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF))),
            ),
          ]),
          const SizedBox(height: 12),
          Divider(color: Colors.grey[200]),
          const SizedBox(height: 12),
          Text(job['description'] ?? '',
              style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.5),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onViewDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('View Details'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: onApply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
