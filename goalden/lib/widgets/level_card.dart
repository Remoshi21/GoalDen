import 'package:flutter/material.dart';

import '../services/level_service.dart';
import 'user_doc_builder.dart';

class LevelCard extends StatelessWidget {
  const LevelCard({super.key});

  @override
  Widget build(BuildContext context) {
    return UserDocBuilder(
      builder: (context, data) {
        final xp = readNum(data, 'xp').toInt();
        final level = LevelService.levelFromXp(xp);
        final into = LevelService.xpIntoLevel(xp);
        const per = LevelService.xpPerLevel;

        return Card(
          color: Colors.amber.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Level $level • ${LevelService.titleFor(level)}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                LinearProgressIndicator(value: into / per, minHeight: 10),

                const SizedBox(height: 10),

                Text("$into / $per XP"),
              ],
            ),
          ),
        );
      },
    );
  }
}