import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

  class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
  }

  class _AddPostScreenState extends State<AddPostScreen> {
    final _headingController = TextEditingController();
    final _describeController = TextEditingController();
    final _tagController = TextEditingController();
    final List<String> _suggestedTags = [
      'DSA',
      'Interview',
      'Java',
      'React',
      'System Design',
      'Help',
      'Discussion',
      'Mentor Request'
    ];
    final List<String> _selectedTags = [];
    bool _anonymous = false;
    bool _highlight = false;

    @override
    void dispose() {
      _headingController.dispose();
      _describeController.dispose();
      _tagController.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      const radius = Radius.circular(8.0);

      return Scaffold(
        backgroundColor: Color(0xffFAF5FF),
        appBar: AppBar(
          backgroundColor: Color(0xffFAF5FF),
          elevation: 0,
          leading: const BackButton(color: Colors.black),
          centerTitle: true,
          title: const Text(
            'Add Post',
            style: TextStyle(
              fontFamily: 'Sugeo',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xff222222),
            ),
          ),
        ),
        body:
        ListView(

          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          children: [
            // Heading
            const Text(
              'Heading',
              style: TextStyle(
                fontFamily: 'Sugeo',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xff333333),

              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _headingController,
              decoration: InputDecoration(
                hintText: 'Write a heading',
                hintStyle: TextStyle(
                    color: Color(0xff666666), fontFamily: 'Sugeo',fontSize: 14),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Describe
            const Text(
              'Describe',
              style: TextStyle(
                fontFamily: 'Sugeo',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xff333333),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _describeController,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Describe your Post',
                hintStyle: TextStyle(
                    color: Color(0xff666666), fontFamily: 'Sugeo',fontSize: 14
                 ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Tags
            const Text(
              'Tags',
              style: TextStyle(
                fontFamily: 'Sugeo',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xff333333),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagController,
                    decoration: InputDecoration(
                      hintText: 'Enter Tag',
                      hintStyle: TextStyle(
                          color: Color(0xff666666), fontFamily: 'Sugeo',fontSize: 14),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(height: 48,width: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      final tag = _tagController.text.trim();
                      if (tag.isNotEmpty && !_selectedTags.contains(tag)) {
                        setState(() {
                          _selectedTags.add(tag);
                          _tagController.clear();
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // adjust the radius as needed
                      ),
                      backgroundColor: const Color(0xff315DEA),
                      padding: const EdgeInsets.all(12), // you can adjust padding if needed
                    ),
                    child: const Icon(Icons.add, size: 20, color: Colors.white),
                  ),
                )




              ],
            ),
            const SizedBox(height: 8),
            // Suggested tags
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _suggestedTags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return ChoiceChip(
                  label: Text('#$tag', style: TextStyle(fontFamily: 'Sugeo')),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      isSelected ? _selectedTags.remove(tag) : _selectedTags
                          .add(tag);
                    });
                  },
                  selectedColor: Colors.blue.shade100,
                  backgroundColor: Colors.white,
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Image upload
            const Text(
              'Image',
              style: TextStyle(
                fontFamily: 'Sugeo',

                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xff333333),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // TODO: implement image picker
              },
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(8),
                dashPattern: const [6, 4],
                color: Colors.grey.shade400,
                strokeWidth: 1.5,
                child: Container(
                  height: 100,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: const [
                      Icon(Icons.upload_file, color: Colors.grey),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Upload image in 16:9 or 4:3',
                          style: TextStyle(
                            fontFamily: 'Sugeo',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Anonymous toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Post this anonymous',
                  style: TextStyle(
                    fontFamily: 'Sugeo',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff333333),
                  ),
                ),
                Switch(
                  value: _anonymous,
                  onChanged: (v) => setState(() => _anonymous = v),
                  activeColor: Color(0xff315DEA),
                ),
              ],
            ),
            const Text(
              'Viewer can’t see who posted it',
              style: TextStyle(
                fontFamily: 'Sugeo',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color(0xff666666),
              ),
            ),

            const SizedBox(height: 24),

            // Highlight post
            Row(
              children: [
                Checkbox(
                  value: _highlight,
                  onChanged: (v) => setState(() => _highlight = v!),
                  activeColor: Colors.blue,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Highlight Post',
                    style: TextStyle(
                      fontFamily: 'Sugeo',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff333333),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 48),
              child: Text(
                'Make your post Highlight with 40 coins for 1 day',
                style: TextStyle(
                  fontFamily: 'Sugeo',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xff666666),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Post It button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: submit post & navigate
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                child: Ink(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF8C36FF), Color(0xFF3F9CFF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  child: const Center(
                    child: Text(
                      'Post It',
                      style: TextStyle(
                        fontFamily: 'Sugeo',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      );
    }
  }