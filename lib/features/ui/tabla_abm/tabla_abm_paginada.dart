import 'package:flutter/material.dart';
import 'package:tagbasics/features/ui/tabla_abm/tabla_base.dart';

class TablaABMViewmodelPaginated<T> extends StatelessWidget {
  final String? titulo;
  final int total;
  final int paginaActual;
  final int filasPorPagina;
  final bool cargando;
  final bool? softload;
  final String? error;
  final List<T> items;
  final VoidCallback? onAgregar;
  final void Function(T item)? onEditar;
  final void Function(T item)? onEliminar;
  final void Function(int nuevaPagina) onPaginaCambiada;
  final List<String> columnas;
  final List<Widget> Function(T item) buildRow;
  final Widget? filtro;

  const TablaABMViewmodelPaginated({
    super.key,
    this.filtro,
    this.titulo,
    required this.total,
    required this.paginaActual,
    this.filasPorPagina = 10,
    required this.cargando,
    this.error,
    required this.items,
    this.onAgregar,
    required this.onPaginaCambiada,
    required this.columnas,
    required this.buildRow,
    this.onEditar,
    this.onEliminar,
    this.softload,
  });

  @override
  Widget build(BuildContext context) {
    final totalPaginas = (total / filasPorPagina).ceil();

    return TablaBase<T>(
      softload: softload,
      titulo: titulo,
      columnas: columnas,
      items: items,
      cargando: cargando,
      error: error,
      onAgregar: onAgregar,
      onEditar: onEditar,
      onEliminar: onEliminar,
      buildRow: buildRow,
      filtro: filtro,
      paginador: totalPaginas > 1
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _buildPaginador(
                  paginaActual,
                  totalPaginas,
                  onPaginaCambiada,
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }
}

List<Widget> _buildPaginador(
  int paginaActual,
  int totalPaginas,
  void Function(int) onPaginaCambiada,
) {
  const maxVisible = 5;
  final List<Widget> botones = [];

  int start = paginaActual - (maxVisible ~/ 2);
  int end = paginaActual + (maxVisible ~/ 2);

  if (start < 1) {
    end += (1 - start);
    start = 1;
  }
  if (end > totalPaginas) {
    start -= (end - totalPaginas);
    end = totalPaginas;
    if (start < 1) start = 1;
  }

  if (start > 1) {
    botones.add(_paginaBoton(1, paginaActual, onPaginaCambiada));
    if (start > 2) {
      botones.add(
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Text('...'),
        ),
      );
    }
  }

  for (int i = start; i <= end; i++) {
    botones.add(_paginaBoton(i, paginaActual, onPaginaCambiada));
  }

  if (end < totalPaginas) {
    if (end < totalPaginas - 1) {
      botones.add(
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Text('...'),
        ),
      );
    }
    botones.add(_paginaBoton(totalPaginas, paginaActual, onPaginaCambiada));
  }

  return botones;
}

Widget _paginaBoton(int numero, int paginaActual, void Function(int) onTap) {
  final activo = numero == paginaActual;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: activo ? Colors.indigo : null,
        foregroundColor: activo ? Colors.white : Colors.black87,
        side: BorderSide(color: activo ? Colors.indigo : Colors.grey.shade400),
        minimumSize: const Size(40, 40),
        padding: EdgeInsets.zero,
      ),
      onPressed: () => onTap(numero),
      child: Text('$numero'),
    ),
  );
}
