import 'package:equatable/equatable.dart';

abstract class FiltrosDataPaginada extends Equatable {
  const FiltrosDataPaginada({required this.pagActual});

  final int pagActual;
  Map<String, dynamic> toJson();
  FiltrosDataPaginada resetPagActual();
  FiltrosDataPaginada nextPage();
}

class RespuestaPaginada<T> {
  RespuestaPaginada({
    required this.tope,
    required this.cantidadTotal,
    required this.porPagina,
    required this.filtros,
    required this.data,
  });

  final int tope;
  final int cantidadTotal;
  final int porPagina;
  final FiltrosDataPaginada filtros;
  final List<T> data;
}
