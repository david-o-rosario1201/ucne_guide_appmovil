class Facultad{
  final facultadId;
  final nombre;

  Facultad({
    required this.facultadId,
    required this.nombre
  });

  factory Facultad.fromJson(Map<String, dynamic> json) {
    return Facultad(
        facultadId: json['facultadId'],
        nombre: json['nombre'] ?? "Sin nombre"
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'facultadId': facultadId,
      'nombre': nombre
    };
  }
}