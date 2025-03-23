import 'dart:convert';

class Estudiantes{
  final int? estudianteid;
  final String nombre;
  final int carreraid;
  final String matricula;

  Estudiantes({
    required this.estudianteid,
    required this.nombre,
    required this.carreraid,
    required this.matricula
  });

  factory Estudiantes.fromJson(Map<String, dynamic> json) {
    return Estudiantes(
        estudianteid: json['estudianteid'] as int?,
        nombre: utf8.decode(json['nombre'].toString().codeUnits),
        carreraid: json['carreraid'] ?? 0,
        matricula: json['matricula'] ?? ""
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'estudianteid': estudianteid,
      'nombre': nombre,
      'carreraid': carreraid,
      'matricula': matricula
    };
  }
}