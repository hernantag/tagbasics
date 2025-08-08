class InputConfig {
  final bool enabled;
  final bool readOnly;
  final bool isPassword;
  final bool dense;
  final bool outlined;
  final bool hasError;
  final bool isFocused;

  const InputConfig({
    this.enabled = true,
    this.readOnly = false,
    this.isPassword = false,
    this.dense = false,
    this.outlined = true,
    this.hasError = false,
    this.isFocused = false,
  });

  InputConfig copyWith({
    bool? enabled,
    bool? readOnly,
    bool? isPassword,
    bool? dense,
    bool? outlined,
    bool? hasError,
    bool? isFocused,
  }) {
    return InputConfig(
      enabled: enabled ?? this.enabled,
      readOnly: readOnly ?? this.readOnly,
      isPassword: isPassword ?? this.isPassword,
      dense: dense ?? this.dense,
      outlined: outlined ?? this.outlined,
      hasError: hasError ?? this.hasError,
      isFocused: isFocused ?? this.isFocused,
    );
  }
}
