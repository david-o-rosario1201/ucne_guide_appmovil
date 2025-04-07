import 'package:flutter/material.dart';
import 'package:ucne_guide/Presentation/consulta_asignatura_screen.dart';
import 'package:ucne_guide/Presentation/consulta_maestro_screen.dart';
import 'package:ucne_guide/Presentation/drawer_menu.dart';
import 'package:ucne_guide/Presentation/home_screen_admin.dart';
import 'package:ucne_guide/Presentation/home_screen_estudiante.dart';

import '../SharedPreferences/sharedPreferencesService.dart';
import '../api/api_service.dart';
import 'inicio_sesion_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final SharedPreferencesService _prefsService = SharedPreferencesService();
  String? estudiante = "";

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
    navegar();
  }

  void navegar() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (estudiante == "No user saved") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => InicioSesionScreen()),
        );
      } else if(estudiante == "Admin"){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreenAdmin()),
        );
      } else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreenEstudiante()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
