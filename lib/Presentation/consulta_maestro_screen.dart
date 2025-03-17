import 'package:flutter/material.dart';
import 'package:ucne_guide/Modelos/maestros.dart';
import 'package:ucne_guide/Presentation/drawer_menu.dart';
import 'package:ucne_guide/Presentation/perfil_maestro_screen.dart';

import '../api/api_service.dart';

class ConsultaMaestroScreen extends StatefulWidget {
  const ConsultaMaestroScreen({super.key});

  @override
  State<ConsultaMaestroScreen> createState() => _ConsultaMaestroScreenState();
}

class _ConsultaMaestroScreenState extends State<ConsultaMaestroScreen> {

  final Api_Service apiService = Api_Service();
  late Future<List<Maestros>> futureMaestros;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    futureMaestros = apiService.getMaestros();
  }

  @override
  Widget build(BuildContext context) {
    return DrawerMenu(
      title: "Consulta de Maestros",
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
                        hintText: "Buscar maestro",
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
              child: FutureBuilder<List<Maestros>>(
                future: futureMaestros,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No hay materias disponibles"));
                  } else {
                    // Filtrar por búsqueda
                    final filteredMaestros = snapshot.data!
                        .where((materia) => materia.nombre.toLowerCase().contains(searchQuery))
                        .toList();

                    return ListView.builder(
                      itemCount: filteredMaestros.length,
                      itemBuilder: (context, index) {
                        final maestro = filteredMaestros[index];

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(
                              maestro.nombre,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: FutureBuilder<String>(
                              future: apiService.getMateriaDeMaestro(maestro),
                              builder: (context, snapshot) {
                                return Text("Materia: ${snapshot.data}");
                              },
                            ),
                            trailing: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => PerfilMaestroScreen(maestroId: maestro.maestroId))
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
