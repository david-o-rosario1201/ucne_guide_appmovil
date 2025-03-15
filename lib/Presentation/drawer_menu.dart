import 'package:flutter/material.dart';
import 'package:ucne_guide/Presentation/consulta_asignatura_screen.dart';
import 'package:ucne_guide/Presentation/consulta_maestro_screen.dart';
import 'package:ucne_guide/Presentation/home_screen.dart';
import 'package:ucne_guide/Presentation/perfil_estudiante_screen.dart';

class DrawerMenu extends StatelessWidget {
  final Widget body;
  final String title;

  const DrawerMenu({super.key, required this.body, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFB0263F),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body: body,
    );
  }
}

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFFB0263F)),
            child: Text(
              "Menú",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.black),
            title: Text("Home"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.school, color: Colors.black),
            title: Text("Consulta de Asignaturas"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ConsultaAsignaturaScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person_search, color: Colors.black),
            title: Text("Consulta de Maestros"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ConsultaMaestroScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.star, color: Colors.black),
            title: Text("Calificar Maestro"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ConsultaMaestroScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.black),
            title: Text("Perfil"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PerfilEstudianteScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.black),
            title: Text("Nosotros"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ConsultaAsignaturaScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.black),
            title: Text("Log Out"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ConsultaAsignaturaScreen()),
              );
            },
          )
        ],
      ),
    );
  }
}
