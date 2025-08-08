import 'package:flutter/services.dart';

class CustomFilter extends TextInputFormatter {
  const CustomFilter({required this.regex});

  final RegExp regex;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (regex.hasMatch(newValue.text)) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}

class PoliceInputFormatters {
  /// Formatter para dominios argentinos (ABC123 o AB123CD)
  static final dominio = FilteringTextInputFormatter.allow(
    RegExp(r'[A-Za-z0-9]'),
  );

  /// Formatter para números de documento
  static final dni = FilteringTextInputFormatter.allow(
    RegExp(r'[0-9]'),
  );

  /// Formatter para nombres (solo letras y espacios)
  static final nombre = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]'),
  );

  /// Formatter para teléfonos argentinos
  static final telefono = FilteringTextInputFormatter.allow(
    RegExp(r'[0-9\-\+\(\)\s]'),
  );

  /// Formatter para direcciones
  static final direccion = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z0-9áéíóúÁÉÍÓÚñÑ\s\.\,\-]'),
  );
}
