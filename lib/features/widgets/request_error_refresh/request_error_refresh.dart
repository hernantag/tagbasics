import 'package:flutter/material.dart';
import 'package:tagbasics/features/network/base_request/base_request.dart';

class ErrorRequest extends StatelessWidget {
  const ErrorRequest({
    super.key,
    required this.fnRefresh,
    this.error,
    this.message = "Ocurrió un error",
    this.btnMessage = "Vuelve a intentarlo",
    this.icon,
    this.padding = const EdgeInsets.all(24.0),
    this.spacing = 24.0,
    this.textStyle,
    this.buttonStyle,
  });

  final String message;
  final String btnMessage;
  final Function fnRefresh;
  final CustomException? error;

  // New optional parameters for modernization
  final IconData? icon;
  final EdgeInsets padding;
  final double spacing;
  final TextStyle? textStyle;
  final ButtonStyle? buttonStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 64,
              color: theme.colorScheme.error.withOpacity(0.7),
            ),
            SizedBox(height: spacing * 0.5),
          ],
          Text(
            error != null ? error!.cause : message,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style:
                textStyle ??
                theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                  height: 1.4,
                ),
          ),
          SizedBox(height: spacing),
          FilledButton.tonal(
            onPressed: () => fnRefresh(),
            style: buttonStyle,
            child: Text(btnMessage),
          ),
        ],
      ),
    );
  }
}
