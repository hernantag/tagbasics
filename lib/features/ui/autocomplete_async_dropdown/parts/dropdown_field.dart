import 'package:flutter/material.dart';

class DropdownField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? Function(String?)? validator;
  final String? placeholder;
  final bool enabled;
  final VoidCallback? onTap;

  const DropdownField({
    super.key,
    required this.label,
    required this.controller,
    required this.focusNode,
    this.validator,
    this.placeholder,
    this.enabled = true,
    this.onTap,
  });

  @override
  State<DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = widget.focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _isFocused
                        ? Colors.blue.shade700
                        : Colors.grey.shade700,
                  ),
                ),
                if (widget.label.contains('*'))
                  Text(
                    ' *',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.red.shade600,
                    ),
                  ),
              ],
            ),
          ),

        // Input field with dropdown indicator
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              if (_isFocused)
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            enabled: widget.enabled,
            validator: widget.validator,
            onTap: widget.onTap,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            decoration: InputDecoration(
              hintText: widget.placeholder ?? 'Buscar o seleccionar...',
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
              filled: true,
              fillColor: widget.enabled ? Colors.white : Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.red.shade400),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.red.shade400, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              suffixIcon: Container(
                margin: const EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.expand_more,
                  color: _isFocused
                      ? Colors.blue.shade600
                      : Colors.grey.shade500,
                  size: 24,
                ),
              ),
              prefixIcon: Container(
                margin: const EdgeInsets.only(left: 12, right: 8),
                child: Icon(
                  Icons.search,
                  color: _isFocused
                      ? Colors.blue.shade600
                      : Colors.grey.shade400,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
