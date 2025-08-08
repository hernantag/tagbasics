import 'package:flutter/material.dart';

class InputLabel extends StatelessWidget {
  final String text;
  final String secondaryText;
  final bool isRequired;
  final bool isFocused;
  final bool hasError;

  const InputLabel({
    super.key,
    required this.text,
    this.secondaryText = "",
    this.isRequired = false,
    this.isFocused = false,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    Color getLabelColor() {
      if (hasError) return colorScheme.error;
      if (isFocused) return colorScheme.primary;
      return colorScheme.onSurfaceVariant;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            text.replaceAll('*', ''),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: getLabelColor(),
              letterSpacing: 0.1,
            ),
          ),
          if (isRequired) ...[
            const SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorScheme.error,
              ),
            ),
          ],
          if (secondaryText.isNotEmpty) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                secondaryText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
