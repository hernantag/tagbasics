import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'parts/dropdown_field.dart';
import 'parts/selected_item_display.dart';
import 'parts/options_overlay.dart';
import 'utils/text_normalizer.dart';

class AutocompleteAsyncDropdown<T extends Object>
    extends ConsumerStatefulWidget {
  final AsyncValue<List<T>> asyncList;
  final String label;
  final String Function(T) displayStringForOption;
  final void Function(T?) onSelected;
  final T? initialValue;
  final Function()? onClearCallback;
  final Function()? onRefreshCallback;
  final String? Function(String?)? validator;
  final double? maxWidth;
  final String? placeholder;
  final bool enabled;

  const AutocompleteAsyncDropdown({
    super.key,
    required this.asyncList,
    required this.label,
    required this.displayStringForOption,
    required this.onSelected,
    this.initialValue,
    this.onClearCallback,
    this.onRefreshCallback,
    this.validator,
    this.maxWidth,
    this.placeholder,
    this.enabled = true,
  });

  @override
  ConsumerState<AutocompleteAsyncDropdown<T>> createState() =>
      AutocompleteAsyncDropdownState<T>();
}

class AutocompleteAsyncDropdownState<T extends Object>
    extends ConsumerState<AutocompleteAsyncDropdown<T>> {
  late TextEditingController _controller;
  T? _selected;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
    _controller = TextEditingController(
      text: _selected != null ? widget.displayStringForOption(_selected!) : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clearSelection() {
    setState(() {
      _selected = null;
      _controller.clear();
    });
    widget.onSelected(null);
    widget.onClearCallback?.call();
  }

  void _selectOption(T option) {
    setState(() {
      _selected = option;
      _controller.text = widget.displayStringForOption(option);
      _isExpanded = false;
    });
    widget.onSelected(option);
  }

  List<T> _filterOptions(List<T> items, String query) {
    if (query.isEmpty) return items;

    final normalizedQuery = TextNormalizer.normalize(query.toLowerCase());

    return items.where((option) {
      final normalizedOption = TextNormalizer.normalize(
        widget.displayStringForOption(option).toLowerCase(),
      );
      return normalizedOption.contains(normalizedQuery);
    }).toList();
  }

  void reset() {
    setState(() {
      _selected = null;
      _controller.clear();
    });
    widget.onSelected(null);
  }

  @override
  Widget build(BuildContext context) {
    return widget.asyncList.when(
      data: (items) => _buildDropdown(items),
      loading: () => _buildLoadingState(),
      error: (error, stack) => _buildErrorState(),
    );
  }

  Widget _buildDropdown(List<T> items) {
    Widget dropdown = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_selected != null)
          SelectedItemDisplay<T>(
            label: widget.label,
            item: _selected!,
            displayStringForOption: widget.displayStringForOption,
            onClear: widget.enabled ? _clearSelection : null,
          )
        else
          Autocomplete<T>(
            optionsBuilder: (textEditingValue) {
              return _filterOptions(items, textEditingValue.text);
            },
            displayStringForOption: widget.displayStringForOption,
            onSelected: _selectOption,
            fieldViewBuilder:
                (context, controller, focusNode, onFieldSubmitted) {
                  controller.text = _controller.text;
                  return DropdownField(
                    label: widget.label,
                    controller: controller,
                    focusNode: focusNode,
                    validator: widget.validator,
                    placeholder: widget.placeholder,
                    enabled: widget.enabled,
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                  );
                },
            optionsViewBuilder: (context, onSelected, options) {
              return OptionsOverlay<T>(
                options: options.toList(),
                displayStringForOption: widget.displayStringForOption,
                onSelected: onSelected,
                maxWidth: widget.maxWidth,
              );
            },
          ),
      ],
    );

    if (widget.maxWidth != null) {
      dropdown = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.maxWidth!),
        child: dropdown,
      );
    }

    return dropdown;
  }

  Widget _buildLoadingState() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade50,
      ),
      child: SizedBox(
        width: widget.maxWidth ?? double.infinity,
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Cargando ${widget.label.toLowerCase()}...',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.red.shade50,
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600, size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Error al cargar datos',
              style: TextStyle(color: Colors.red.shade700, fontSize: 14),
            ),
          ),
          if (widget.onRefreshCallback != null)
            InkWell(
              onTap: widget.onRefreshCallback,
              child: Container(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.refresh,
                  color: Colors.red.shade600,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
