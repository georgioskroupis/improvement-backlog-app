import 'package:flutter/material.dart';
import '../models/improvement_item.dart';

class ImprovementCardView extends StatelessWidget {
  final ImprovementItem item;
  final VoidCallback onTap;

  const ImprovementCardView({
    required this.item,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CircleAvatar(
                    child: Text(
                      item.champion.isNotEmpty
                          ? item.champion[0].toUpperCase()
                          : '?',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Container(
                height: 100.0,
                color: Colors.grey[200], // Placeholder for chart
                child: const Center(
                  child: Text('Chart Placeholder'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
