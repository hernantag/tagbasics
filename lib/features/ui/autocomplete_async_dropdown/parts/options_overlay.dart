import 'package:flutter/material.dart';

class OptionsOverlay<T> extends StatelessWidget {
  final List<T> options;
  final String Function(T) displayStringForOption;
  final Function(T) onSelected;
  final double? maxWidth;

  const OptionsOverlay({
    super.key,
    required this.options,
    required this.displayStringForOption,
    required this.onSelected,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey.shade200),
          ),
          constraints: BoxConstraints(
            maxHeight: 240,
            maxWidth: maxWidth ?? 280,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              if (options.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.list_alt,
                        color: Colors.grey.shade600,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${options.length} opcion${options.length != 1 ? 'es' : ''} disponible${options.length != 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

              // Options list
              if (options.isEmpty)
                _buildNoOptionsFound()
              else
                Flexible(
                  child: Scrollbar(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options[index];
                        return _OptionItem<T>(
                          option: option,
                          displayString: displayStringForOption(option),
                          onSelected: () => onSelected(option),
                          isLast: index == options.length - 1,
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoOptionsFound() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Icons.search_off, color: Colors.grey.shade400, size: 32),
          const SizedBox(height: 8),
          Text(
            'No se encontraron opciones',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Intenta con otro término de búsqueda',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _OptionItem<T> extends StatefulWidget {
  final T option;
  final String displayString;
  final VoidCallback onSelected;
  final bool isLast;

  const _OptionItem({
    required this.option,
    required this.displayString,
    required this.onSelected,
    required this.isLast,
  });

  @override
  State<_OptionItem<T>> createState() => _OptionItemState<T>();
}

class _OptionItemState<T> extends State<_OptionItem<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onSelected,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered ? Colors.blue.shade50 : Colors.transparent,
            border: !widget.isLast
                ? Border(bottom: BorderSide(color: Colors.grey.shade100))
                : null,
          ),
          child: Row(
            children: [
              Icon(
                Icons.chevron_right,
                color: _isHovered ? Colors.blue.shade600 : Colors.grey.shade400,
                size: 16,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.displayString,
                  style: TextStyle(
                    fontSize: 14,
                    color: _isHovered
                        ? Colors.blue.shade700
                        : Colors.grey.shade800,
                    fontWeight: _isHovered ? FontWeight.w500 : FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
