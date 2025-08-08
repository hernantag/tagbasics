import 'package:intl/intl.dart';

class FuncionesUtiles {
  static String formatearFecha(String fecha) {
    DateFormat oldFormat = DateFormat('yyyy-MM-dd');
    DateFormat newFormat = DateFormat('dd/MM/yyyy');

    String result = newFormat.format(oldFormat.parse(fecha));

    return result;
  }

  static String formatearHora(String hora) {
    DateFormat oldFormat = DateFormat('hh:mm:ss');
    DateFormat newFormat = DateFormat('hh:mm a');

    String result = newFormat.format(oldFormat.parse(hora));

    return result;
  }

  static String formatearFechaHora(String fecha) {
    DateFormat oldFormat = DateFormat('yyyy-MM-ddThh:mm:ss a');
    DateFormat newFormat = DateFormat('dd/MM/yyyy hh:mm');

    String result = newFormat.format(oldFormat.parse(fecha));

    return result;
  }

  static String formatearFechaHoraExacto(String fecha) {
    // oldFormat should match the input string exactly.
    // 'T' and 'Z' are literal characters.
    // 'HH' for 24-hour format (00-23).
    // '.SSSSSS' for microseconds (or '.SSS' for milliseconds if you prefer to truncate).
    // No 'a' (AM/PM) needed for the input format.
    DateFormat oldFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'");

    // newFormat for the desired output.
    // 'hh' for 12-hour format (01-12) and 'a' for AM/PM.
    DateFormat newFormat = DateFormat('dd/MM/yyyy hh:mm a');

    // It's good practice to wrap parsing in a try-catch block
    try {
      DateTime dateTime = oldFormat.parse(
        fecha,
        true,
      ); // The 'true' indicates it's a UTC date

      // You might want to convert to local time before formatting if that's the intention.
      // If you want the output to be in local time based on the device's timezone:
      // dateTime = dateTime.toLocal();

      String result = newFormat.format(dateTime);
      return result;
    } catch (e) {
      print("Error parsing date: $e");
      return "Invalid Date"; // Or throw an exception, handle as appropriate
    }
  }

  static String formatearFechaYhora(String fechaOriginal) {
    final fecha = DateTime.parse(fechaOriginal).toLocal(); // 👈 necesario
    final formatter = DateFormat('dd/MM/yyyy HH:mm', 'es');
    return formatter.format(fecha);
  }

  static String formatearFechaColoquial(String fecha) {
    DateFormat oldFormat = DateFormat('yyyy-MM-dd');
    DateFormat newFormat = DateFormat('MMMMEEEEd');

    String result = newFormat.format(oldFormat.parse(fecha));

    result = result.replaceFirst(result[0], result[0].toUpperCase());

    return result;
  }

  static String formatearFechaColoquialConAnio(String fecha) {
    DateFormat oldFormat = DateFormat('yyyy-MM-dd');
    DateFormat newFormat = DateFormat('EEEE d MMMM yyyy');

    String result = newFormat.format(oldFormat.parse(fecha));

    result = result.replaceFirst(result[0], result[0].toUpperCase());

    return result;
  }

  static String formatColoquialFechaDesdeDateTime(DateTime fecha) {
    DateFormat newFormat = DateFormat(' EEEE d MMMM yyyy');

    String result = newFormat.format(fecha);

    result = result.replaceFirst(result[0], result[0].toUpperCase());

    return result;
  }

  static String formatFechaYhoraDT(DateTime fecha) {
    DateFormat newFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    String result = newFormat.format(fecha);

    return result;
  }

  static String formatFechaDesdeDateTime(DateTime fecha) {
    DateFormat newFormat = DateFormat('yyyy-MM-dd');

    String result = newFormat.format(fecha);

    return result;
  }

  static String getCantidadDias(String fecha) {
    DateFormat fullFecha = DateFormat('yyyy-MM-ddThh:mm:ss');
    DateFormat fechaOnly = DateFormat('yyyy-MM-dd');
    final DateTime fechaHoy = DateTime.now();

    final DateTime fullFechaParsed = fullFecha.parse(fecha);
    final DateTime fechaOnlyParsed = fechaOnly.parse(fecha);
    final DateTime fechaHoyParsed = fechaOnly.parse(fechaHoy.toString());

    final Duration diferencia = fechaHoyParsed.difference(fechaOnlyParsed);

    if (diferencia.inDays > 7) {
      final int cantidadSemanas = (diferencia.inDays / 7).floor();

      return "$cantidadSemanas ${cantidadSemanas == 1 ? "semana" : "semanas"}";
    }

    if (diferencia.inDays == 0) {
      return "${fullFechaParsed.hour.toString().padLeft(2, "0")}:${fullFechaParsed.minute.toString().padLeft(2, "0")}";
    }

    return "${diferencia.inDays} ${diferencia.inDays == 1 ? "dia" : "dias"}";
  }
}
