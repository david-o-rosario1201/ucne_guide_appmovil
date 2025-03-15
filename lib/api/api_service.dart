import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ucne_guide/Modelos/facultad.dart';

class Api_Service{
  final String baseUrl = "https://ucneguide-api.onrender.com";

  Future<Facultad> getFacultad(int facultadId) async{
    final endpoint = await http.get(Uri.parse('$baseUrl/facultad/$facultadId'));

    if(endpoint.statusCode == 200){
      final Map<String, dynamic> data = json.decode(endpoint.body);
      return Facultad.fromJson(data);
    } else{
      throw Exception("Error al cargar las facultades");
    }
  }

  Future<List<Facultad>> getFacultades() async{
    final endpoint = await http.get(Uri.parse('$baseUrl/facultad'));

    print(endpoint.statusCode);

    if(endpoint.statusCode == 200){
      List<dynamic> data = json.decode(endpoint.body);
      return data.map((json) => Facultad.fromJson(json)).toList();
    } else{
      throw Exception("Error al cargar las facultades");
    }
  }

  Future<Facultad> createFacultad(Facultad facultad) async{
    final endpoint = await http.post(
        Uri.parse('$baseUrl/facultad?nombre=',facultad.nombre),
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
}