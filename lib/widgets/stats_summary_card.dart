import 'package:flutter/material.dart';

class StatsSummaryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Map<String, dynamic> data;

  const StatsSummaryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: data.entries.map((MapEntry<String, dynamic> entry) {
                return SizedBox(
                  width: (MediaQuery.of(context).size.width - 80) / 2,
                  child: _buildStatItem(
                    context,
                    _formatLabel(entry.key),
                    entry.value.toString(),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  String _formatLabel(String key) {
    return key
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (Match match) => ' ${match.group(0)}',
        )
        .replaceFirst(RegExp(r'^\s'), '')
        .split(' ')
        .map((String word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
