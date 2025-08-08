import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'parts/input_label.dart';
import 'parts/input_field.dart';
import 'models/input_config.dart';

class InputPersonalizable extends ConsumerStatefulWidget {
  const InputPersonalizable({
    super.key,
    this.controller,
    this.labelNombre,
    this.placeHolder = "",
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.validator,
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
    this.color,
    this.maxWidth,
    this.maxLength,
    this.maxLines,
    this.textCapitalization,
    this.textInputAction,
    this.keyboardType,
    this.inputFormatters,
    this.suffixIcon,
    this.prefixIcon,
    this.isPassword = false,
    this.labelSecundario = "",
    this.helperText,
    this.errorText,
    this.dense = false,
    this.outlined = true,
  });

  // Controllers and basic config
  final TextEditingController? controller;
  final String? labelNombre;
  final String placeHolder;
  final String labelSecundario;
  final String? helperText;
  final String? errorText;

  // Callbacks
  final Function(String)? onChanged;
  final Function()? onTap;
  final Function(String)? onSubmitted;
  final String? Function(String?)? validator;

  // Input configuration
  final FocusNode? focusNode;
  final bool enabled;
  final bool readOnly;
  final bool isPassword;
  final bool dense;
  final bool outlined;

  // Styling
  final Color? color;
  final double? maxWidth;

  // Text input properties
  final int? maxLength;
  final int? maxLines;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  // Icons
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  @override
  ConsumerState<InputPersonalizable> createState() =>
      _InputPersonalizableState();
}

class _InputPersonalizableState extends ConsumerState<InputPersonalizable>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Animation<Color?>? _colorAnimation;

  bool _isPasswordVisible = false;
  bool _isFocused = false;
  bool _hasError = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimationController();
    _setupFocusListener();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _initializeColorAnimation();
      _isInitialized = true;
    }
  }

  void _initializeAnimationController() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  void _initializeColorAnimation() {
    _colorAnimation = ColorTween(
      begin: Colors.grey.shade300,
      end: Theme.of(context).colorScheme.primary,
    ).animate(_animationController);
  }

  void _setupFocusListener() {
    widget.focusNode?.addListener(() {
      final isFocused = widget.focusNode?.hasFocus ?? false;
      if (_isFocused != isFocused) {
        setState(() => _isFocused = isFocused);
        if (isFocused) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  InputConfig get _config => InputConfig(
    enabled: widget.enabled,
    readOnly: widget.readOnly,
    isPassword: widget.isPassword && !_isPasswordVisible,
    dense: widget.dense,
    outlined: widget.outlined,
    hasError: _hasError,
    isFocused: _isFocused,
  );

  Widget _buildInput() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return InputField(
          config: _config,
          controller: widget.controller,
          focusNode: widget.focusNode,
          placeholder: widget.placeHolder,
          helperText: widget.helperText,
          errorText: widget.errorText,
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          textCapitalization: widget.textCapitalization,
          textInputAction: widget.textInputAction,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          onSubmitted: widget.onSubmitted,
          prefixIcon: widget.prefixIcon,
          suffixIcon: _buildSuffixIcon(),
          fillColor: widget.color,
          borderColor: _colorAnimation?.value,
          onValidationChanged: (hasError) {
            if (_hasError != hasError) {
              setState(() => _hasError = hasError);
            }
          },
        );
      },
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.isPassword) {
      return IconButton(
        icon: Icon(
          _isPasswordVisible
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: _isFocused
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade600,
          size: 20,
        ),
        onPressed: () =>
            setState(() => _isPasswordVisible = !_isPasswordVisible),
        tooltip: _isPasswordVisible
            ? 'Ocultar contraseña'
            : 'Mostrar contraseña',
      );
    }
    return widget.suffixIcon;
  }

  @override
  Widget build(BuildContext context) {
    Widget input = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.labelNombre != null)
          InputLabel(
            text: widget.labelNombre!,
            secondaryText: widget.labelSecundario,
            isRequired: widget.labelNombre?.contains('*') ?? false,
            isFocused: _isFocused,
            hasError: _hasError,
          ),
        _buildInput(),
      ],
    );

    if (widget.maxWidth != null) {
      input = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.maxWidth!),
        child: input,
      );
    }

    return input;
  }
}
