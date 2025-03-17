import 'package:flutter/material.dart';
import 'package:ucne_guide/Presentation/consulta_asignatura_screen.dart';
import 'package:ucne_guide/Presentation/consulta_maestro_screen.dart';
import 'package:ucne_guide/Presentation/drawer_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DrawerMenu(
      title: "HomeScreen",
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
        ),
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
