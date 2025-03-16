import 'dart:convert';

class Facultad{
  final int facultadId;
  final String nombre;

  Facultad({
    required this.facultadId,
    required this.nombre
  });

  factory Facultad.fromJson(Map<String, dynamic> json) {
    return Facultad(
        facultadId: json['facultadid'],
        nombre: utf8.decode(json['nombre'].toString().codeUnits)
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'facultadid': facultadId,
      'nombre': nombre
    };
  }
}