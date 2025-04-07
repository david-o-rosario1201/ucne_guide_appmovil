import 'package:flutter/material.dart';
import 'package:ucne_guide/Modelos/estudiantes.dart';

import '../api/api_service.dart';
import 'drawer_menu.dart';

class ConsultaEstudianteScreen extends StatefulWidget {
  const ConsultaEstudianteScreen({super.key});

  @override
  State<ConsultaEstudianteScreen> createState() => _ConsultaEstudianteScreenState();
}

class _ConsultaEstudianteScreenState extends State<ConsultaEstudianteScreen> {
  final Api_Service apiService = Api_Service();
  late Future<List<Estudiantes>> futureEstudiantes;
  String searchQuery = "";

  final Map<int, String> options = {
    0: "Todos",
    1: "Ingeniería",
    2: "Salud",
    3: "Educación",
  };

  int selectedOptionId = 0;

  @override
  void initState() {
    super.initState();
    futureEstudiantes = apiService.getEstudiantes();
  }

  @override
  Widget build(BuildContext context) {
    return DrawerMenu(
        title: "Consulta de Estudiante",
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              // 🔍 Barra de búsqueda
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.black54),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Buscar estudiante",
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value.toLowerCase();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
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
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
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
                child: FutureBuilder<List<Estudiantes>>(
                  future: futureEstudiantes,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text("No hay estudiantes disponibles"));
                    } else {
                      final estudiantes = snapshot.data!;

                      // Primero: filtrar por facultad
                      final filtradasPorFacultad = selectedOptionId == 0
                          ? estudiantes
                          : estudiantes.where((m) =>
                      m.carreraid == selectedOptionId).toList();

                      // Luego: filtrar por búsqueda
                      final filteredMaterias = filtradasPorFacultad
                          .where((estudiante) =>
                          estudiante.nombre.toLowerCase()
                              .contains(searchQuery))
                          .toList();

                      return ListView.builder(
                        itemCount: filteredMaterias.length,
                        itemBuilder: (context, index) {
                          final estudiante = filteredMaterias[index];

                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              title: Text(
                                estudiante.nombre,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: FutureBuilder<String>(
                                future: apiService.getFacultadDeEstudiante(
                                    estudiante),
                                builder: (context, snapshot) {
                                  return Text("Facultad: ${snapshot.data}");
                                },
                              )
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
