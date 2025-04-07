import 'package:flutter/material.dart';
import 'package:ucne_guide/Modelos/facultad.dart';
import 'package:ucne_guide/Presentation/drawer_menu.dart';
import 'package:ucne_guide/Presentation/modificar_estudiante_dialog.dart';

import '../Modelos/estudiantes.dart';
import '../SharedPreferences/sharedPreferencesService.dart';
import '../api/api_service.dart';

class PerfilEstudianteScreen extends StatefulWidget {
  const PerfilEstudianteScreen({super.key});

  @override
  State<PerfilEstudianteScreen> createState() => _PerfilEstudianteScreenState();
}

class _PerfilEstudianteScreenState extends State<PerfilEstudianteScreen> {
  final SharedPreferencesService _prefsService = SharedPreferencesService();
  final Api_Service apiService = Api_Service();

  late Future<void> _cargaDatos;

  late Estudiantes estudiante;
  late Facultad facultad;

  @override
  void initState() {
    super.initState();
    _cargaDatos = _loadData();
  }

  Future<void> _loadData() async {
    String username = await _prefsService.loadUsername();
    estudiante = await apiService.getEstudiantePorNombre(username);
    facultad = await apiService.getFacultad(estudiante.carreraid);
  }

  @override
  Widget build(BuildContext context) {
    return DrawerMenu(
      title: "Perfil de Estudiante",
      body: FutureBuilder(
        future: _cargaDatos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Image(
                    image: AssetImage('assets/colega.png'),
                    width: 100,
                  ),
                  const SizedBox(height: 20),
                  ProfileField(label: "Nombre", value: estudiante.nombre),
                  ProfileField(label: "Facultad", value: facultad.nombre),
                  ProfileField(label: "Matrícula", value: estudiante.matricula),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ModificarEstudianteDialog(estudiante: estudiante)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB0263F),
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Modificar",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}



class ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const ProfileField({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(value, style: const TextStyle(fontSize: 16)),
        ),
        const SizedBox(height: 15)
      ],
    );
  }
}