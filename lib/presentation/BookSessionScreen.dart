import 'package:flutter/material.dart';

class BookSessionScreen extends StatefulWidget {
  const BookSessionScreen({super.key});

  @override
  State<BookSessionScreen> createState() => _BookSessionScreenState();
}

class _BookSessionScreenState extends State<BookSessionScreen> {
  String? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 50,
                    height: 40,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xffe2e8f0),
                        ),
                        padding: EdgeInsets
                            .zero, // Ensures no extra padding disturbs centering
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                  SizedBox(width: 50),
                  Text(
                    "Book a Session",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Inter",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('Select Date'),
                    const SizedBox(height: 8),
                    _dateTile('Today', '3 slots available'),
                    _dateTile('Tomorrow', '4 slots available'),
                    _dateTile('Wed, Jan 17', '3 slots available'),
                    _dateTile('Thu, Jan 18', '4 slots available'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('Select Time'),
                    const SizedBox(height: 8),
                    _timeSelector(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('Session Type'),
                    const SizedBox(height: 8),
                    _sessionTypeSelector(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('Session Goals'),
                    const SizedBox(height: 8),
                    _goalsField(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _bookingSummary(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Text(
    text,
    style: const TextStyle(
      fontFamily: 'Inter',
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
  );

  Widget _dateTile(String title, String subtitle) => Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(color: Color(0xffe5e7eb)),
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontFamily: 'Inter', color: Colors.grey[700]),
      ),
    ),
  );

  Widget _timeSelector() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 3.5,
        children: [
          _timeChip('11:00 AM', true),
          _timeChip('1:00 PM', false),
          _timeChip('4:00 PM', false),
          _timeChip('7:30 PM', false),
        ],
      ),
      const SizedBox(height: 8),
      const Text(
        'All times shown in',
        style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey),
      ),
    ],
  );

  Widget _timeChip(String time, bool selected) => GestureDetector(
    onTap: () {
      // Add interactivity logic if needed
    },
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFF1EAFE) : Colors.white,
        border: Border.all(
          color: selected ? Colors.deepPurple : Colors.grey.shade300,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      alignment: Alignment.center,
      child: Text(
        time,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: selected ? Colors.deepPurple : Colors.black,
        ),
      ),
    ),
  );

  Widget _sessionTypeSelector() => Row(
    children: [
      Expanded(
        child: _sessionCard(
          Icons.videocam,
          'Video Call',
          'Face-to-face interaction',
          true,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _sessionCard(
          Icons.call,
          'Audio Call',
          'Voice-only session',
          false,
        ),
      ),
    ],
  );

  Widget _sessionCard(
    IconData icon,
    String title,
    String subtitle,
    bool selected,
  ) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(
        color: selected ? Colors.deepPurple : Colors.grey.shade300,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(12),
      color: selected ? const Color(0xFFF1EAFE) : Colors.white,
    ),
    child: Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontFamily: 'Inter', fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _goalsField() => TextField(
    maxLines: 3,
    decoration: InputDecoration(
      hintText: "Describe what you'd like to discuss in this session...",
      fillColor: Colors.white,
      filled: true,
    ),
  );

  Widget _bookingSummary() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(radius: 24, backgroundColor: Colors.grey),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Dr. Sarah Chen',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Senior Software Engineer at Google',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        const Divider(height: 24, thickness: 0.5, color: Colors.black26),
        _summaryRow('Type:', 'Video Call'),
        const Divider(height: 24, thickness: 0.5, color: Colors.black26),
        const SizedBox(height: 8),
        _summaryRow('Session Cost:', '25', coin: true),
        _summaryRow('Your Balance:', '150', coin: true),
        const Divider(height: 24, thickness: 0.5, color: Colors.black26),
        _summaryRow('After Session:', '125', coin: true),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {},
            child: const Text(
              'Book Session',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _summaryRow(String label, String value, {bool coin = false}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(fontFamily: 'Inter')),
      Row(
        children: [
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ],
  );
}
