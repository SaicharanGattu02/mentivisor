import 'package:flutter/material.dart';

import '../Components/CustomAppButton.dart';

class MentivisorProfileSetup extends StatefulWidget {
  const MentivisorProfileSetup({super.key});

  @override
  State<MentivisorProfileSetup> createState() => _MentivisorProfileSetupState();
}

class _MentivisorProfileSetupState extends State<MentivisorProfileSetup> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6faff),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xfff6faff),
              Color(0xffe0f2fe),
            ], // Replace with your desired gradient
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  _Step1(onNext: _nextPage),
                  _Step2(onNext: _nextPage, onBack: _prevPage),
                  _Step3(onNext: _nextPage, onBack: _prevPage),
                  _Step4(onNext: _nextPage, onBack: _prevPage),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientProgressBar extends StatelessWidget {
  final double progress; // value from 0.0 to 1.0
  final int currentStep; // 1 to 4

  const GradientProgressBar({
    super.key,
    required this.progress,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row with title and step count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Profile Setup',
                style: TextStyle(
                  fontFamily: 'segeo',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Text(
                '$currentStep of 4',
                style: const TextStyle(
                  fontFamily: 'segeo',
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Progress bar
          Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    height: 6,
                    width: constraints.maxWidth * progress,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xffa855f7), Color(0xff3b82f6)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Step1 extends StatelessWidget {
  final VoidCallback onNext;
  const _Step1({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const GradientProgressBar(
            progress: 0.25,
            currentStep: 1,
          ), // <-- pass step progress here
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  "What's your name?",
                  style: TextStyle(
                    fontFamily: 'segeo',
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "This is how others will see you on the platform",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'segeo',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xffa855f7), Color(0xff3b82f6)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, size: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Full Name",
                    style: TextStyle(
                      fontFamily: 'segeo',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter your full name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.bottomRight,
            child: CustomAppButton1(
              width: 120,
              text: "Next",
              icon: Icons.arrow_forward,
              onPlusTap: onNext,
            ),
          ),
        ],
      ),
    );
  }
}

class _Step2 extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const _Step2({required this.onNext, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const GradientProgressBar(progress: 0.50, currentStep: 2),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  "Tell us about yourself",
                  style: TextStyle(
                    fontFamily: 'segeo',
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Write a brief bio that highlights your background",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'segeo',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Bio",
                    style: TextStyle(
                      fontFamily: 'segeo',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText:
                        "Tell us about your academic background, interests, and what you hope to achieve...",
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onBack,
                child: const Text(
                  "Back",
                  style: TextStyle(fontFamily: 'segeo', color: Colors.black38),
                ),
              ),
              CustomAppButton1(
                width: 120,
                text: "Next",
                icon: Icons.arrow_forward,
                onPlusTap: onNext,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Step3 extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _Step3({required this.onNext, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final interests = [
      "Technology",
      "Business",
      "Design",
      "Marketing",
      "Data Science",
      "Engineering",
      "Healthcare",
      "Finance",
      "Education",
      "Research",
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const GradientProgressBar(progress: 0.75, currentStep: 3),
          const SizedBox(height: 16),
          // White card container
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Your Interests",
                  style: TextStyle(
                    fontFamily: 'segeo',
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Choose areas you want to learn more about",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'segeo',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 3, // Adjust this for desired width/height ratio
                  ),
                  itemCount: interests.length,
                  itemBuilder: (context, index) {
                    final interest = interests[index];
                    final bool isSelected = ["Technology", "Business", "Marketing"].contains(interest);

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xfff3e8ff) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? const Color(0xff8b5cf6) : Colors.grey.shade300,
                          width: isSelected ? 2.0 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.menu_book_outlined,
                            size: 18,
                            color: isSelected ? const Color(0xff8b5cf6) : Colors.black54,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              interest,
                              style: TextStyle(
                                fontFamily: 'segeo',
                                fontSize: 14,
                                color: isSelected ? const Color(0xff8b5cf6) : Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

              ],
            ),
          ),

          const SizedBox(height: 24),

          // Navigation Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onBack,
                child: const Text(
                  "Back",
                  style: TextStyle(
                    fontFamily: 'segeo',
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ),
              CustomAppButton1(
                width: 120,
                text: "Next",
                icon: Icons.arrow_forward,
                onPlusTap: onNext,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Step4 extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onNext;

  const _Step4({required this.onBack, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final goals = [
      "Career Guidance",
      "Skill Development",
      "Academic Support",
      "Industry Insights",
      "Networking",
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const GradientProgressBar(progress: 1.0, currentStep: 4),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: const Text(
                    "Your Academic Journey",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'segeo',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Tell us about your current studies and goals",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'segeo',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Current Year/Level",
                  style: TextStyle(
                    fontFamily: 'segeo',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: "Select your current year",
                    hintStyle: const TextStyle(fontFamily: 'segeo'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: ["1st Year", "2nd Year", "3rd Year", "4th Year"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {},
                ),
                const SizedBox(height: 20),
                const Text(
                  "Your Goals",
                  style: TextStyle(
                    fontFamily: 'segeo',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2, // Two items per row
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3, // Width / Height ratio, adjust if needed
                  children: goals.map((goal) {
                    final bool isSelected = [
                      "Career Guidance",
                      "Skill Development",
                      "Academic Support",
                    ].contains(goal);

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xfff3e8ff) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? const Color(0xff8b5cf6) : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.radio_button_checked,
                            size: 18,
                            color: isSelected ? const Color(0xff8b5cf6) : Colors.black54,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              goal,
                              style: TextStyle(
                                fontFamily: 'segeo',
                                fontSize: 14,
                                color: isSelected ? const Color(0xff8b5cf6) : Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

              ],
            ),
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onBack,
                child: const Text("Back", style: TextStyle(fontFamily: 'segeo')),
              ),

              // Gradient-styled Complete Setup button
              Container(
                height: 48,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [Color(0xffc084fc), Color(0xff818cf8)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onNext,
                  icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                  label: const Text(
                    "Complete Setup",
                    style: TextStyle(
                      fontFamily: 'segeo',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


