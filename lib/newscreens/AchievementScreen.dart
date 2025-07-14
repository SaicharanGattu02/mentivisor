import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Color(0xffFAF5FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xffFAF5FF),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(

        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(

          children: [

            const SizedBox(height: 24),
            // Illustration
            Image.asset(
              'images/linkimg.png', // replace with your asset
              height: 140,
            ),
            const SizedBox(height: 24),
            // Main title
            Align(
              alignment: AlignmentGeometry.directional(-1,-1),
              child: Text(
                "Woohoo! You did the thing!🎉",
                style: TextStyle(color: Color(0xff2563EC),fontSize: 24, fontFamily: 'segeo',fontWeight: FontWeight.w600),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle
            Align(
              alignment: AlignmentGeometry.directional(-1,-1),
              child: Text(
                'Small step or big leap - it all counts. Well done on your \nachievement!',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 14,color: Color(0xff666666), fontWeight: FontWeight.w600, fontFamily: 'segeo'),
              ),
            ),
            const SizedBox(height: 24),

            _LabeledLinkField(label: "Share your Portfolio"),
            _LabeledLinkField(label: "Linked-in"),
            _LabeledLinkField(label: "Git Hub link"),
            // Upload resume
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Upload your Resume", style: TextStyle(fontSize: 16,color: Color(0xff444444), fontWeight: FontWeight.w600, fontFamily: 'segeo',),),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                // TODO: wire up file picker
              },
              icon: Icon(Icons.upload_file),
              label: Text("Upload your resume here", style: TextStyle(fontFamily: 'segeo',fontSize: 14) ),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                side: BorderSide(color: Colors.grey.shade400),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "※ Sharing more details about yourself increases your chances of becoming a mentor, though additional information is optional.",
              style: TextStyle(color: Color(0xff444444),fontSize: 12, fontFamily: 'segeo',),

            ),
            const SizedBox(height: 24),
            _GradientButton(
              text: "Next",

              onPressed: () {
                // TODO: handle next
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

/// Reusable gradient button at bottom
class _GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const _GradientButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6674F4), Color(0xFF9E5BFE)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600,),
            ),
          ),
        ),
      ),
    );
  }
}

/// Single link-entry field with label above
class _LabeledLinkField extends StatelessWidget {
  final String label;
  const _LabeledLinkField({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(label, style: TextStyle(color: Color(0xff444444),fontSize: 14),),
          const SizedBox(height: 8),

          TextFormField(
            decoration: InputDecoration(
              hintText: "Paste your link here",hoverColor: Color(0xff666666),

              filled: true,
              fillColor: Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}