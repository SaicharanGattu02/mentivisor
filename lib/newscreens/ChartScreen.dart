import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isOutgoing;
  final String senderName;
  final String? avatarUrl;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isOutgoing,
    required this.senderName,
    this.avatarUrl,
    required this.timestamp,
  });
}

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChatScreenFullState();
}

class _ChatScreenFullState extends State<ChartScreen> {
  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
      'Seen many students struggle to for clear road map for the data science i made it simple and clear……',
      isOutgoing: true,
      senderName: 'Suraj',
      avatarUrl: 'assets/images/suraj.jpg',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    ChatMessage(
      text: 'Hello my self Ramesh, let me check the documents',
      isOutgoing: false,
      senderName: 'Vijay',
      avatarUrl: 'assets/images/male_avatar.png',
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
    ),
    ChatMessage(
      text: 'the back statements are not clear please reuploaded it',
      isOutgoing: false,
      senderName: 'Vijay',
      avatarUrl: 'assets/images/male_avatar.png',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
  ];

  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isOutgoing: true,
          senderName: 'Suraj',
          avatarUrl: 'assets/images/suraj.jpg',
          timestamp: DateTime.now(),
        ),
      );
      _inputController.clear();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 120,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
            onPressed: () {
              if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            },
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Chat',
                style: TextStyle(
                  fontFamily: 'Segoe',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          Row(
            children: const [
              Icon(Icons.flag, size: 16, color: Colors.black54),
              SizedBox(width: 4),
              Text(
                'Report',
                style: TextStyle(
                  fontFamily: 'Segoe',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildSubtitleWithReport() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(22),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(
      String title,
      String value,
      List<double> series,
      Color accent,
      ) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Segoe',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Segoe',
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: CustomPaint(
              painter: _MiniLinePainter(data: series, color: accent),
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String name, String? avatarUrl) {
    ImageProvider? provider;
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      if (avatarUrl.startsWith('http')) {
        provider = NetworkImage(avatarUrl);
      } else {
        provider = AssetImage(avatarUrl);
      }
    }
    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.grey.shade300,
      backgroundImage: provider,
      child: provider == null
          ? Text(
        name.isNotEmpty ? name[0] : '?',
        style: const TextStyle(
          fontFamily: 'Segoe',
          fontWeight: FontWeight.w600,
        ),
      )
          : null,
    );
  }

  Widget _buildOutgoingBubble(ChatMessage msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    msg.text,
                    style: const TextStyle(
                      fontFamily: 'Segoe',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              _buildAvatar(msg.senderName, msg.avatarUrl),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '1.1k Viewed',
                style: TextStyle(
                  fontFamily: 'Segoe',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 68,
                height: 24,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: List.generate(4, (i) {
                    return Positioned(
                      left: i * 16.0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const CircleAvatar(
                          radius: 10,
                          backgroundImage: AssetImage(
                            'assets/images/male_avatar.png',
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIncomingBubble(ChatMessage msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(msg.senderName, msg.avatarUrl),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDEEBFF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    msg.text,
                    style: const TextStyle(
                      fontFamily: 'Segoe',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _inputController,
                style: const TextStyle(
                  fontFamily: 'Segoe',
                  fontSize: 14,
                  color: Colors.black87,
                ),
                decoration: const InputDecoration(
                  hintText: 'Say your Words..',
                  hintStyle: TextStyle(
                    fontFamily: 'Segoe',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black38,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.only(bottom: 4),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF8C36FF), Color(0xFF3F9CFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F7FE), Color(0xFFEFF4FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSubtitleWithReport(),
              const SizedBox(height: 6),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _messages.length,
                  itemBuilder: (_, i) {
                    final msg = _messages[i];
                    return msg.isOutgoing
                        ? _buildOutgoingBubble(msg)
                        : _buildIncomingBubble(msg);
                  },
                ),
              ),
              _buildInputBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniLinePainter extends CustomPainter {
  final List<double> data;
  final Color color;

  _MiniLinePainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final line = Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    for (int i = 0; i < data.length; i++) {
      final dx = size.width * (i / (data.length - 1));
      final dy = size.height * (1 - data[i].clamp(0.0, 1.0));
      if (i == 0) {
        path.moveTo(dx, dy);
      } else {
        path.lineTo(dx, dy);
      }
    }
    canvas.drawPath(path, line);

    final last = Offset(
      size.width,
      size.height * (1 - data.last.clamp(0.0, 1.0)),
    );
    canvas.drawCircle(last, 4, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _MiniLinePainter old) =>
      old.data != data || old.color != color;
}
