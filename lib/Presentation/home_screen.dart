import 'package:flutter/material.dart';
import 'package:ucne_guide/Presentation/consulta_asignatura_screen.dart';
import 'package:ucne_guide/Presentation/consulta_maestro_screen.dart';
import 'package:ucne_guide/Presentation/drawer_menu.dart';

import '../SharedPreferences/sharedPreferencesService.dart';
import '../api/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        child: Column(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 40),
                Text(
                  "Bienvenido/a, $estudiante",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                _buildCard("Consulta de Materias", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConsultaAsignaturaScreen()),
                  );
                }),
                _buildCard("Consulta de Maestros", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConsultaMaestroScreen()),
                  );
                }),
                _buildCard("Calificar Maestro", () {})
              ],
            )
          ],
        )
      ),
    );
  }
}

Widget _buildCard(String text, VoidCallback onTap) {
  return Card(
    color: Color(0xFFD1CCB6),
    margin: EdgeInsets.symmetric(vertical: 10),
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ),
    ),
  );
}
