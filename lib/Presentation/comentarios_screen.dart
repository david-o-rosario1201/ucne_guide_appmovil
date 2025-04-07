import 'package:flutter/material.dart';
import 'package:ucne_guide/Modelos/comentarios.dart';
import 'package:ucne_guide/Modelos/estudiantes.dart';
import 'package:ucne_guide/Modelos/facultad.dart';
import 'package:ucne_guide/Modelos/materias.dart';

import '../SharedPreferences/sharedPreferencesService.dart';
import '../api/api_service.dart';
import 'drawer_menu.dart';

class ComentariosScreen extends StatefulWidget {
  const ComentariosScreen({super.key});

  @override
  State<ComentariosScreen> createState() => _ComentariosScreenState();
}

class _ComentariosScreenState extends State<ComentariosScreen> {

  final Api_Service apiService = Api_Service();
  final SharedPreferencesService _prefsService = SharedPreferencesService();
  late Future<List<Comentarios>> futureComentarios;
  late Future<List<Materias>> futureMaterias;
  late Future<List<Facultad>> futureFacultades;
  late Estudiantes estudiante;
  String nombreEstudiante = "";
  String searchQuery = "";

  final Map<int, String> options = {
    0: "Todos",
    1: "Ingeniería",
    2: "Salud",
    3: "Educación",
    4: "Mis Comentarios"
  };

  int selectedOptionId = 0;

  @override
  void initState() {
    super.initState();
    futureComentarios = apiService.getComentarios();
    futureFacultades = apiService.getFacultades();
    futureMaterias = apiService.getMaterias();
    _loadData();
  }

  Future<void> _loadData() async {
    String username = await _prefsService.loadUsername();
    setState(() {
      nombreEstudiante = username;
    });
    estudiante = await apiService.getEstudiantePorNombre(nombreEstudiante ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return DrawerMenu(
        title: "Comentarios",
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 10),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: options.entries.map((entry) {
                    final int optionId = entry.key;
                    final String optionLabel = entry.value;
                    final bool isSelected = optionId == selectedOptionId;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: ChoiceChip(
                        label: Text(
                          optionLabel,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.blue[800],
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            selectedOptionId = optionId;
                          });
                        },
                        selectedColor: Color(0xFF1976D2),
                        backgroundColor: Color(0xFFE3F2FD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),


              SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: Future.wait([futureComentarios, futureMaterias]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No hay datos disponibles"));
                    } else {

                      final comentarios = snapshot.data![0] as List<Comentarios>;
                      final materias = snapshot.data![1] as List<Materias>;

                      // Primero: filtrar por facultad
                      
                      
                      List<Comentarios> filteredComentarios;

                      if (selectedOptionId == 4) {
                        filteredComentarios = comentarios.where((c) =>
                        c.estudianteid == estudiante.estudianteid).toList();
                      }
                      else{
                        filteredComentarios = selectedOptionId == 0
                            ? comentarios
                            : comentarios.where((c) =>
                            materias.any((m) => m.materiaId == c.materiaid && m.facultadId == selectedOptionId)
                        ).toList();
                      }

                      // Luego: filtrar por búsqueda
                      /*final filteredMaterias = filtradasPorFacultad
                          .where((materia) => materia.nombre.toLowerCase().contains(searchQuery))
                          .toList();*/

                      return ListView.builder(
                        itemCount: filteredComentarios.length,
                        itemBuilder: (context, index) {
                          final comentario = filteredComentarios[index];

                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              title: Text(
                                comentario.contenido,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: FutureBuilder<String>(
                                future: apiService.getNombreEstudiante(comentario.estudianteid),
                                builder: (context, snapshot) {
                                  return Text("Estudiante: ${snapshot.data}");
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        )
    );
  }
}
