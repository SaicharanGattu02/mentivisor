import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

  // Sample data for achievements
  final List<_Achievement> _achievements = const [
    _Achievement(
      title: 'Sessions Completed',
      count: 3,
      coins: 120,
      icon: Icons.fitness_center,
    ),
    _Achievement(
      title: 'Daily Check‑ins',
      count: 7,
      coins: 35,
      icon: Icons.calendar_today,
    ),
    _Achievement(
      title: 'Profile Updates',
      count: 3,
      coins: 15,
      icon: Icons.person,
    ),
    _Achievement(
      title: 'Reviews Given',
      count: 5,
      coins: 25,
      icon: Icons.rate_review,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'My Wallet',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage your coins and track your earnings',
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                const SizedBox(height: 24),

                // Gradient balance card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD54F), Color(0xFFFFA726)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Coin icon
                      const Icon(Icons.monetization_on, size: 40, color: Colors.white70),

                      const SizedBox(height: 16),

                      // Balance label
                      Text(
                        'Current Balance',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
                      ),

                      const SizedBox(height: 8),

                      // Balance amount
                      Text(
                        '150',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Earned / Spent row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Total Earned', style: TextStyle(color: Colors.white70)),
                              SizedBox(height: 4),
                              Text('480', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              Text('Total Spent', style: TextStyle(color: Colors.white70)),
                              SizedBox(height: 4),
                              Text('330', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Buy coins button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.add_circle_outline),
                          label: const Text('Buy Coins'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.orange, backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Daily Check‑in card
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Gift icon
                        const Icon(Icons.card_giftcard, size: 32, color: Colors.purple),
                        const SizedBox(width: 12),
                        // Texts + button
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Daily Check‑in',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              const Text('Current Streak: 7 days'),
                              const Text('Earn 5 coins per day + bonus for streaks!'),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Check In Today'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Achievements header
                Text(
                  'Your Achievements',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // Achievements list
                Column(
                  children: _achievements
                      .map((ach) => _AchievementTile(achievement: ach))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Model for achievement
class _Achievement {
  final String title;
  final int count;
  final int coins;
  final IconData icon;

  const _Achievement({
    required this.title,
    required this.count,
    required this.coins,
    required this.icon,
  });
}

// Individual achievement row
class _AchievementTile extends StatelessWidget {
  final _Achievement achievement;

  const _AchievementTile({Key? key, required this.achievement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(achievement.icon, color: Colors.deepPurple),
        ),
        title: Text(achievement.title),
        subtitle: Text('${achievement.count} completed'),
        trailing: Text(
          '+${achievement.coins}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
}
