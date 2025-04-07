import 'dart:convert';

class Materias {
  final int materiaId;
  final String nombre;
  final int facultadId;
  final String codigoMateria;
  final String descripcion;

  Materias({
    required this.materiaId,
    required this.nombre,
    required this.facultadId,
    required this.codigoMateria,
    required this.descripcion
  });

  factory Materias.fromJson(Map<String, dynamic> json) {
    return Materias(
      materiaId: json['materiaid'] ?? 0,
      nombre: utf8.decode(json['nombre'].toString().codeUnits),
      facultadId: json['facultadid'] ?? 0,
      codigoMateria: utf8.decode(json['codigomateria'].toString().codeUnits),
      descripcion: utf8.decode(json['Descripcion'].toString().codeUnits)
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'materiaid': materiaId,
      'nombre': nombre,
      'facultadid': facultadId,
      'codigoMateria': codigoMateria,
      'Descripcion': descripcion
    };
  }
}
