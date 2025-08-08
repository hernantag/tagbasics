import 'package:flutter/material.dart';

class SelectedItemDisplay<T> extends StatelessWidget {
  final String label;
  final T item;
  final String Function(T) displayStringForOption;
  final VoidCallback? onClear;

  const SelectedItemDisplay({
    super.key,
    required this.label,
    required this.item,
    required this.displayStringForOption,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),

        // Selected item container
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.shade300, width: 1.5),
          ),
          child: Row(
            children: [
              // Check icon
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),

              const SizedBox(width: 12),

              // Selected text
              Expanded(
                child: Text(
                  displayStringForOption(item),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.green.shade800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Clear button
              if (onClear != null)
                InkWell(
                  onTap: onClear,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.close,
                      color: Colors.green.shade600,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
