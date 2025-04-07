import 'package:flutter/material.dart';
import 'package:ucne_guide/Modelos/materias.dart';
import 'package:ucne_guide/Presentation/drawer_menu.dart';
import 'package:ucne_guide/Presentation/perfil_materia_screen.dart';
import 'package:ucne_guide/api/api_service.dart';

class ConsultaAsignaturaScreen extends StatefulWidget {

  final int selectOption;

  const ConsultaAsignaturaScreen({super.key, required this.selectOption});

  @override
  State<ConsultaAsignaturaScreen> createState() => _ConsultaAsignaturaScreenState();
}

class _ConsultaAsignaturaScreenState extends State<ConsultaAsignaturaScreen> {
  final Api_Service apiService = Api_Service();
  late Future<List<Materias>> futureMaterias;
  String searchQuery = "";

  final Map<int, String> options = {
    0: "Todas",
    1: "Ingeniería",
    2: "Salud",
    3: "Educación",
  };

  late int selectedOptionId;

  @override
  void initState() {
    super.initState();
    futureMaterias = apiService.getMaterias();
    selectedOptionId = widget.selectOption;
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

                    final materias = snapshot.data!;

                    // Primero: filtrar por facultad
                    final filtradasPorFacultad = selectedOptionId == 0
                        ? materias
                        : materias.where((m) => m.facultadId == selectedOptionId).toList();

                    // Luego: filtrar por búsqueda
                    final filteredMaterias = filtradasPorFacultad
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
                                  Icons.arrow_forward,
                                  color: Colors.white
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
