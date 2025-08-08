import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/input_config.dart';

class InputField extends StatefulWidget {
  final InputConfig config;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String placeholder;
  final String? helperText;
  final String? errorText;
  final int? maxLength;
  final int? maxLines;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function()? onTap;
  final Function(String)? onSubmitted;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final Color? borderColor;
  final Function(bool)? onValidationChanged;

  const InputField({
    super.key,
    required this.config,
    this.controller,
    this.focusNode,
    this.placeholder = "",
    this.helperText,
    this.errorText,
    this.maxLength,
    this.maxLines,
    this.textCapitalization,
    this.textInputAction,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.borderColor,
    this.onValidationChanged,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _errorText = widget.errorText;
  }

  void _handleValidation(String? value) {
    if (widget.validator != null) {
      final error = widget.validator!(value);
      if (_errorText != error) {
        setState(() => _errorText = error);
        widget.onValidationChanged?.call(error != null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: widget.config.isFocused
                ? [
                    BoxShadow(
                      color: (widget.borderColor ?? colorScheme.primary).withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            enabled: widget.config.enabled,
            readOnly: widget.config.readOnly,
            obscureText: widget.config.isPassword,
            maxLength: widget.maxLength,
            maxLines: widget.maxLines ?? 1,
            textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
            textInputAction: widget.textInputAction,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            onChanged: (value) {
              _handleValidation(value);
              widget.onChanged?.call(value);
            },
            onTap: widget.onTap,
            onFieldSubmitted: widget.onSubmitted,
            style: textTheme.bodyLarge?.copyWith(
              color: widget.config.enabled 
                  ? colorScheme.onSurface 
                  : colorScheme.onSurface.withOpacity(0.6),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: widget.placeholder,
              helperText: widget.helperText,
              errorText: _errorText,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              filled: true,
              fillColor: _getFillColor(colorScheme),
              border: _getBorder(colorScheme),
              enabledBorder: _getBorder(colorScheme),
              focusedBorder: _getFocusedBorder(colorScheme),
              errorBorder: _getErrorBorder(colorScheme),
              focusedErrorBorder: _getErrorBorder(colorScheme),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: widget.config.dense ? 12 : 16,
              ),
              hintStyle: TextStyle(
                color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              helperStyle: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
              errorStyle: TextStyle(
                color: colorScheme.error,
                fontSize: 12,
              ),
              counterStyle: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getFillColor(ColorScheme colorScheme) {
    if (widget.fillColor != null) return widget.fillColor!;
    if (!widget.config.enabled) return colorScheme.surfaceVariant.withOpacity(0.3);
    if (widget.config.hasError) return colorScheme.errorContainer.withOpacity(0.1);
    if (widget.config.isFocused) return colorScheme.primaryContainer.withOpacity(0.1);
    return colorScheme.surfaceVariant.withOpacity(0.5);
  }

  OutlineInputBorder _getBorder(ColorScheme colorScheme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: widget.config.enabled 
            ? colorScheme.outline.withOpacity(0.5)
            : colorScheme.outline.withOpacity(0.3),
        width: 1,
      ),
    );
  }

  OutlineInputBorder _getFocusedBorder(ColorScheme colorScheme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: widget.borderColor ?? colorScheme.primary,
        width: 2,
      ),
    );
  }

  OutlineInputBorder _getErrorBorder(ColorScheme colorScheme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: colorScheme.error,
        width: 2,
      ),
    );
  }
}
