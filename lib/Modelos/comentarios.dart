import 'dart:convert';

class Comentarios{
  final int? comentarioid;
  final int materiaid;
  final int estudianteid;
  final String contenido;

  Comentarios({
   required this.comentarioid,
   required this.materiaid,
   required this.estudianteid,
   required this.contenido
  });

  factory Comentarios.fromJson(Map<String, dynamic> json) {
    return Comentarios(
      comentarioid: json['comentarioid'] as int?,
      materiaid: json['materiaid'] ?? 0,
      estudianteid: json['estudianteid'] ?? "",
      contenido: utf8.decode(json['contenido'].toString().codeUnits),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comentarioid': comentarioid,
      'materiaid': materiaid,
      'estudianteid': estudianteid,
      'contenido': contenido
    };
  }
}