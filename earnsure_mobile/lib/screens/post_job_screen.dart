import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../providers/auth_provider.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _wageController = TextEditingController();
  final _locationController = TextEditingController();

  String _selectedCategory = 'Construction';
  bool _isLoading = false;

  final List<String> _categories = [
    'Construction',
    'Plumbing',
    'Electrical',
    'Cleaning',
    'Delivery',
    'Data Entry',
    'IT',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _wageController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _postJob() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      print('🔵 POST JOB: Starting...');

      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();
      final wage = int.parse(_wageController.text.trim());
      final location = _locationController.text.trim();

      print('📦 Job Details: Title: $title, Category: $_selectedCategory');

      final response = await ApiService.post('/jobs', {
        'title': title,
        'description': description,
        'category': _selectedCategory,
        'wage': wage,
        'location': location,
      });

      print('✅ Response: $response');

      if (response['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Job posted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } else {
        _showError(response['message'] ?? 'Failed to post job');
      }
    } catch (e) {
      print('❌ Error: $e');
      _showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Job'),
        backgroundColor: const Color(0xFF1E40AF),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue[700], size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Posting as: ${auth.user?.name ?? "User"}',
                          style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Job Title',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'e.g., House Painting',
                    prefixIcon: const Icon(Icons.work_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Please enter title';
                    if (value.length < 3) return 'Title must be at least 3 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.category_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  items: _categories
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedCategory = value!),
                  validator: (value) {
                    if (value == null) return 'Please select category';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Job Description',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Describe the job...',
                    prefixIcon: const Icon(Icons.description_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Please enter description';
                    if (value.length < 10) return 'Description must be at least 10 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Wage (₹)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _wageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '5000',
                    prefixIcon: const Icon(Icons.currency_rupee),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Please enter wage';
                    if (int.tryParse(value.trim()) == null) return 'Enter valid number';
                    if (int.parse(value.trim()) < 100) return 'Wage must be ₹100+';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    hintText: 'e.g., Delhi',
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Please enter location';
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _postJob,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E40AF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        : const Text('Post Job',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1E40AF),
                      side: const BorderSide(color: Color(0xFF1E40AF), width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
