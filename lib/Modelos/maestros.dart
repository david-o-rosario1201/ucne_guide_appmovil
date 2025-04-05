import 'dart:convert';

class Maestros{
  final int maestroId;
  final String nombre;
  final int materiaId;
  final String comentario;

  Maestros({
    required this.materiaId,
    required this.nombre,
    required this.maestroId,
    required this.comentario
  });

  factory Maestros.fromJson(Map<String, dynamic> json) {
    return Maestros(
        maestroId: json['maestroid'],
        nombre: utf8.decode(json['nombre'].toString().codeUnits),
        materiaId: json['materiaid'] ?? 0,
        comentario: utf8.decode(json['nombre'].toString().codeUnits)
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maestroid': maestroId,
      'nombre': nombre,
      'materiaid': materiaId,
      'comentario': comentario
    };
  }
}