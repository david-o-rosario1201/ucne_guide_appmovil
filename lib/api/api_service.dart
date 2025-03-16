import 'dart:convert';
import 'package:http/http.dart' as http;
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
}