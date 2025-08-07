import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class AddResourceScreen extends StatefulWidget {
  const AddResourceScreen({super.key});
  @override
  State<AddResourceScreen> createState() => _AddResourceScreenState();
}

class _AddResourceScreenState extends State<AddResourceScreen> {
  bool _useDefault = false;
  final _resourceNameCtrl = TextEditingController();
  final _aboutCtrl = TextEditingController();
  final _tagCtrl = TextEditingController();
  final List<String> _tags = [];
  final List<String> _suggestions = [
    'DSA',
    'Interview',
    'Java',
    'React',
    'System Design',
    'Help',
    'Discussion',
    'Mentor Request',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Add Resource'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              // Cloud graphic
              Icon(
                Icons.cloud_upload_outlined,
                size: 100,
                color: Colors.blue.shade400,
              ),
              const SizedBox(height: 24),

              _buildUploadBox(
                label: 'Upload your Banner here',
                onTap: () {
                  /* TODO: pick banner */
                },
              ),

              const SizedBox(height: 12),

              _buildLabel('Resource Name'),
              const SizedBox(height: 4),
              TextField(
                controller: _resourceNameCtrl,
                decoration: _inputDecoration('Enter resource name'),
              ),

              const SizedBox(height: 16),
              // About Resource
              _buildLabel('About Resource'),
              const SizedBox(height: 4),
              TextField(
                controller: _aboutCtrl,
                maxLines: 5,
                decoration: _inputDecoration('Enter resource name'),
              ),

              const SizedBox(height: 16),
              // Tags input
              _buildLabel('Tags'),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _tagCtrl,
                      decoration: _inputDecoration('Enter Tag'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final tag = _tagCtrl.text.trim();
                      if (tag.isNotEmpty && !_tags.contains(tag)) {
                        setState(() {
                          _tags.add(tag);
                          _tagCtrl.clear();
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          14,
                        ), // adjust the radius as needed
                      ),
                      backgroundColor: const Color(0xff315DEA),
                      padding: const EdgeInsets.all(
                        12,
                      ), // you can adjust padding if needed
                    ),
                    child: const Icon(Icons.add, size: 20, color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              // Selected tags
              if (_tags.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: _tags
                      .map(
                        (t) => Chip(
                          label: Text(t),
                          onDeleted: () => setState(() => _tags.remove(t)),
                        ),
                      )
                      .toList(),
                ),

              const SizedBox(height: 8),
              // Suggest Tags
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _suggestions
                    .map(
                      (t) => ActionChip(
                        label: Text('#$t'),
                        onPressed: () {
                          if (!_tags.contains(t)) {
                            setState(() => _tags.add(t));
                          }
                        },
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 24),
              // Resources upload
              _buildUploadBox(
                label: 'Upload your Resources here',
                onTap: () {},
              ),

              const SizedBox(height: 32),
              // Add button
              Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8A2BE2), Color(0xFF4A90E2)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      /* TODO: submit */
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: const Center(
                      child: Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'segeo',
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Color(0xff374151E5),
      ),
    ),
  );

  Decoration _boxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
  );

  Widget _buildUploadBox({required String label, required VoidCallback onTap}) {
    return DottedBorder(
      color: Colors.grey.shade400,
      strokeWidth: 1,
      dashPattern: const [6, 3],
      borderType: BorderType.RRect,
      radius: const Radius.circular(8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: _boxDecoration(),
          child: Column(
            children: [
              const SizedBox(height: 3),
              Text(label, style: TextStyle(color: Color(0xff9CA3AF))),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
  );
}
