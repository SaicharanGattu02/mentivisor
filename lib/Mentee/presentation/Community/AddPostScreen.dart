import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Components/CustomAppButton.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/Mentee/data/cubits/CommunityTags/community_tags_cubit.dart';
import 'package:mentivisor/Mentee/data/cubits/CommunityTags/community_tags_states.dart';

import '../Widgets/common_widgets.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _headingController = TextEditingController();
  final _describeController = TextEditingController();
  final _tagController = TextEditingController();
  List<String> _suggestedTags = [];
  final List<String> _selectedTags = [];
  bool _anonymous = false;
  bool _highlight = false;

  @override
  void initState() {
    super.initState();
    context.read<CommunityTagsCubit>().getCommunityTags();
  }

  @override
  void dispose() {
    _headingController.dispose();
    _describeController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: "Add Post", actions: []),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7F8FC), Color(0xFFEFF4FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildCustomLabel('Heading'),
              buildCustomTextField(
                controller: _headingController,
                hint: "Write an heading",
                validator: (value) {
                  if (value!.isEmpty) return 'Heading is required';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              buildCustomLabel('Describe'),
              TextField(
                controller: _describeController,
                cursorColor: Colors.black,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                decoration: InputDecoration(hintText: 'Describe your Post'),
              ),
              const SizedBox(height: 10),
              buildCustomLabel('Tags'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: buildCustomTextField(
                      controller: _tagController,
                      hint: "Enter Tag",
                      validator: (value) {
                        if (value!.isEmpty) return 'Tags is required';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 48,
                    width: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        final tag = _tagController.text.trim();
                        if (tag.isNotEmpty) {
                          context.read<CommunityTagsCubit>().addTag(tag);
                          _tagController.clear();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            5,
                          ), // adjust the radius as needed
                        ),
                        backgroundColor: const Color(0xff315DEA),
                        padding: const EdgeInsets.all(
                          12,
                        ), // you can adjust padding if needed
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Suggested tags
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Suggested :"),
                    SizedBox(height: 5),
                    BlocBuilder<CommunityTagsCubit, CommunityTagsStates>(
                      builder: (context, state) {
                        if (state is CommunityTagsLoading) {
                          return CircularProgressIndicator();
                        } else if (state is CommunityTagsLoaded) {
                          // Debug the state
                          debugPrint(
                            "Selected Tags in UI: ${state.selectedTags}",
                          );

                          return Wrap(
                            spacing: 5,
                            runSpacing: 0,
                            children: state.allTags.map((tag) {
                              final isSelected = state.selectedTags.contains(
                                tag,
                              );
                              return ChoiceChip(
                                label: Text(tag),
                                selected: isSelected,
                                onSelected: (_) {
                                  context.read<CommunityTagsCubit>().toggleTag(
                                    tag,
                                  );
                                },
                                selectedColor: Colors.blue.shade100,
                                backgroundColor: Colors.white,
                                side: BorderSide(
                                  color: isSelected
                                      ? Colors.blue.shade100
                                      : Colors.grey,
                                ),
                              );
                            }).toList(),
                          );
                        } else {
                          return Text("No Tags Found");
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Image upload
              const Text(
                'Image',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff333333),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {},
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(8),
                  dashPattern: const [6, 4],
                  color: Colors.grey.shade400,
                  strokeWidth: 1.5,
                  child: Container(
                    height: 70,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Post this anonymous',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff333333),
                    ),
                  ),
                  Transform.scale(
                    scale: 0.5,
                    child: Switch(
                      value: _anonymous,
                      onChanged: (v) => setState(() => _anonymous = v),
                      activeColor: Color(0xff315DEA),
                    ),
                  ),
                ],
              ),
              const Text(
                'Viewer can’t see who posted it',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xff666666),
                ),
              ),

              const SizedBox(height: 24),

              // Highlight post
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _highlight,
                    onChanged: (v) => setState(() => _highlight = v!),
                    activeColor: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Highlight Post',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff333333),
                          ),
                        ),
                        Text(
                          'Make your post Highlight with 40 coins for 1 day',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Color(0xff666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
              CustomAppButton1(text: "Post It", onPlusTap: () {}),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
