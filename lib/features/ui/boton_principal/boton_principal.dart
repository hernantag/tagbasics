import 'package:flutter/material.dart';
import 'package:tagbasics/features/theme/colors.dart';

/// Widget personalizado para botones principales con diseño moderno
class BotonPrincipal extends StatelessWidget {
  /// Texto a mostrar en el botón
  final String texto;

  /// Altura del botón (por defecto 50)
  final double? height;

  /// Estado deshabilitado del botón
  final bool deshabilitado;

  /// Estado de carga del botón
  final bool cargando;

  /// Estilo secundario del botón
  final bool secundario;

  /// Función a ejecutar al presionar el botón
  final VoidCallback? onPressed;

  /// Padding interno del botón
  final EdgeInsetsGeometry padding;

  /// Radio de borde personalizado
  final BorderRadius? borderRadius;

  /// Si el botón debe expandirse al ancho disponible
  final bool expanded;

  /// Borde personalizado
  final Border? border;

  /// Color de fondo personalizado
  final Color? color;

  /// Color del texto personalizado
  final Color? fontColor;

  /// Tamaño de fuente personalizado
  final double? fontSize;

  const BotonPrincipal({
    super.key,
    this.texto = "Ok",
    this.height,
    this.deshabilitado = false,
    this.cargando = false,
    this.secundario = false,
    this.expanded = false,
    this.borderRadius,
    this.color,
    this.fontColor,
    this.fontSize,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.border,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: height ?? 50,
      decoration: _buildDecoration(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isDisabled ? null : onPressed,
          borderRadius: _borderRadius,
          child: Container(padding: padding, child: _buildContent()),
        ),
      ),
    );
  }

  /// Indica si el botón está deshabilitado
  bool get _isDisabled => deshabilitado || cargando;

  /// Color de fondo del botón
  Color get _backgroundColor {
    if (_isDisabled) return Colors.grey.shade300;
    if (color != null) return color!;
    return secundario ? Colors.transparent : Colores.violetaSolvix;
  }

  /// Color del texto del botón
  Color get _textColor {
    if (fontColor != null) return fontColor!;
    if (_isDisabled) return Colors.grey.shade600;
    return secundario ? Colores.violetaSolvix : Colors.white;
  }

  /// Radio de borde del botón
  BorderRadius get _borderRadius {
    if (borderRadius != null) return borderRadius!;
    return secundario ? BorderRadius.circular(8) : BorderRadius.circular(12);
  }

  /// Construye la decoración del contenedor
  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: _backgroundColor,
      borderRadius: _borderRadius,
      border:
          border ??
          (secundario
              ? Border.all(
                  color: _isDisabled
                      ? Colors.grey.shade300
                      : Colores.violetaSolvix,
                  width: 2,
                )
              : null),
      boxShadow: _isDisabled || secundario
          ? null
          : [
              BoxShadow(
                color: Colores.violetaSolvix.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
    );
  }

  /// Construye el contenido del botón
  Widget _buildContent() {
    Widget content;

    if (cargando) {
      content = SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(_textColor),
        ),
      );
    } else {
      content = Text(
        texto,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize ?? 16,
          fontWeight: FontWeight.w600,
          color: _textColor,
          letterSpacing: 0.5,
        ),
      );
    }

    if (expanded) {
      return Center(child: content);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [content],
    );
  }
}
