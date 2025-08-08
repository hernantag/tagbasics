import 'package:flutter/material.dart';
import 'package:tagbasics/features/theme/colors.dart';

class TablaBase<T> extends StatelessWidget {
  final String? titulo;
  final List<String> columnas;
  final List<T> items;
  final VoidCallback? onAgregar;
  final void Function(T item)? onEditar;
  final void Function(T item)? onEliminar;
  final List<Widget> Function(T item) buildRow;
  final bool cargando;
  final String? error;
  final Widget? paginador;
  final bool? softload;
  final VoidCallback? onRetry;
  final Widget? filtro;

  const TablaBase({
    super.key,
    this.filtro,
    required this.columnas,
    required this.items,
    this.onAgregar,
    required this.buildRow,
    this.titulo,
    this.onEditar,
    this.onEliminar,
    this.cargando = false,
    this.error,
    this.paginador,
    this.softload,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 18),
              ],
              color: Colors.white,
            ),
            child: Column(
              children: [
                _TablaHeader(titulo: titulo, onAgregar: onAgregar),
                if (filtro != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: filtro!,
                  ),
                if (softload == true) const LinearProgressIndicator(),
                _TablaContenido<T>(
                  columnas: columnas,
                  items: items,
                  buildRow: buildRow,
                  onEditar: onEditar,
                  onEliminar: onEliminar,
                  cargando: cargando,
                  error: error,
                  onRetry: onRetry,
                  constraints: constraints,
                ),
                if (paginador != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: paginador!,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TablaHeader extends StatelessWidget {
  final String? titulo;
  final VoidCallback? onAgregar;

  const _TablaHeader({this.titulo, this.onAgregar});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colores.violetaSolvix, Colores.nuevoAzul],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (titulo != null)
            Text(
              titulo!,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
          if (onAgregar != null)
            ElevatedButton.icon(
              onPressed: onAgregar,
              icon: const Icon(Icons.add),
              label: const Text("Nuevo"),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.indigo.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TablaContenido<T> extends StatelessWidget {
  final List<String> columnas;
  final List<T> items;
  final List<Widget> Function(T item) buildRow;
  final void Function(T item)? onEditar;
  final void Function(T item)? onEliminar;
  final bool cargando;
  final String? error;
  final VoidCallback? onRetry;
  final BoxConstraints constraints;

  const _TablaContenido({
    required this.columnas,
    required this.items,
    required this.buildRow,
    required this.onEditar,
    required this.onEliminar,
    required this.cargando,
    required this.error,
    required this.onRetry,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (error != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'Ocurrió un error al cargar los datos.',
                style: TextStyle(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Detalles: ${error.toString()}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (onRetry != null)
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Reintentar'),
                ),
            ],
          ),
        ),
      );
    }

    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Text(
            "No hay registros disponibles.",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: constraints.maxWidth),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Colors.indigo.shade50),
          columnSpacing: 32,
          dataRowMaxHeight: 52,
          dividerThickness: 0.5,
          columns: [
            ...columnas.map(
              (col) => DataColumn(
                label: Text(
                  col,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            if (onEditar != null || onEliminar != null)
              const DataColumn(
                label: Text(
                  'Acciones',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
          ],
          rows: items.map((item) {
            final celdas = buildRow(item);
            return DataRow(
              color: WidgetStateProperty.resolveWith<Color?>(
                (states) => states.contains(WidgetState.hovered)
                    ? Colors.grey.shade100
                    : null,
              ),
              cells: [
                ...celdas.map((w) => DataCell(w)),
                if (onEditar != null || onEliminar != null)
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (onEditar != null)
                          _ActionIconButton(
                            icon: Icons.edit,
                            color: Colors.orange,
                            onPressed: () => onEditar!(item),
                          ),
                        if (onEliminar != null) const SizedBox(width: 8),
                        if (onEliminar != null)
                          _ActionIconButton(
                            icon: Icons.delete,
                            color: Colors.red,
                            onPressed: () => onEliminar!(item),
                          ),
                      ],
                    ),
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionIconButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: color, size: 18),
      onPressed: onPressed,
      splashRadius: 20,
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints(),
      style: IconButton.styleFrom(
        backgroundColor: color.withAlpha(25),
        shape: const CircleBorder(),
      ),
    );
  }
}
