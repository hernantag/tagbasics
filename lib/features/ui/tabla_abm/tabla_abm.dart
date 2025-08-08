import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tagbasics/features/ui/tabla_abm/tabla_base.dart';

class TablaABMAsync<T> extends StatelessWidget {
  final String? titulo;
  final List<String> columnas;
  final AsyncValue<List<T>> asyncItems;
  final VoidCallback? onAgregar;
  final void Function(T item)? onEditar;
  final void Function(T item)? onEliminar;
  final List<Widget> Function(T item) buildRow;
  final bool? softload;

  const TablaABMAsync({
    super.key,
    this.titulo,
    required this.columnas,
    required this.asyncItems,
    required this.buildRow,
    this.onAgregar,
    this.onEditar,
    this.onEliminar,
    this.softload,
  });

  @override
  Widget build(BuildContext context) {
    return asyncItems.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                'Ocurrió un error al cargar los datos.',
                style: const TextStyle(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Detalles: ${error.toString()}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Implementar lógica para reintentar la solicitud
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
      data: (items) => TablaBase<T>(
        softload: softload,
        titulo: titulo,
        columnas: columnas,
        items: items,
        onAgregar: onAgregar,
        onEditar: onEditar,
        onEliminar: onEliminar,
        buildRow: buildRow,
        paginador: null,
      ),
    );
  }
}
