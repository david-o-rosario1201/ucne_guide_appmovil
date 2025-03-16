import 'package:flutter/material.dart';
import 'package:ucne_guide/Modelos/materias.dart';
import 'package:ucne_guide/api/api_service.dart';

import 'drawer_menu.dart';

class PerfilMateriaScreen extends StatefulWidget {
  final int materiaId;

  const PerfilMateriaScreen({super.key, required this.materiaId});

  @override
  State<PerfilMateriaScreen> createState() => _PerfilMateriaScreenState();
}

class _PerfilMateriaScreenState extends State<PerfilMateriaScreen> {

  final Api_Service apiService = Api_Service();
  late Future futureMateria;

  @override
  void initState(){
    super.initState();
    futureMateria = apiService.getMateria(widget.materiaId);
  }

  @override
  Widget build(BuildContext context) {
    return DrawerMenu(
      title: "Perfil de Materia",
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Materias>(
          future: apiService.getMateria(widget.materiaId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data available.'));
            } else {
              final materia = snapshot.data!;  // Unwrap the data

              return Column(
                children: [
                  const SizedBox(height: 20),
                  Image(
                    image: AssetImage('assets/libros.png'),
                    width: 100,
                  ),
                  const SizedBox(height: 20),
                  ProfileField(label: "Materia", value: materia.nombre),
                  FutureBuilder<String>(
                    future: apiService.getFacultadDeMateria(materia),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return ProfileField(label: "Facultad", value: snapshot.data ?? "Desconocido");
                      }
                    },
                  ),
                  ProfileField(label: "Código de Materia", value: materia.codigoMateria)
                ],
              );
            }
          },
        ),
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
        const SizedBox(height: 15),
      ],
    );
  }
}