import 'package:flutter/material.dart';
import 'package:ucne_guide/Presentation/home_screen.dart';
import 'package:ucne_guide/Presentation/home_screen_admin.dart';
import 'package:ucne_guide/Presentation/inicio_sesion_screen.dart';

import 'SharedPreferences/sharedPreferencesService.dart';

void main() {
  runApp(MaterialApp(
    home: VerificarUsuarioLoggeado(),
  ));
}

class VerificarUsuarioLoggeado extends StatefulWidget {
  const VerificarUsuarioLoggeado({super.key});

  @override
  State<VerificarUsuarioLoggeado> createState() => _VerificarUsuarioLoggeadoState();
}

class _VerificarUsuarioLoggeadoState extends State<VerificarUsuarioLoggeado> {

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
      } else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

