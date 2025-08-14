import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _collegeController;
  late TextEditingController _yearController;
  late TextEditingController _bioController;
  bool _imageRemoved = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Shiva');
    _collegeController = TextEditingController(text: 'Shiva SVR College');
    _yearController = TextEditingController(text: '2019');
    _bioController = TextEditingController(
      text: 'A bio is a short description of a person\'s life, work, and interests…',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _collegeController.dispose();
    _yearController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black87),
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xff121212),
            fontFamily: 'segeo',
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // avatar + remove button
              Center(
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    if (!_imageRemoved)
                      const CircleAvatar(
                        radius: 64,
                        backgroundImage: AssetImage('images/profileimg.png'),
                      ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.remove_circle, size: 18, color: Colors.black),
                          onPressed: () => setState(() => _imageRemoved = true),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Name
              const Text(
                'Name',
                style: TextStyle(
                  fontFamily: 'segeo',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff374151),
                ),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Name required' : null,
              ),
              const SizedBox(height: 16),

              // College Name
              const Text(
                'College Name',
                style: TextStyle(
                  fontFamily: 'segeo',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff374151),
                ),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: _collegeController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (v) => v == null || v.isEmpty ? 'College Name required' : null,
              ),
              const SizedBox(height: 16),

              // Year
              const Text(
                'Year',
                style: TextStyle(
                  fontFamily: 'segeo',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff374151),
                ),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Year required' : null,
              ),
              const SizedBox(height: 16),

              // Bio
              const Text(
                'Bio',
                style: TextStyle(
                  fontFamily: 'segeo',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff374151),
                ),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText:
                  "A bio is a short description of a person's life, work, and interests, commonly used on professional and social media platforms.",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: 5,
                validator: (v) => v == null || v.isEmpty ? 'Bio required' : null,
              ),
              const SizedBox(height: 24),

              // Save button
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       if (_formKey.currentState!.validate()) {
              //         // Save profile changes
              //         Navigator.pop(context);
              //       }
              //     },
              //     style: ElevatedButton.styleFrom(
              //       padding: const EdgeInsets.symmetric(vertical: 16),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //     ),
              //     child: const Text('Save Changes'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
