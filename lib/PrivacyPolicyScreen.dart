import 'package:flutter/material.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/utils/media_query_helper.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      // appBar: CustomAppBar1(title: 'Privacy Policy', actions: []),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Privacy Policy',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _HeaderCard(),
            SizedBox(height: 16),

            _SectionCard(
              title: '1. Information We Collect',
              children: [
                _BodyText(
                  'We collect the following types of information to provide and improve our services:',
                ),
                SizedBox(height: 12),
                _SectionSubTitle('a. Personal Information'),
                _BulletText('Name'),
                _BulletText('Email address'),
                _BulletText('Mobile number'),
                _BulletText('Profile photo (optional)'),
                _BulletText(
                  'Profession, skills, or areas of expertise (for mentors)',
                ),
                _BulletText('Other information you provide voluntarily'),
                SizedBox(height: 12),
                _SectionSubTitle('b. Payment Information'),
                _BodyText(
                  'When mentees purchase coins or make payments for sessions, we collect:',
                ),
                _BulletText(
                  'Transaction details (amount, date, payment method)',
                ),
                _BulletText('Billing details (if applicable)'),
                _NoteText(
                  'Note: We do not store full credit/debit card or UPI details. Payments are processed securely via trusted payment gateways compliant with PCI-DSS standards.',
                ),
                SizedBox(height: 12),
                _SectionSubTitle('c. Communication Data'),
                _BodyText(
                  'If you contact us through support channels, we may store messages, feedback, or inquiries and support history.',
                ),
              ],
            ),

            SizedBox(height: 16),

            _SectionCard(
              title: '2. How We Use Your Information',
              children: [
                _BulletText('Create and manage user accounts'),
                _BulletText('Facilitate mentee bookings and mentor sessions'),
                _BulletText('Process payments and manage wallet balances'),
                _BulletText(
                  'Personalize your experience and show relevant content',
                ),
                _BulletText('Provide customer support'),
                _BulletText('Improve app functionality and security'),
                _BulletText(
                  'Send important updates or promotional messages (opt-out available)',
                ),
              ],
            ),

            SizedBox(height: 16),

            _SectionCard(
              title: '3. Sharing of Information',
              children: [
                _BodyText(
                  'We do not sell or rent your personal data. We may share limited data with mentors or mentees for session-related purposes, service providers (payment, hosting, analytics), for legal compliance, and for fraud prevention or security.',
                ),
              ],
            ),

            SizedBox(height: 16),

            _SectionCard(
              title: '4. Data Retention',
              children: [
                _BodyText(
                  'We retain data only as long as necessary for account activity, legal obligations, or dispute resolution. You may request deletion anytime, and we’ll remove your data unless required by law.',
                ),
              ],
            ),

            SizedBox(height: 16),

            _SectionCard(
              title: '5. Data Security',
              children: [
                _BodyText(
                  'We use SSL encryption, secure gateways, and access controls to protect your data. However, no system is 100% secure, and we cannot guarantee absolute protection.',
                ),
              ],
            ),

            SizedBox(height: 16),

            _SectionCard(
              title: '6. Your Rights and Choices',
              children: [
                _BulletText('Access, correct, or update your information'),
                _BulletText('Delete your account and data'),
                _BulletText('Manage marketing preferences'),
                _BodyText(
                  'To exercise these rights, contact us at support@mentivisor.com.',
                ),
              ],
            ),

            SizedBox(height: 16),

            _SectionCard(
              title: '7. Children’s Privacy',
              children: [
                _BodyText(
                  'Mentivisor is for users aged 16 and above. We do not knowingly collect data from minors. If you believe a child has shared personal data, contact us to delete it.',
                ),
              ],
            ),

            SizedBox(height: 16),

            _SectionCard(
              title: '8. Third-Party Services',
              children: [
                _BodyText(
                  'Our app may integrate third-party services (e.g., payment gateways, analytics). Please review their individual privacy policies.',
                ),
              ],
            ),

            SizedBox(height: 16),

            _SectionCard(
              title: '9. Changes to This Policy',
              children: [
                _BodyText(
                  'We may update this Privacy Policy periodically. Updates will be notified in-app or via email. Continued use after updates implies acceptance.',
                ),
              ],
            ),

            SizedBox(height: 16),

            _SectionCard(
              title: '10. Contact Us',
              children: [
                _BodyText(
                  'For questions or concerns, contact us at:\n\n📧 mentivisor@gmail.com',
                ),
              ],
            ),

            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// -------------------- UI COMPONENTS --------------------

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xff5B86E5), Color(0xff36D1DC)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Privacy Policy',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Last updated: October 27, 2025',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 12),
          Text(
            'Welcome to Mentivisor — a platform designed to connect mentors and mentees for meaningful learning and career growth.\n\nBy using Mentivisor, you agree to the practices described in this policy.',
            style: TextStyle(color: Colors.white, height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionSubTitle extends StatelessWidget {
  final String text;
  const _SectionSubTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }
}

class _BodyText extends StatelessWidget {
  final String text;
  const _BodyText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 15, height: 1.6));
  }
}

class _NoteText extends StatelessWidget {
  final String text;
  const _NoteText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontStyle: FontStyle.italic,
          color: Colors.grey,
          height: 1.5,
        ),
      ),
    );
  }
}

class _BulletText extends StatelessWidget {
  final String text;
  const _BulletText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 18)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
