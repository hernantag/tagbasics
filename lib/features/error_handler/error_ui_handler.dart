import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tagbasics/features/network/base_request/base_request.dart';

enum ErrorLevel {
  viewmodel(stringCode: "VM -"),
  service(stringCode: "SER -"),
  repository(stringCode: "R -"),
  view(stringCode: "V -"),
  remoteConfig(stringCode: "RCONF -"),
  baseRequest(stringCode: "BRQ -");

  const ErrorLevel({required this.stringCode});

  final String stringCode;
}

enum TipoMensaje { exito, fallo, informacion }

class ManejarErroresHttpScaffoldMessenger {
  static void manejarError(
    DioException error,
    BuildContext context, {
    bool esLogin = false,
  }) {
    if (error.response?.statusCode == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Sin conexión")));
      return;
    }

    if (error.response?.data["message"] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "[${error.response?.statusCode}] ${"- ${error.response?.data["message"]}"}",
          ),
        ),
      );
      return;
    }

    if (error.response?.statusCode == 422) {
      if (esLogin) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("E-mail y/o contraseña incorrectos")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("[422] ${"- ${error.response?.data?["mensaje"]}"}"),
          ),
        );
      }

      return;
    }

    if (error.response?.statusCode == 429) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Demasiadas peticiones en poco tiempo. Espera unos segundos antes de reintentar [429]",
          ),
        ),
      );
      return;
    }
    if (error.response?.statusCode == 408) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Se acabó el tiempo para la petición. Revisa tu conexión. [408]",
          ),
        ),
      );
      return;
    }

    if (error.response?.statusCode == 405) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Se produjo un error [405]")),
      );
      return;
    }

    if (error.response?.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error [401] ${"- ${error.response?.data["mensaje"]}"}",
          ),
        ),
      );
      return;
    }

    if (error.response?.statusCode != null &&
        error.response!.statusCode! > 499) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "El servidor no puede procesar la petición [${error.response?.statusCode}]",
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "El servidor no puede procesar la petición [${error.response?.statusCode}]",
        ),
      ),
    );

    return;
  }
}

class MensajeFacil {
  static void mostrarMensaje(
    String mensaje,
    BuildContext context, {
    TipoMensaje tipoMensaje = TipoMensaje.informacion,
  }) {
    try {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          dismissDirection: DismissDirection.startToEnd,
          backgroundColor: tipoMensaje == TipoMensaje.exito
              ? Colors.green
              : tipoMensaje == TipoMensaje.fallo
              ? Colors.red
              : null,
          content: Text(mensaje, style: const TextStyle(color: Colors.white)),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}

abstract class ErrorHandler {
  static String parseError(
    ErrorLevel nivel,
    Object error, {
    String? customMsg,
  }) {
    String errorString = nivel.stringCode;

    try {
      debugPrint("Error: $error");
      throw error;
    } on DioException {
      errorString = "$errorString ${_parseDioError(error as DioException)}";
    } on TypeError {
      errorString =
          "$errorString [PSE] ${!kReleaseMode ? (error as TypeError).toString() : ""}";
    } on CustomException {
      errorString = "$errorString ${(error as CustomException).cause}";
    } catch (e) {
      errorString =
          "$errorString ${customMsg ?? "Error inesperado"} ${!kReleaseMode ? error.toString() : ""}";
    }

    return errorString;
  }

  static String _parseDioError(DioException exception) {
    try {
      String error = "";

      if (exception.response?.statusCode != null) {
        error = "[${exception.response?.statusCode}]";
      }

      if (exception.response?.data != null) {
        if (exception.response?.data is Map) {
          if ((exception.response?.data as Map).containsKey("message")) {
            error = "$error ${exception.response?.data["message"]}";
          }
        }
      }
      if (error == "") {
        error =
            "Error al realizar la petición ${kReleaseMode ? "" : exception.toString()}";
      }
      return error;
    } catch (e) {
      rethrow;
    }
  }
}
