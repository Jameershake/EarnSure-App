import 'package:flutter/material.dart';
import '../services/api_service.dart';  // Assuming you have ApiService to handle HTTP calls
import 'job_details_screen.dart';


class JobsListScreen extends StatefulWidget {
  const JobsListScreen({super.key});

  @override
  State<JobsListScreen> createState() => _JobsListScreenState();
}

class _JobsListScreenState extends State<JobsListScreen> {
  List<Map<String, dynamic>> _jobs = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  final _searchController = TextEditingController();
  String _filterRole = 'all'; // all, active, completed

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  Future<void> _fetchJobs() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final response = await ApiService.get('/jobs/employer/my-jobs');
      if (response['success'] == true) {
        setState(() {
          _jobs = List<Map<String, dynamic>>.from(response['jobs']);
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _errorMessage = response['message'] ?? 'Failed to fetch jobs';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getFilteredJobs() {
    var filtered = _jobs;

    // Apply text search filter
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((job) {
        final title = job['title']?.toString().toLowerCase() ?? '';
        final category = job['category']?.toString().toLowerCase() ?? '';
        final searchText = _searchController.text.toLowerCase();
        return title.contains(searchText) || category.contains(searchText);
      }).toList();
    }

    // Apply status filter if not 'all'
    if (_filterRole != 'all') {
      filtered = filtered.where((job) => job['status'] == _filterRole).toList();
    }
    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobs = _getFilteredJobs();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Job Posts'),
        backgroundColor: const Color(0xFF1E40AF),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: const Color(0xFF1E40AF),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search jobs...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('All Jobs'),
                        selected: _filterRole == 'all',
                        onSelected: (selected) {
                          setState(() => _filterRole = 'all');
                        },
                        backgroundColor: Colors.white,
                        selectedColor: Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Active'),
                        selected: _filterRole == 'active',
                        onSelected: (selected) {
                          setState(() => _filterRole = 'active');
                        },
                        backgroundColor: Colors.white,
                        selectedColor: Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Completed'),
                        selected: _filterRole == 'completed',
                        onSelected: (selected) {
                          setState(() => _filterRole = 'completed');
                        },
                        backgroundColor: Colors.white,
                        selectedColor: Colors.orange,
                      ),
                    ],
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
                : _hasError
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
                            const SizedBox(height: 16),
                            Text(
                              _errorMessage,
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _fetchJobs,
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E40AF)),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : jobs.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.work_outline, size: 80, color: Colors.grey[300]),
                                const SizedBox(height: 16),
                                const Text(
                                  'No jobs found',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Try adjusting your filters',
                                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: jobs.length,
                            itemBuilder: (context, index) {
                              final job = jobs[index];
                              return _JobCard(
                                job: job,
                                onTap: () {
                                  // Navigate to job details screen
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
  final VoidCallback onTap;

  const _JobCard({required this.job, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        job['image'] ?? '💼',
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job['title'] ?? '',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'by ${job['employer'] ?? ''}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              job['category'] ?? '',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.orange[700],
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.location_on_outlined, size: 12, color: Colors.grey[500]),
                            const SizedBox(width: 2),
                            Text(
                              job['location'] ?? '',
                              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E40AF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '₹${job['wage'] ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E40AF),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(color: Colors.grey[200]),
              const SizedBox(height: 12),
              Text(
                job['description'] ?? '',
                style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.5),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.people_outline, size: 16, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        '${job['applicants']?.length ?? 0} applied',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${job['rating'] ?? 0}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E40AF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('View', style: TextStyle(fontSize: 12)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
