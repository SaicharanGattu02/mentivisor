import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

  class ChartScreen extends StatelessWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  // Fill entire background with a subtle left-to-right gradient
  body: Container(
  decoration: const BoxDecoration(
  gradient: LinearGradient(
  colors: [Color(0xFFEEEEEE), Color(0xFFEFF4FF)],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  ),
  ),
  child: SafeArea(
  child: Column(
  children: [
  // ——— Header ———
  Padding(
  padding:
  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  child: Row(
  children: [
  // Back arrow
  IconButton(
  icon: const Icon(Icons.arrow_back_ios),
  onPressed: () => Navigator.pop(context),
  ),
  const Spacer(),
  const Text(
  'Chat',
  style: TextStyle(
  fontFamily: 'Sugeo',
  fontWeight: FontWeight.w600,
  fontSize: 18,
  ),
  ),
  const Spacer(flex: 2),
  ],
  ),
  ),

  // ——— Subtitle ———
  const Padding(
  padding: EdgeInsets.only(bottom: 16),
  child: Text(
  'Beyond Campus Chat',
  style: TextStyle(
  fontFamily: 'Sugeo',
  fontWeight: FontWeight.w400,
  fontSize: 14,
  color: Colors.black54,
  ),
  ),
  ),

  // ——— Messages ———
  Expanded(
  child: ListView(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  children: [
  // Outgoing (right-aligned) bubble
  Align(
  alignment: Alignment.centerRight,
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.end,
  children: [
  // Avatar + bubble
  Row(
  mainAxisSize: MainAxisSize.min,
  children: [
  // Bubble
  Flexible(
  child: Container(
  padding: const EdgeInsets.all(12),
  margin: const EdgeInsets.only(right: 8),
  decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16),
  ),
  child: const Text(
  'Seen many students struggle to for clear road map for the data science i made it simple and clear……',
  style: TextStyle(
  fontFamily: 'Sugeo',
  fontWeight: FontWeight.w400,
  fontSize: 14,
  color: Colors.black87,
  ),
  ),
  ),
  ),
  // Avatar
  const CircleAvatar(
  radius: 16,
  backgroundImage:
  AssetImage('images/suraj.jpg'),
  ),
  ],
  ),
  const SizedBox(height: 8),
  // Viewed indicator
  Row(
  mainAxisSize: MainAxisSize.min,
  children: [
  const Text(
  '1.1k Viewed',
  style: TextStyle(
  fontFamily: 'Sugeo',
  fontWeight: FontWeight.w400,
  fontSize: 12,
  color: Colors.black54,
  ),
  ),
  const SizedBox(width: 8),
  // Small row of avatars
  ...List.generate(4, (_) {
  return Container(
  margin: const EdgeInsets.only(left: 8),
  decoration: BoxDecoration(
  border:
  Border.all(color: Colors.white, width: 2),
  shape: BoxShape.circle,
  ),
  child: const CircleAvatar(
  radius: 10,
  backgroundImage:
  AssetImage('images/profileimg.png'),
  ),
  );
  }),
  ],
  ),
  ],
  ),
  ),

  const SizedBox(height: 24),

  // Incoming (left-aligned) bubbles
  Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const CircleAvatar(
  radius: 16,
  backgroundImage: AssetImage('images/profileimg.png'),
  ),
  const SizedBox(width: 8),
  Flexible(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Container(
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
  color: Color(0xffDEEBFF),
  borderRadius: BorderRadius.circular(16),
  ),
  child: const Text(
  'Hello my self Ramesh, Let me check the documents',
  style: TextStyle(
  fontFamily: 'Sugeo',
  fontWeight: FontWeight.w400,
  fontSize: 14,
  ),
  ),
  ),
  const SizedBox(height: 8),
  Container(
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
  color: Colors.blue.shade100,
  borderRadius: BorderRadius.circular(16),
  ),
  child: const Text(
  'the back statements are not clear please reuploaded it',
  style: TextStyle(
  fontFamily: 'Sugeo',
  fontWeight: FontWeight.w400,
  fontSize: 14,
  ),
  ),
  ),
  ],
  ),
  ),
  ],
  ),

  const SizedBox(height: 16),
  ],
  ),
  ),

  // ——— Input Bar ———
  Padding(
  padding:
  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  child: Container(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  height: 48,
  decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(24),
  ),
  child: Row(
  children: [
  const Expanded(
  child: TextField(
  decoration: InputDecoration(
  hintText: 'Say your Words…',
  border: InputBorder.none,
  hintStyle: TextStyle(
  fontFamily: 'Sugeo',
  fontWeight: FontWeight.w400,
  fontSize: 14,
  color: Colors.black38,
  ),
  ),
  ),
  ),
  Container(
  padding: const EdgeInsets.all(8),
  decoration: const BoxDecoration(
  shape: BoxShape.circle,
  gradient: LinearGradient(
  colors: [Color(0xFF8C36FF), Color(0xFF3F9CFF)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  ),
  ),
  child: const Icon(
  Icons.send,
  color: Colors.white,
  ),
  ),
  ],
  ),
  ),
  ),
  ],
  ),
  ),
  ),
  );
  }
  }