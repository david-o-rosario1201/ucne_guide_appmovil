import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ucne_guide/Modelos/comentarios.dart';
import 'package:ucne_guide/Modelos/estudiantes.dart';
import 'package:ucne_guide/Modelos/facultad.dart';
import 'package:ucne_guide/Modelos/maestros.dart';
import 'package:ucne_guide/Modelos/materias.dart';

class Api_Service{
  final String baseUrl = "https://ucneguide-api.onrender.com";

  //facultad
  Future<Facultad> getFacultad(int facultadId) async {
    final endpoint = await http.get(Uri.parse('$baseUrl/facultad/$facultadId'));

    print("Respuesta de la API: ${endpoint.body}");

    if (endpoint.statusCode == 200) {
      final dynamic data = json.decode(endpoint.body);

      if (data is List && data.isNotEmpty) {
        return Facultad.fromJson(data[0]); // Tomar el primer objeto si es una lista
      } else if (data is Map<String, dynamic>) {
        return Facultad.fromJson(data); // Si ya es un objeto, devolverlo directamente
      } else {
        throw Exception("Formato de datos inesperado");
      }
    } else {
      throw Exception("Error al cargar la facultad");
    }
  }


  Future<List<Facultad>> getFacultades() async{
    final endpoint = await http.get(Uri.parse('$baseUrl/facultad'));

    if(endpoint.statusCode == 200){
      List<dynamic> data = json.decode(endpoint.body);
      return data.map((json) => Facultad.fromJson(json)).toList();
    } else{
      throw Exception("Error al cargar las facultades");
    }
  }

  Future<Facultad> createFacultad(Facultad facultad) async{
    final endpoint = await http.post(
        Uri.parse('$baseUrl/facultad?nombre=${facultad.nombre}'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'facultadId': facultad.facultadId,
          'nombre': facultad.nombre
        })
    );

    if (endpoint.statusCode == 201) {
      return Facultad.fromJson(json.decode(endpoint.body));
    } else {
      throw Exception("Error al crear la facultad");
    }
  }

  //facultad_materia
  Future<String> getFacultadDeMateria(Materias materia) async {
    final facultad = await getFacultad(materia.facultadId);
    return facultad.nombre;
  }


  //materias
  Future<Materias> getMateria(int materiaId) async{
    final endpoint = await http.get(Uri.parse('$baseUrl/materias/$materiaId'));

    if(endpoint.statusCode == 200){
      final List<dynamic> data = json.decode(endpoint.body);
      return Materias.fromJson(data[0]);
    } else{
      throw Exception("Error al cargar la materia");
    }
  }

  Future<List<Materias>> getMaterias() async{
    final endpoint = await http.get(Uri.parse('$baseUrl/materias'));

    if(endpoint.statusCode == 200){
      List<dynamic> data = json.decode(endpoint.body);
      return data.map((json) => Materias.fromJson(json)).toList();
    } else{
      throw Exception("Error al cargar las materias");
    }
  }

  Future<Facultad> createMateria(Materias materia) async{
    final endpoint = await http.post(
        Uri.parse('$baseUrl/facultad?nombre='),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'materiaId': materia.facultadId,
          'nombre': materia.nombre,
          'facultadId': materia.facultadId,
          'codigoMateria': materia.codigoMateria,
        })
    );

    if (endpoint.statusCode == 201) {
      return Facultad.fromJson(json.decode(endpoint.body));
    } else {
      throw Exception("Error al crear la materia");
    }
  }

  //facultad_materia
  Future<String> getMateriaDeMaestro(Maestros maestro) async {
    final materia = await getMateria(maestro.maestroId);
    return materia.nombre;
  }

  //facultad_maestro
  Future<String> getFacultadMaestro(int materiaId) async {
    final materia = await getMateria(materiaId);
    final facultad = await getFacultad(materia.facultadId);
    return facultad.nombre;
  }

  //maestros
  Future<Maestros> getMaestro(int maestroId) async{
    final endpoint = await http.get(Uri.parse('$baseUrl/maestros/$maestroId'));

    if(endpoint.statusCode == 200){
      final List<dynamic> data = json.decode(endpoint.body);
      return Maestros.fromJson(data[0]);
    } else{
      throw Exception("Error al cargar el maestro");
    }
  }

  Future<List<Maestros>> getMaestros() async{
    final endpoint = await http.get(Uri.parse('$baseUrl/maestros'));

    if(endpoint.statusCode == 200){
      List<dynamic> data = json.decode(endpoint.body);
      return data.map((json) => Maestros.fromJson(json)).toList();
    } else{
      throw Exception("Error al cargar los maestros");
    }
  }

  Future<Maestros> createMaestro(Maestros maestro) async{
    final endpoint = await http.post(
        Uri.parse('$baseUrl/facultad?nombre='),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'maestroid': maestro.maestroId,
          'nombre': maestro.nombre,
          'materiaid': maestro.materiaId,
        })
    );

    if (endpoint.statusCode == 201) {
      return Maestros.fromJson(json.decode(endpoint.body));
    } else {
      throw Exception("Error al crear al maestro");
    }
  }

  //maestros_materia
  Future<List<Maestros>> getMaestrosMateria(int materiaId) async{
    final maestros = await getMaestros();
    final maestrosMateria = maestros.where((maestro) => maestro.materiaId == materiaId).toList();
    return maestrosMateria;
  }

  //materias_maestro
  Future<List<Materias>> getMateriasMaestro(int materiaId) async{
    final materias = await getMaterias();
    final materiasMaestro = materias.where((materia) => materia.materiaId == materiaId).toList();
    return materiasMaestro;
  }

  //estudiantes
  Future<Estudiantes> getEstudiante(int estudianteId) async{
    final endpoint = await http.get(Uri.parse('$baseUrl/estudiantes/$estudianteId'));

    if(endpoint.statusCode == 200){
      final List<dynamic> data = json.decode(endpoint.body);
      return Estudiantes.fromJson(data[0]);
    } else{
      throw Exception("Error al cargar el estudiante");
    }
  }

  Future<List<Estudiantes>> getEstudiantes() async{
    final endpoint = await http.get(Uri.parse('$baseUrl/estudiantes'));

    if(endpoint.statusCode == 200){
      List<dynamic> data = json.decode(endpoint.body);
      return data.map((json) => Estudiantes.fromJson(json)).toList();
    } else{
      throw Exception("Error al cargar los estudiantes");
    }
  }

  Future<Estudiantes> createEstudiante(Estudiantes estudiante) async{
    final endpoint = await http.post(
        Uri.parse('$baseUrl/estudiantes?nombre=${estudiante.nombre}&carreraid=${estudiante.carreraid}&matricula=${estudiante.matricula}'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'estudianteid': estudiante.estudianteid,
          'nombre': estudiante.nombre,
          'carreraid': estudiante.carreraid,
          'matricula': estudiante.matricula
        })
    );

    if (endpoint.statusCode >= 200 && endpoint.statusCode < 300) {
      return Estudiantes.fromJson(json.decode(endpoint.body));
    } else {
      throw Exception("Error al crear al estudiante: ${endpoint.body}");
    }
  }

  //Buscar nombre estudiante
  Future<Estudiantes> getEstudiantePorNombre(String nombre) async {
    final estudiantes = await getEstudiantes();
    final estudiante = estudiantes.firstWhere(
          (estudiante) => estudiante.nombre.toLowerCase() == nombre.toLowerCase(),
      orElse: () => Estudiantes(estudianteid: 0, nombre: '', carreraid: 0, matricula: ''),
    );

    return estudiante;
  }

  //Buscar matricula estudiante
  Future<String?> getEstudiantePorMatricula(String matricula) async {
    final estudiantes = await getEstudiantes();
    final estudiante = estudiantes.firstWhere(
          (estudiante) => estudiante.matricula == matricula,
      orElse: () => Estudiantes(estudianteid: 0, nombre: '', carreraid: 0, matricula: ''),
    );

    return estudiante.matricula.isNotEmpty ? estudiante.matricula : null;
  }

  //user and password correctas
  Future<bool> isUserAndPasswordCorrect(String nombre, String matricula) async {
    final estudiantes = await getEstudiantes();
    final estudiante = estudiantes.firstWhere(
          (estudiante) => estudiante.matricula == matricula && estudiante.nombre == nombre,
      orElse: () => Estudiantes(estudianteid: 0, nombre: '', carreraid: 0, matricula: ''),
    );

    return estudiante.matricula.isNotEmpty ? true : false;
  }

  //Comentarios
  Future<List<Comentarios>> getComentariosPorEstudianteYMateria(int estudianteId, int materiaId) async{
    final endpoint = await http.get(Uri.parse('$baseUrl/comentarios/$estudianteId/$materiaId'));

    if(endpoint.statusCode == 200){
      List<dynamic> data = json.decode(endpoint.body);
      return data.map((json) => Comentarios.fromJson(json)).toList();
    } else{
      throw Exception("Error al cargar los comentarios");
    }
  }

  Future<List<Comentarios>> getComentarios() async{
    final endpoint = await http.get(Uri.parse('$baseUrl/comentarios'));

    if(endpoint.statusCode == 200){
      List<dynamic> data = json.decode(endpoint.body);
      return data.map((json) => Comentarios.fromJson(json)).toList();
    } else{
      throw Exception("Error al cargar los comentarios");
    }
  }

  Future<Comentarios> createComentario(Comentarios comentario) async{
    final endpoint = await http.post(
        Uri.parse('$baseUrl/comentarios?materiaid=${comentario.materiaid}&estudianteid=${comentario.estudianteid}&contenido=${comentario.contenido}'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'comentarioid': comentario.comentarioid,
          'materiaid': comentario.materiaid,
          'estudianteid': comentario.estudianteid,
          'contenido': comentario.contenido
        })
    );

    if (endpoint.statusCode >= 200 && endpoint.statusCode < 300) {
      return Comentarios.fromJson(json.decode(endpoint.body));
    } else {
      throw Exception("Error al crear el comentario: ${endpoint.body}");
    }
  }

  //getcomentarios por materia
  Future<List<Comentarios>> getComentariosPorMateria(int materiaId) async{
    final comentarios = await getComentarios();
    final comentariosFiltrados = comentarios.where((comentario) => comentario.materiaid == materiaId).toList();
    return comentariosFiltrados;
  }
}