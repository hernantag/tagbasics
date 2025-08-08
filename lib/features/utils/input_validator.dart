class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
  @override
  String toString() => message;
}

extension InputValidators on String? {
  String notNull([String? errorMessage]) {
    if (this == null) {
      throw ValidationException(errorMessage ?? 'El valor no puede ser nulo.');
    }
    return this!;
  }

  String notEmpty([String? errorMessage]) {
    final value = this?.trim();
    if (value == null || value.isEmpty) {
      throw ValidationException(
        errorMessage ?? 'El campo no puede estar vacío.',
      );
    }
    return value;
  }

  String isNumeric([String? errorMessage]) {
    final value = this?.trim();
    if (value == null || double.tryParse(value) == null) {
      throw ValidationException(errorMessage ?? 'El valor debe ser numérico.');
    }
    return value;
  }

  String isPositive([String? errorMessage]) {
    final num? val = num.tryParse(this ?? '');
    if (val == null || val <= 0) {
      throw ValidationException(errorMessage ?? 'Debe ser un número positivo.');
    }
    return this!;
  }

  String isNegative([String? errorMessage]) {
    final num? val = num.tryParse(this ?? '');
    if (val == null || val >= 0) {
      throw ValidationException(errorMessage ?? 'Debe ser un número negativo.');
    }
    return this!;
  }

  String inRange(num min, num max, [String? errorMessage]) {
    final num? val = num.tryParse(this ?? '');
    if (val == null || val < min || val > max) {
      throw ValidationException(
        errorMessage ?? 'El valor debe estar entre $min y $max.',
      );
    }
    return this!;
  }

  String isValidDate({String format = 'dd/MM/yyyy', String? errorMessage}) {
    try {
      final parts = this!.split('/');
      if (parts.length != 3) throw FormatException();
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final date = DateTime(year, month, day);
      if (date.day != day || date.month != month || date.year != year) {
        throw FormatException();
      }
      return this!;
    } catch (_) {
      throw ValidationException(
        errorMessage ?? 'Fecha inválida. Formato esperado: $format',
      );
    }
  }

  String isDate({String? errorMessage}) {
    try {
      DateTime.parse(this?.trim() ?? "");
      return this!;
    } catch (_) {
      throw ValidationException(errorMessage ?? 'Fecha inválida.');
    }
  }

  String minLength(int length, [String? errorMessage]) {
    final value = this ?? '';
    if (value.length < length) {
      throw ValidationException(
        errorMessage ?? 'Debe tener al menos $length caracteres.',
      );
    }
    return value;
  }

  String maxLength(int length, [String? errorMessage]) {
    final value = this ?? '';
    if (value.length > length) {
      throw ValidationException(
        errorMessage ?? 'No puede superar los $length caracteres.',
      );
    }
    return value;
  }

  String matches(RegExp pattern, [String? errorMessage]) {
    final value = this ?? '';
    if (!pattern.hasMatch(value)) {
      throw ValidationException(errorMessage ?? 'Formato inválido.');
    }
    return value;
  }

  String isEmail([String? errorMessage]) {
    const pattern = r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$';
    return matches(
      RegExp(pattern),
      errorMessage ?? 'Correo electrónico inválido.',
    );
  }
}
