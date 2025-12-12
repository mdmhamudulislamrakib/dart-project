import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/weather_model.dart';

class FutureForcastListItem extends StatelessWidget {
  final Forecastday? forecastday;
  final String? localtime; // location local time string

  const FutureForcastListItem({Key? key, required this.forecastday, this.localtime}) : super(key: key);

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final dt = DateTime.parse(date);
      return DateFormat.MMMEd().format(dt);
    } catch (_) {
      return '';
    }
  }

  String? _resolveIconUrl(String? icon) {
    if (icon == null || icon.isEmpty) return null;
    final trimmed = icon.trim();
    if (trimmed.startsWith('//')) return 'https:$trimmed';
    if (trimmed.startsWith('http')) return trimmed;
    return 'https://$trimmed';
  }

  String _formatTime(String? local) {
    if (local == null || local.isEmpty) return '';
    try {
      final dt = DateTime.parse(local);
      return DateFormat.jm().format(dt);
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconUrl = _resolveIconUrl(forecastday?.day?.condition?.icon?.toString());
    final dateText = _formatDate(forecastday?.date?.toString());
    final timeText = _formatTime(localtime);
    final maxTemp = forecastday?.day?.maxtempC?.round().toString() ?? '';
    final minTemp = forecastday?.day?.mintempC?.round().toString() ?? '';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.all(8),
      width: double.infinity,
      child: Row(
        children: [
          // Circular icon with teal background, matching hourly weather style
          SizedBox(
            height: 50,
            width: 50,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.teal,
              ),
              child: ClipOval(
                child: iconUrl != null
                    ? Image.network(
                        iconUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stack) => const Icon(
                          Icons.wb_sunny,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.wb_sunny,
                        color: Colors.white,
                      ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (timeText.isNotEmpty)
                  Text(
                    timeText,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              forecastday?.day?.condition?.text ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Text(
              '$maxTemp°/$minTemp°',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
