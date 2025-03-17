import 'package:flutter/material.dart';
import 'package:ucne_guide/Modelos/materias.dart';
import 'package:ucne_guide/Presentation/drawer_menu.dart';
import 'package:ucne_guide/Presentation/perfil_materia_screen.dart';
import 'package:ucne_guide/api/api_service.dart';

class ConsultaAsignaturaScreen extends StatefulWidget {
  const ConsultaAsignaturaScreen({super.key});

  @override
  State<ConsultaAsignaturaScreen> createState() => _ConsultaAsignaturaScreenState();
}

class _ConsultaAsignaturaScreenState extends State<ConsultaAsignaturaScreen> {
  final Api_Service apiService = Api_Service();
  late Future<List<Materias>> futureMaterias;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    futureMaterias = apiService.getMaterias();
  }

  @override
  Widget build(BuildContext context) {
    return DrawerMenu(
      title: "Consulta de Materias",
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
                        hintText: "Buscar materia",
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
            Expanded(
              child: FutureBuilder<List<Materias>>(
                future: futureMaterias,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No hay materias disponibles"));
                  } else {
                    // Filtrar por búsqueda
                    final filteredMaterias = snapshot.data!
                        .where((materia) => materia.nombre.toLowerCase().contains(searchQuery))
                        .toList();

                    return ListView.builder(
                      itemCount: filteredMaterias.length,
                      itemBuilder: (context, index) {
                        final materia = filteredMaterias[index];

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(
                              materia.nombre,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: FutureBuilder<String>(
                              future: apiService.getFacultadDeMateria(materia),
                              builder: (context, snapshot) {
                                return Text("Facultad: ${snapshot.data}");
                              },
                            ),
                            trailing: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => PerfilMateriaScreen(materiaId: materia.materiaId))
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Icon(
                                Icons.remove_red_eye_outlined,
                                color: Colors.white,
                              )
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
