import 'package:flutter/material.dart';
import 'package:ucne_guide/Presentation/comentarios_screen.dart';
import 'package:ucne_guide/Presentation/consulta_estudiante_screen.dart';
import 'package:ucne_guide/Presentation/consulta_maestro_screen.dart';
import 'package:ucne_guide/Presentation/facultad_screen.dart';

import '../SharedPreferences/sharedPreferencesService.dart';
import '../api/api_service.dart';
import 'consulta_asignatura_screen.dart';
import 'drawer_menu.dart';

class HomeScreenAdmin extends StatefulWidget {
  const HomeScreenAdmin({super.key});

  @override
  State<HomeScreenAdmin> createState() => _HomeScreenAdminState();
}

class _HomeScreenAdminState extends State<HomeScreenAdmin> {

  final Api_Service apiService = Api_Service();
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  String estudiante = "";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    String username = await _prefsService.loadUsername();
    setState(() {
      estudiante = username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DrawerMenu(
      title: "HomeScreen",
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.blue[50],
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        child: Row(
                          children: [
                            Text(
                              "👋",
                              style: TextStyle(fontSize: 36),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "¡Hola, $estudiante!",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Esperamos que tengas un excelente día 😊",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    Text(
                      "Materias",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      ),
                    ),
                    Divider(),
                    Row(
                      children: <Widget>[
                        _buildCard("Consulta", "assets/libros.png",() {
                          Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ConsultaAsignaturaScreen(selectOption: 0)),
                      );
                        }),
                        SizedBox(width: 30.0),
                        _buildCard("Crear","assets/book.png", () {
                          /*Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ConsultaAsignaturaScreen()),
                      );*/
                        })
                      ],
                    ),
                    SizedBox(height: 40),
                    Text(
                      "Maestros",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                    ),
                    Divider(),
                    Row(
                      children: <Widget>[
                        _buildCard("Consulta", "assets/classroom.png",() {
                          Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ConsultaMaestroScreen()),
                      );
                        }),
                        SizedBox(width: 30.0),
                        _buildCard("Crear","assets/dean.png", () {
                          /*Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ConsultaAsignaturaScreen()),
                      );*/
                        })
                      ],
                    ),
                    SizedBox(height: 40),
                    Text(
                      "Facultades",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                    ),
                    Divider(),
                    Row(
                      children: <Widget>[
                        _buildCard("Consulta", "assets/graduation.png",() {
                          Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FacultadScreen()),
                      );
                        }),
                        SizedBox(width: 30.0),
                        _buildCard("Crear","assets/graduation-hat.png", () {
                          /*Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ConsultaAsignaturaScreen()),
                      );*/
                        })
                      ],
                    ),
                    SizedBox(height: 40),
                    Text(
                      "Estudiantes",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                    ),
                    Divider(),
                    Row(
                      children: <Widget>[
                        _buildCard("Consulta", "assets/group.png",() {
                          Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ConsultaEstudianteScreen()),
                      );
                        }),
                        SizedBox(width: 30.0),
                        _buildCard("Comment","assets/comments.png", () {
                          Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ComentariosScreen()),
                      );
                        })
                      ],
                    ),
                  ],
                )
              ],
            ),
          )
      ),
    );
  }
}

Widget _buildCard(String text, String imagen, VoidCallback onTap) {
  return Expanded(
    child: Card(
      color: Colors.grey[300],
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.blueAccent.withOpacity(0.2),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                imagen,
                width: 60,
                height: 60,
              ),
              SizedBox(height: 10),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
