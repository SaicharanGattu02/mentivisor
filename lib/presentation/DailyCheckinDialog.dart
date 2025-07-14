import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DailyCheckinDialog extends StatelessWidget {
  const DailyCheckinDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xffeef2ff), Color(0xffe0f2fe)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFa855f7), Color(0xFF2563eb)],
                ),
              ),
              child: const Icon(
                Icons.card_giftcard,
                size: 40,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Daily Check-in Complete! ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'segeo',
                  ),
                ),
                Icon(Icons.check_box, color: Colors.green),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Great consistency! ⭐',
              style: TextStyle(fontSize: 14, fontFamily: 'segeo'),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    '🔥 7 Day Streak',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'segeo',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      7,
                      (index) => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        child: Icon(Icons.circle, color: Colors.red, size: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _rewardRow(
              Icons.calendar_today,
              'Daily Check-in',
              '+5',
              Colors.blue,
            ),
            const SizedBox(height: 10),
            _rewardRow(Icons.star, 'Streak Bonus', '+5', Colors.orange),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff22c55e), Color(0xff059669)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Earned',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'segeo',
                    ),
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      SvgPicture.asset(
                        'assets/svg_icons/coins.svg',
                        color: Colors.white,
                        width: 15,height: 15,
                      ),
                      Text(
                        '+10',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'segeo',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Next milestone:\n7 more days for +10 bonus coins',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, fontFamily: 'segeo'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              width: 150,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xffa855f7), Color(0xff3b82f6)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Claim Reward",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'segeo',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rewardRow(IconData icon, String title, String reward, Color color) {
    return   Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(title, style: const TextStyle(fontFamily: 'segeo')),
          ),
          Row(
            spacing: 5,
            children: [
              SvgPicture.asset(
                'assets/svg_icons/coins.svg',
                color: color,
                width: 15,height: 15,
              ),
              Text(
                reward,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'segeo',
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
